import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/helpers/validators/form_validators.dart';
import 'package:fireguard_bo/core/mobile_core_auth/user_service_auth.dart';
import 'package:fireguard_bo/features/shared/app_shell/app_shell.dart';
import 'package:fireguard_bo/features/shared/widgets/custom_rich_text.dart';
import 'package:fireguard_bo/features/sign_in/presentation/page/sign_in_screen.dart';
import 'package:fireguard_bo/features/sign_up/data/services/auth_service.dart';
import 'package:fireguard_bo/features/sign_up/data/services/user_service.dart';
import 'package:fireguard_bo/features/sign_up/presentation/bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  static const String route = '/sign_up';
  final formKey = GlobalKey<FormState>();
  String userName = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(
        authRepo: FirebaseAuthAdapter(FirebaseAuth.instance),
        userService: UserService(FirebaseFirestore.instance),
      ),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            final userService = UserServiceAuth(FirebaseAuth.instance);
            if (userService.logged) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AppShell()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Algo salio mal al iniciar sesion'),
                ),
              );
            }
          } else if (state is SignUpErrorState) {
            // Show error dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Hubo algun error al crear usuario!')),
            );
          }
        },
        builder: (context, state) {
          return _Body(
            formKey: formKey,
            userName: userName,
            password: password,
            email: email,
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({
    required this.formKey,
    required this.userName,
    required this.password,
    required this.email,
  });

  final GlobalKey<FormState> formKey;
  String userName;
  String password;
  String email;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          validator: FormValidator.userName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Your username here',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          onChanged: (value) => userName = value,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          validator: FormValidator.email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Your email here',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          onChanged: (value) => email = value,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          validator: FormValidator.password,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Your password here',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          onChanged: (value) => password = value,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          validator: (value) => FormValidator.confirmPassword(
                            value,
                            password,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Confirm password here',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (state is SignUpLoadingState)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<SignUpBloc>().add(
                                      SignUpSubmittedEvent(
                                        userName: userName,
                                        email: email,
                                        password: password,
                                      ),
                                    );
                              }
                            },
                            child: const Text('Sign Up'),
                          ),
                        const SizedBox(height: 56),
                        CustomRichText(
                          text: 'Already have an Account?',
                          secondaryText: 'Sign In',
                          onTap: () => Navigator.pushNamed(context, SignInScreen.route),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
