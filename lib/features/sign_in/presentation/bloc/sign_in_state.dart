part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

// class SignInState extends Equatable {
//   final String email;
//   final String password;
//   final bool isLoading;
//   final String? errorMessage;
//   final bool isSuccess;

//   const SignInState({
//     this.email = '',
//     this.password = '',
//     this.isLoading = false,
//     this.errorMessage,
//     this.isSuccess = false,
//   });

//   SignInState copyWith({
//     String? email,
//     String? password,
//     bool? isLoading,
//     String? errorMessage,
//     bool? isSuccess,
//   }) {
//     return SignInState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage,
//       isSuccess: isSuccess ?? this.isSuccess,
//     );
//   }

//   @override
//   List<Object> get props => [
//         email,
//         password,
//         isLoading,
//         errorMessage ?? 'N/A',
//         isSuccess,
//   ];
// }

final class SignInInitial extends SignInState {
  const SignInInitial();

  @override
  List<Object> get props => [];
}

class SignInLoadingState extends SignInState {
  const SignInLoadingState();

  @override
  List<Object> get props => [];
}

class SignInSuccessState extends SignInState {
  const SignInSuccessState();

  @override
  List<Object> get props => [];
}

class SignInFailureState extends SignInState {
  const SignInFailureState(this.error, this.stackTrace);

  final SignInAuthFailure? error;
  final StackTrace stackTrace;

  @override
  List<Object> get props => [];
}
