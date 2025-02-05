import 'package:fireguard_bo/features/shared/app_shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  
  MapboxOptions.setAccessToken(dotenv.get('MAPBOX_ACCESS_TOKEN'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: AppShell(),
    );
  }
}
