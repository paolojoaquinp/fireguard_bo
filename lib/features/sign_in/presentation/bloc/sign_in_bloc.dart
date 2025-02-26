import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/sign_in/domain/repositories/sign_in_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required this.signInService}) : super(SignInInitial()) {
    on<SignInEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SignInWithEmailPasswordEvent>(_onSignInWithEmailPassword);
  }

  final SignInRepository signInService;


  Future<void> _onSignInWithEmailPassword(
      SignInWithEmailPasswordEvent event, Emitter<SignInState> emit,) async {
    emit(const SignInLoadingState());

    try {
      final result = await signInService.signIn(
        email: event.email,
        password: event.password,
      );

      final failure = switch (result) {
        Success() => null,
        Err(value: final exception) => exception,
      };

      if (failure == null) {
        emit(const SignInSuccessState());
      } else {
        emit(SignInFailureState(failure, StackTrace.current));
      }
    } catch (error, stackTrace) {
      emit(SignInFailureState(null, stackTrace));
    }
  }
}
