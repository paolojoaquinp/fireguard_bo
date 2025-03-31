import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';
import 'package:fireguard_bo/features/home_screen/data/repositories_impl/services/incident_service.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident_entity.dart';

part 'add_news_bottom_sheet_event.dart';
part 'add_news_bottom_sheet_state.dart';

class AddNewsBottomSheetBloc extends Bloc<AddNewsBottomSheetEvent, AddNewsBottomSheetState> {
  AddNewsBottomSheetBloc() : super(const AddNewsBottomSheetInitial()) {
    final incidentService = IncidentService(FirebaseFirestore.instance);

    on<CreateIncidentEvent>((event, emit) async {
      try {
        emit(const AddNewsBottomSheetLoading());

        final incident = IncidentModel(
          id: '',  // Firebase will generate this
          reporter: Reporter(
            idReporter: event.reporterId,
            // username: event.reporterUsername ?? '',
            username: '',
            // name: event.reporterName ?? '',
            name: '',
            // photoUrl: event.reporterPhotoUrl ?? '',
            photoUrl: '',
          ),
          incidentType: event.incidentType,
          status: event.status,
          severityLevel: event.severityLevel,
          location: LocationCoordinates(
            lat: event.latitude,
            long: event.longitude,
          ),
          description: event.description,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          photoUrl: '',
        );

        final result = await incidentService.createIncident(incident, event.photoPath);

        switch (result) {
          case Success():
            emit(const AddNewsBottomSheetSuccess());
          case Err(value: final failure):
            emit(AddNewsBottomSheetError(failure.message));
        }
      } catch (e) {
        emit(AddNewsBottomSheetError(e.toString()));
      }
    });
  }
}
