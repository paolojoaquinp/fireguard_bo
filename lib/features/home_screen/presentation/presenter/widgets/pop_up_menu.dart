import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/features/home_screen/data/repositories_impl/services/subscription_service.dart';
import 'package:fireguard_bo/features/home_screen/presentation/children/contributions_bottom_sheet/presentation/presenter/page/contributions_bottom_sheet.dart';
import 'package:fireguard_bo/features/home_screen/presentation/children/contributions_bottom_sheet/presentation/presenter/page/widgets/add_news_bottom_sheet/add_news_bottom_sheet.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/subscription/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/bloc/map_page_bloc.dart';

class PopupMenu extends StatelessWidget {
  final Point point;
  final VoidCallback onClose;
  final VoidCallback onSubmit;
  final String? incidentId;

  const PopupMenu({
    super.key,
    required this.point,
    required this.onClose,
    required this.onSubmit,
    this.incidentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionBloc>(
      create: (context) => SubscriptionBloc(
        subscriptionRepository: SubscriptionService(FirebaseFirestore.instance),
      )..add(CheckSubscriptionStatusEvent(
          incidentId: incidentId ?? '',
          userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        )),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MenuItem(
                      icon: Icons.add_circle_outline,
                      label: 'Contribuir',
                      onTap: () {
                        Navigator.pop(context); // Close the popup first
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const ContributionsBottomSheet(),
                        );
                        // showModalBottomSheet(
                        //   context: context,
                        //   isScrollControlled: true,
                        //   builder: (context) => AddNewsBottomSheet(
                        //     latitude: point.coordinates.lat.toDouble(),
                        //     longitude: point.coordinates.lng.toDouble(),
                        //   ),
                        // );
                      },
                    ),
                    BlocConsumer<SubscriptionBloc, SubscriptionState>(
                      listener: (context, state) {
                        if (state is SubscriptionSuccess || state is UnsubscriptionSuccess) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state is SubscriptionSuccess 
                                    ? 'Suscripción exitosa'
                                    : 'Se ha cancelado la suscripción'
                              ),
                            ),
                          );
                        }
                        if (state is SubscriptionError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${state.message}'),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final bool isFollowing = state is SubscriptionExistsState;
                        
                        if (state is SubscriptionLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        
                        return _MenuItem(
                          icon: isFollowing ? Icons.notifications_active : Icons.person_outline,
                          label: isFollowing ? 'Siguiendo' : 'Seguir',
                          onTap: () {
                            final userId = FirebaseAuth.instance.currentUser?.uid;
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Necesitas iniciar sesión para seguir este incidente'),
                                ),
                              );
                              return;
                            }
                            
                            if (incidentId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No se puede seguir este punto'),
                                ),
                              );
                              return;
                            }
                            
                            if (isFollowing) {
                              // Unsubscribe
                              final subscription = (state as SubscriptionExistsState).subscription;
                              context.read<SubscriptionBloc>().add(
                                UnsubscribeFromIncidentEvent(
                                  subscriptionId: subscription.id,
                                ),
                              );
                            } else {
                              // Subscribe
                              context.read<SubscriptionBloc>().add(
                                SubscribeToIncidentEvent(
                                  incidentId: incidentId!,
                                  userId: userId,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
