import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/features/shared/app_shell/app_shell.dart';
import 'package:fireguard_bo/features/shared/extensions/build_context.dart';
import 'package:fireguard_bo/features/sign_in/presentation/page/sign_in_screen.dart';
import 'package:fireguard_bo/features/sign_up/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String route = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future<void>.delayed(
      const Duration(seconds: 3),
      () {
        final route = switch(FirebaseAuthService(FirebaseAuth.instance).logged) {
          true => AppShell.route,
          false => SignInScreen.route,
        };
        return context.pushReplacementNamed<void>(route);
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
