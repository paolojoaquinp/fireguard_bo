import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.incidentId,
    required super.userId,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'incident_id': incidentId,
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory SubscriptionModel.fromJson(String docId, Map<String, dynamic> json) {
    return SubscriptionModel(
      id: docId,
      incidentId: json['incident_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      createdAt: _getDateTimeFromTimestamp(json['created_at']),
    );
  }

  static DateTime _getDateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }

  SubscriptionModel copyWith({
    String? id,
    String? incidentId,
    String? userId,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 