import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/map_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de incendios'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Profile page'),
          Spacer(),
          ElevatedButton(onPressed: () {}, child: Text('Cerrar Sesion'))
        ],
      ),
    );
  }
}