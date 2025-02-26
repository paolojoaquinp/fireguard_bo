import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/helpers/validators/form_validators.dart';
import 'package:fireguard_bo/features/shared/app_shell/app_shell.dart';
import 'package:fireguard_bo/features/shared/extensions/auth_failure_x.dart';
import 'package:fireguard_bo/features/shared/widgets/custom_rich_text.dart';
import 'package:fireguard_bo/features/sign_in/data/services/sign_in_service.dart';
import 'package:fireguard_bo/features/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:fireguard_bo/features/sign_up/presentation/page/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static String route = '/sign_in';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider<SignInBloc>(
      create: (context) =>
          SignInBloc(signInService: SignInService(FirebaseAuth.instance)),
      child: _Body(colorScheme: colorScheme),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccessState) {
          Navigator.of(context).pushReplacementNamed(AppShell.route);
        }
        if (state is SignInFailureState) {
          if(state.error is SignInAuthFailure) {
            final data = state.error!.errorData;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${data.message}'),
              ),
            );
          }
        }
      },
      child: _Page(colorScheme: colorScheme),
    );
  }
}

class _Page extends StatelessWidget {
  _Page({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;
  final formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
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
                          'Sign In',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _controllerEmail,
                          validator: FormValidator.email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Your email here',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          // onChanged: (value) => setState(() => email = value),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _controllerPassword,
                          validator: FormValidator.password,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: 'Your password here',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          // onChanged: (value) => setState(() => password = value),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton(
                          // onPressed: _signIn,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            context.read<SignInBloc>().add(
                                  SignInWithEmailPasswordEvent(
                                    email: _controllerEmail.value.text,
                                    password: _controllerPassword.value.text,
                                  ),
                                );
                          },
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 56),
                        CustomRichText(
                          text: 'Don’t have an Account?',
                          secondaryText: 'Sign Up',
                          onTap: () =>
                              Navigator.pushNamed(context, SignUpScreen.route),
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
