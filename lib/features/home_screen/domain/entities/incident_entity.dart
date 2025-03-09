class IncidentEntity {
  const IncidentEntity({
    required this.id,
    required this.reporterId,
    required this.incidentType,
    required this.status,
    required this.severityLevel,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String reporterId;
  final String incidentType;
  final String status;
  final int severityLevel;
  final LocationCoordinates location;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class LocationCoordinates {
  const LocationCoordinates({
    required this.lat,
    required this.long,
  });

  final double lat;
  final double long;
}
