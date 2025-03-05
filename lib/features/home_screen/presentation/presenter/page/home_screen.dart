import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/map_page.dart';
import 'package:fireguard_bo/features/profile/presentation/page/profile_screen.dart';
import 'package:fireguard_bo/features/shared/extensions/build_context.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de incendios'),
        actions: [
          GestureDetector(
            onTap: () => context.pushNamed(ProfileScreen.route),
            child: CircleAvatar(
              child: Text('U'),
            ),
          ),
        ],
      ),
      body: const MapPage(),
    );
  }
}

