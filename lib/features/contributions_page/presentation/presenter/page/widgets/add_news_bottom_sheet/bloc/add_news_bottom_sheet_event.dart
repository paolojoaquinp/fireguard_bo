part of 'add_news_bottom_sheet_bloc.dart';

sealed class AddNewsBottomSheetEvent extends Equatable {
  const AddNewsBottomSheetEvent();
}

class CreateIncidentEvent extends AddNewsBottomSheetEvent {
  const CreateIncidentEvent({
    required this.reporterId,
    required this.incidentType,
    required this.status,
    required this.severityLevel,
    required this.latitude,
    required this.longitude,
    required this.description,
  });

  final String reporterId;
  final String incidentType;
  final String status;
  final int severityLevel;
  final double latitude;
  final double longitude;
  final String description;

  @override
  List<Object?> get props => [
        reporterId,
        incidentType,
        status,
        severityLevel,
        latitude,
        longitude,
        description,
      ];
}
