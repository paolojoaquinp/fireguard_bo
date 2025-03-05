part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}


class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();

  @override
  List<Object> get props => [];
}

class LogoutRequestedEvent extends ProfileEvent {
  const LogoutRequestedEvent();

  @override
  List<Object> get props => [];
}