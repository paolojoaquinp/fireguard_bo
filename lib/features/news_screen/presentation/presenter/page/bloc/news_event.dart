part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();
}

class LoadNewsEvent extends NewsEvent {
  const LoadNewsEvent();

  @override
  List<Object> get props => [];
}
