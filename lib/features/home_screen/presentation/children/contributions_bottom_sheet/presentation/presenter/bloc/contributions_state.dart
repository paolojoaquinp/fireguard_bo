part of 'contributions_bloc.dart';

sealed class ContributionsState extends Equatable {
  const ContributionsState();
  
  @override
  List<Object> get props => [];
}

final class ContributionsInitial extends ContributionsState {}
