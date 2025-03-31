import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';
import 'package:fireguard_bo/features/home_screen/data/repositories_impl/services/incident_service.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident_entity.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(const NewsInitial()) {
    final incidentService = IncidentService(FirebaseFirestore.instance);
    on<NewsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadNewsEvent>((event, emit) async {
      emit(const NewsLoadingState());
      
      final result = await incidentService.getIncidents();
      
      switch (result) {
        case Success(value: final incidents):
          emit(NewsLoadedState(incidents));
        case Err(value: final failure):
          emit(NewsErrorState(failure.message));
      }
    });
  }
}
