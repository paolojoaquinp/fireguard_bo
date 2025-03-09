part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  const NewsInitial();

  @override
  List<Object?> get props => [];
}

class NewsLoadingState extends NewsState {
  const NewsLoadingState();

  @override
  List<Object?> get props => [];
}

class NewsLoadedState extends NewsState {
  const NewsLoadedState(this.incidents);

  final List<IncidentModel> incidents;

  @override
  List<Object?> get props => [incidents];
}

class NewsErrorState extends NewsState {
  const NewsErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
