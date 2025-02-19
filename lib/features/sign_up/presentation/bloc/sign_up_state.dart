part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();

  @override
  List<Object> get props => [];
}


class SignUpLoadingState extends SignUpState {
  const SignUpLoadingState();

  @override
  List<Object> get props => [];
}

class SignUpSuccessState extends SignUpState {
  const SignUpSuccessState();

  @override
  List<Object> get props => [];
}

class SignUpErrorState extends SignUpState {
  const SignUpErrorState(this.message, {this.icon});

  final String message;
  final IconData? icon;

  @override
  List<Object> get props => [message];
}
