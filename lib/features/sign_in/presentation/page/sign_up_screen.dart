import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/helpers/validators/form_validators.dart';
import 'package:fireguard_bo/features/shared/app_shell/app_shell.dart';
import 'package:fireguard_bo/features/sign_in/data/services/auth_service.dart';
import 'package:fireguard_bo/features/sign_in/data/services/user_service.dart';
import 'package:fireguard_bo/features/sign_in/presentation/bloc/sign_up_bloc.dart';
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AppShell()));
          } else if (state is SignUpErrorState) {
            // Show error dialog
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
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Already have an Account?\n',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
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
