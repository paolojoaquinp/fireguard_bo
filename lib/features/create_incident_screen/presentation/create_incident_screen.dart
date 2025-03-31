import 'dart:ui';

import 'package:fireguard_bo/features/create_incident_screen/presentation/widgets/build_option_card.dart';
import 'package:fireguard_bo/features/home_screen/presentation/children/contributions_bottom_sheet/presentation/presenter/page/widgets/add_news_bottom_sheet/add_news_bottom_sheet.dart';
import 'package:fireguard_bo/features/home_screen/presentation/children/photo_contribution/page/photo_contribution.dart';
import 'package:flutter/material.dart';

class CreateIncidentScreen extends StatelessWidget {
  const CreateIncidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Incidente'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            BuildOptionCard(
                              context: context,
                              icon: Icons.local_fire_department,
                              label: 'Reportar\nIncendio',
                              backgroundColor: const Color(0xFFFFE5E5),
                              iconColor: const Color(0xFFFF4545),
                            ),
                            BuildOptionCard(
                              context: context,
                              icon: Icons.camera_alt,
                              label: 'Enviar\nFoto',
                              backgroundColor: const Color(0xFFE5FFE5),
                              iconColor: const Color(0xFF22C55E),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const PhotoContribution();
                                  },
                                ),
                              ),
                            ),
                            BuildOptionCard(
                              context: context,
                              icon: Icons.thunderstorm,
                              label: 'Condiciones\nMeteorológicas',
                              backgroundColor: const Color(0xFFE5E5E5),
                              iconColor: const Color(0xFF666666),
                            ),
                            BuildOptionCard(
                              context: context,
                              icon: Icons.warning,
                              label: 'Peligros',
                              backgroundColor: const Color(0xFFFFF5E5),
                              iconColor: const Color(0xFFFFA500),
                            ),
                            // BuildOptionCard(
                            //   context: context,
                            //   icon: Icons.directions_bus,
                            //   label: 'Cierre de\nCarreteras',
                            //   backgroundColor: const Color(0xFFE5F5FF),
                            //   iconColor: const Color(0xFF3B82F6),
                            // ),
                            BuildOptionCard(
                              context: context,
                              icon: Icons.newspaper,
                              label: 'Publicar\nNoticia',
                              backgroundColor:
                                  const Color.fromARGB(255, 242, 229, 255),
                              iconColor: const Color.fromARGB(255, 134, 59, 246),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  barrierColor: Colors.transparent,
                                  builder: (context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 12, sigmaY: 12),
                                      child: AddNewsBottomSheet(
                                        latitude: 0,
                                        longitude: 0,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
