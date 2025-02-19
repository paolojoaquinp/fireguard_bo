part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}


class SignUpSubmittedEvent extends SignUpEvent {
  const SignUpSubmittedEvent({
    required this.userName,
    required this.email,
    required this.password,
  });

  final String userName;
  final String email;
  final String password;


    @override
  List<Object> get props => [userName, email, password];
}
