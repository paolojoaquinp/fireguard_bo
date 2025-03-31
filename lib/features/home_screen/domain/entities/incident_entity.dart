class IncidentEntity {
  const IncidentEntity({
    required this.id,
    required this.reporter,
    required this.incidentType,
    required this.status,
    required this.severityLevel,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.photoUrl,
  });

  final String id;
  final Reporter reporter;
  final String incidentType;
  final String status;
  final int severityLevel;
  final LocationCoordinates location;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String photoUrl;
}

class LocationCoordinates {
  const LocationCoordinates({
    required this.lat,
    required this.long,
  });

  final double lat;
  final double long;
}


class Reporter {
  const Reporter({
    required this.idReporter,
    required this.username,
    required this.name,
    required this.photoUrl,
  });

  final String idReporter;
  final String username;
  final String name;
  final String photoUrl;
}
