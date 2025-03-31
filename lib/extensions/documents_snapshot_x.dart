import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';
import 'package:fireguard_bo/features/home_screen/data/models/subscription_model.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident_entity.dart';
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

  IncidentModel toIncidentModel() {
    return IncidentModel(
      id: id,
      reporter: Reporter(
        idReporter: this['reporter']['id'] as String,
        username: this['reporter']['username'] as String,
        name: this['reporter']['name'] as String,
        photoUrl: this['reporter']['photo_url'] as String,
      ),
      incidentType: this['incident_type'] as String,
      status: this['status'] as String,
      location: LocationCoordinates(
        lat: this['location']['lat'] as double,
        long: this['location']['long'] as double,
      ),
      severityLevel: this['severity_level'] as int,
      description: this['description'] as String,
      createdAt: (this['created_at'] as Timestamp).toDate(),
      updatedAt: (this['updated_at'] as Timestamp).toDate(),
      photoUrl: this['photo_url'] as String,
    );
  }

  SubscriptionModel toSubscriptionModel() {
    return SubscriptionModel(
      id: id,
      incidentId: this['incident_id'] as String,
      userId: this['user_id'] as String,
      createdAt: (this['created_at'] as Timestamp).toDate(),
    );
  }
}