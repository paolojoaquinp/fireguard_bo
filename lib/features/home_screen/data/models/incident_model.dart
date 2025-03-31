import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident_entity.dart';

class IncidentModel extends IncidentEntity {
  const IncidentModel({
    required super.id,
    required super.reporter,
    required super.incidentType,
    required super.status,
    required super.severityLevel,
    required super.location,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'reporter': {
        'id': reporter.idReporter,
        'username': reporter.username,
        'name': reporter.name,
        'photo_url': reporter.photoUrl,
      },
      'incident_type': incidentType,
      'status': status,
      'severity_level': severityLevel,
      'location': {
        'lat': location.lat,
        'long': location.long,
      },
      'description': description,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'photo_url': photoUrl,
    };
  }

  factory IncidentModel.fromJson(String docId, Map<String, dynamic> json) {
    return IncidentModel(
      id: docId,
      reporter: Reporter(
        idReporter: json['reporter_id'] as String? ?? '',
        username: json['username'] as String? ?? '',
        name: json['name'] as String? ?? '',
        photoUrl: json['photo_url'] as String? ?? '',
      ),
      incidentType: json['incident_type'] as String? ?? '',
      status: json['status'] as String? ?? '',
      severityLevel: json['severity_level'] as int? ?? 0,
      location: LocationCoordinates(
        lat: _getDoubleFromJson(json['location'], 'lat'),
        long: _getDoubleFromJson(json['location'], 'long'),
      ),
      description: json['description'] as String? ?? '',
      createdAt: _getDateTimeFromTimestamp(json['created_at']),
      updatedAt: _getDateTimeFromTimestamp(json['updated_at']),
      photoUrl: json['photo_url'] as String? ?? '',
    );
  }

  static double _getDoubleFromJson(dynamic locationData, String key) {
    if (locationData == null) return 0.0;
    if (locationData is! Map<String, dynamic>) return 0.0;
    return (locationData[key] as num?)?.toDouble() ?? 0.0;
  }

  static DateTime _getDateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }

  IncidentModel copyWith({
    String? id,
    Reporter? reporter,
    String? incidentType,
    String? status,
    int? severityLevel,
    LocationCoordinates? location,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,

  }) {
    return IncidentModel(
      id: id ?? this.id,
      reporter: reporter ?? this.reporter,
      incidentType: incidentType ?? this.incidentType,
      status: status ?? this.status,
      severityLevel: severityLevel ?? this.severityLevel,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}