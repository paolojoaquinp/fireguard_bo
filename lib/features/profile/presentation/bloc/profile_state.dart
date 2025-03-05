part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object> get props => [];
}


class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();

  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState(this.user);
  
  final AppUserEntity user;
  
  @override
  List<Object?> get props => [user];
}

class ProfileErrorState extends ProfileState {
  const ProfileErrorState(this.message);
  
  final String message;
  
  @override
  List<Object?> get props => [message];
}

class ProfileLogoutSuccessState extends ProfileState {
  const ProfileLogoutSuccessState();
  
  @override
  List<Object?> get props => [];
}