import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fireguard_bo/features/shared/extensions/build_context.dart';
import 'package:fireguard_bo/features/sign_in/presentation/page/sign_in_screen.dart';
import 'package:fireguard_bo/features/sign_up/data/services/auth_service.dart';
import 'package:fireguard_bo/features/sign_up/data/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        authService: FirebaseAuthService(FirebaseAuth.instance),
        userService: UserService(FirebaseFirestore.instance),
      )..add(const LoadProfileEvent()),
      child: Scaffold(
        appBar: AppBar(),
        body: const _Page(),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccessState) {
          context.pushNamedAndRemoveUntil(
            SignInScreen.route,
          );
        }
      },
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProfileLoadedState) {
          final user = state.user;
          return Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const CircleAvatar(radius: 50),
                const SizedBox(height: 10),
                Text(
                  user.username,
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.email,
                  // style: context.theme.textTheme.bodyMedium?.copyWith(
                  //   color: Palette.darkGray,
                  // ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ProfileBloc>()
                        .add(const LogoutRequestedEvent());
                  },
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: Palette.darkGray,
                      ),
                  child: const Text(
                    'Sign Out',
                    // style: TextStyle(color: Palette.pink),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProfileErrorState) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
