import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';

extension DocumentSnapshotX on DocumentSnapshot<Json> {
  AppUserEntity toAppUserEntity() {
    return AppUserEntity(
      id: id,
      email: this['email'],
      username: this['username'],
      photoUrl: this['photoUrl'],
    );
  }

  Incident toIncident() {
    return Incident(
      createdAt: (this['createdAt'] as Timestamp).toDate(),
      description: this['description'] as String,
      location: IncidentLocation(
        geohash: this['location']['geohash'] as String,
        latitude: (this['location']['latitude'] as num).toDouble(),
        longitude: (this['location']['longitude'] as num).toDouble(),
      ),
      reporterId: this['reporterId'] as String,
      severityLevel: this['severityLevel'] as int,
      status: this['status'] as String,
      type: this['type'] as String,
      updatedAt: (this['updatedAt'] as Timestamp).toDate(),
    );
  }
}