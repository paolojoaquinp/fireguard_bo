class Incident {
  const Incident({
    required this.createdAt,
    required this.description,
    required this.location,
    required this.reporterId,
    required this.severityLevel,
    required this.status,
    required this.type,
    required this.updatedAt,
  });

  final DateTime createdAt;
  final String description;
  final IncidentLocation location;
  final String reporterId;
  final int severityLevel;
  final String status;
  final String type;
  final DateTime updatedAt;
}

class IncidentLocation {
  const IncidentLocation({
    required this.geohash,
    required this.latitude,
    required this.longitude,
  });

  final String geohash;
  final double latitude;
  final double longitude;
}