import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/features/home_screen/presentation/children/contributions_bottom_sheet/presentation/presenter/page/widgets/add_news_bottom_sheet/bloc/add_news_bottom_sheet_bloc.dart';
import 'package:fireguard_bo/features/home_screen/data/services/incident_service.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/bloc/map_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewsBottomSheet extends StatelessWidget {
  const AddNewsBottomSheet({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddNewsBottomSheetBloc>(
          create: (context) => AddNewsBottomSheetBloc(),
        ),
        BlocProvider(
          create: (context) => MapPageBloc(
            incidentRepository: IncidentService(FirebaseFirestore.instance),
          ),
        ),
      ],
      child: _Page(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNewsBottomSheetBloc, AddNewsBottomSheetState>(
      listener: (context, state) {
        if (state is AddNewsBottomSheetSuccess) {
          // Refresh map data
          context.read<MapPageBloc>().add(const LoadUserLocation());
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incident reported successfully')),
          );
        } else if (state is AddNewsBottomSheetError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: _Body(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedType = 'fire';
  String _selectedStatus = 'active';
  int _selectedSeverity = 1;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewsBottomSheetBloc, AddNewsBottomSheetState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Report Incident',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Incident Type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'fire',
                      child: Text('Fire'),
                    ),
                    DropdownMenuItem(
                      value: 'wind',
                      child: Text('Wind'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'active',
                      child: Text('Active'),
                    ),
                    DropdownMenuItem(
                      value: 'contained',
                      child: Text('Contained'),
                    ),
                    DropdownMenuItem(
                      value: 'controlled',
                      child: Text('Controlled'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedSeverity,
                  decoration: const InputDecoration(
                    labelText: 'Severity Level',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Level 1 (Low)'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Level 2 (Medium)'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('Level 3 (High)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSeverity = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe the incident...',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: state is AddNewsBottomSheetLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              context.read<AddNewsBottomSheetBloc>().add(
                                    CreateIncidentEvent(
                                      reporterId: currentUser.uid,
                                      incidentType: _selectedType,
                                      status: _selectedStatus,
                                      severityLevel: _selectedSeverity,
                                      latitude: widget.latitude,
                                      longitude: widget.longitude,
                                      description: _descriptionController.text,
                                    ),
                                  );
                            }
                          }
                        },
                  child: state is AddNewsBottomSheetLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit Report'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
