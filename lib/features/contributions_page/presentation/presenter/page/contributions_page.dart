import 'package:flutter/material.dart';

class ContributionsPage extends StatelessWidget {
  const ContributionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Update the Map',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Grid of options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          alignment: WrapAlignment.start,
                          children: [
                            _buildOptionCard(
                              icon: Icons.local_fire_department,
                              label: 'Report a\nFire',
                              backgroundColor: const Color(0xFFFFE5E5),
                              iconColor: const Color(0xFFFF4545),
                            ),
                            _buildOptionCard(
                              icon: Icons.camera_alt,
                              label: 'Submit a\nPhoto',
                              backgroundColor: const Color(0xFFE5FFE5),
                              iconColor: const Color(0xFF22C55E),
                            ),
                            _buildOptionCard(
                              icon: Icons.thunderstorm,
                              label: 'Weather\nConditions',
                              backgroundColor: const Color(0xFFE5E5E5),
                              iconColor: const Color(0xFF666666),
                            ),
                            _buildOptionCard(
                              icon: Icons.warning,
                              label: 'Hazards',
                              backgroundColor: const Color(0xFFFFF5E5),
                              iconColor: const Color(0xFFFFA500),
                            ),
                            _buildOptionCard(
                              icon: Icons.directions_bus,
                              label: 'Road\nClosure',
                              backgroundColor: const Color(0xFFE5F5FF),
                              iconColor: const Color(0xFF3B82F6),
                            ),
                            _buildOptionCard(
                              icon: Icons.newspaper,
                              label: 'Make\na Publish',
                              backgroundColor: const Color.fromARGB(255, 242, 229, 255),
                              iconColor: const Color.fromARGB(255, 134, 59, 246),
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

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}