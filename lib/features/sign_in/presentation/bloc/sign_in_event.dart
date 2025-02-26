part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInWithEmailPasswordEvent extends SignInEvent {
  final String email;
  final String password;

  const SignInWithEmailPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
