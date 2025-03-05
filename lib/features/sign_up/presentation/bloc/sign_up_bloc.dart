import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/sign_up/data/services/user_service.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';
import 'package:fireguard_bo/features/sign_up/domain/repositories/auth_respository.dart';
import 'package:flutter/material.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserService userService;
  final AuthRepository authRepo;
  AppUserEntity? _user;

  SignUpBloc({
    required this.userService,
    required this.authRepo,
  }) : super(const SignUpInitial()) {
    on<SignUpSubmittedEvent>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmittedEvent event,
    Emitter<SignUpState> emit,
  ) async {
    try {
      emit(const SignUpLoadingState());
      
      if (_user != null) {
        await _createUser(
          id: _user!.id,
          username: event.userName,
          email: event.email,
          photoUrl: _user?.photoUrl,
        );
        emit(const SignUpSuccessState());
        return;
      }

      final result = await authRepo.signUp(
        email: event.email,
        password: event.password,
      );

      final record = switch (result) {
        Success(value: final user) => (user: user, failure: null),
        Err(value: final failure) => (user: null, failure: failure),
      };

      _user = record.user;
      final failure = record.failure;

      if (failure != null) {
        final data = failure.code;
        emit(SignUpErrorState(data!));
        return;
      }

      await _createUser(
        id: _user!.id,
        username: event.userName,
        email: event.email,
        photoUrl: _user?.photoUrl,
      );
      
      emit(const SignUpSuccessState());
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }

  Future<void> _createUser({
    required String id,
    required String username,
    required String email,
    String? photoUrl,
  }) async {
    final result = await userService.createUser(
      id: id,
      username: username,
      email: email,
      photoUrl: photoUrl,
    );

    if (result case Err()) {
      throw Exception('Failed to create user');
    }
  }
}