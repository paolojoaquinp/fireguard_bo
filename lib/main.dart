import 'package:firebase_core/firebase_core.dart';
import 'package:fireguard_bo/core/common/pages/splash_screen.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/page/home_screen.dart';
import 'package:fireguard_bo/features/profile/presentation/page/profile_screen.dart';
import 'package:fireguard_bo/features/shared/app_shell/app_shell.dart';
import 'package:fireguard_bo/features/sign_in/presentation/page/sign_in_screen.dart';
import 'package:fireguard_bo/features/sign_up/presentation/page/sign_up_screen.dart';
import 'package:fireguard_bo/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  
  MapboxOptions.setAccessToken(dotenv.get('MAPBOX_ACCESS_TOKEN'));
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
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
      routes: {
        SplashScreen.route: (_) => const SplashScreen(),
        SignUpScreen.route: (_) => SignUpScreen(),
        SignInScreen.route: (_) => const SignInScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
        ProfileScreen.route: (_) => const ProfileScreen(),
        AppShell.route: (_) => const AppShell()
      },
    );
  }
}
