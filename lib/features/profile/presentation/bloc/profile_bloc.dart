import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/sign_up/data/services/user_service.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';
import 'package:fireguard_bo/features/sign_up/domain/repositories/auth_respository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.userService,
    required this.authService,
  }) : super(const ProfileInitial()) {
    // on<ProfileEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<LoadProfileEvent>(_onLoadProfileEvent);
    on<LogoutRequestedEvent>(_onLogoutRequestedEvent);
  }

  final AuthRepository authService;
  final UserService userService;

  Future<void> _onLoadProfileEvent(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoadingState());
    
    try {
      final currentUserId = authService.currentUserId;
      final result = await userService.userFromId(currentUserId);
      
      switch (result) {
        case Success(value: final user):
          emit(ProfileLoadedState(user));
        case Err(value: final failure):
          emit(ProfileErrorState(failure.message));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  Future<void> _onLogoutRequestedEvent(LogoutRequestedEvent event, Emitter<ProfileState> emit) async {
    try {
      await authService.logout();
      emit(const ProfileLogoutSuccessState());
    } catch (e) {
      emit(ProfileErrorState('Failed to logout: ${e.toString()}'));
    }
  }
}
