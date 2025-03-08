import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/map_page.dart';
import 'package:fireguard_bo/features/profile/presentation/page/profile_screen.dart';
import 'package:fireguard_bo/features/shared/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fireguard_bo/features/sign_up/data/services/auth_service.dart';
import 'package:fireguard_bo/features/sign_up/data/services/user_service.dart';
import 'package:fireguard_bo/features/sign_in/presentation/page/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        authService: FirebaseAuthService(FirebaseAuth.instance),
        userService: UserService(FirebaseFirestore.instance),
      )..add(const LoadProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mapa de incendios'),
          actions: [
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLogoutSuccessState) {
                  context.pushNamedAndRemoveUntil(SignInScreen.route);
                }
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => context.pushNamed(ProfileScreen.route),
                  child: CircleAvatar(
                    child: switch (state) {
                      ProfileLoadedState(user: final user) => Text(
                          user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U'
                        ),
                      _ => const Text('U'),
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: const MapPage(),
      ),
    );
  }
}

