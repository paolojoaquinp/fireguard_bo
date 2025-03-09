import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/core/failures/failure.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/extensions/documents_snapshot_x.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';

import 'package:fireguard_bo/features/home_screen/domain/repositories/incident_repository.dart';

class IncidentService implements IncidentRepository {
  IncidentService(this.db);

  final FirebaseFirestore db;

  CollectionReference<Json> get _incidentCollection => 
      db.collection('incidents');

  @override
  FutureResult<List<IncidentModel>> getIncidents() async {
    try {
      final snapshots = await _incidentCollection
          .orderBy('created_at', descending: true)
          .get();

      final incidents = snapshots.docs
          .where((element) => element.exists)
          .map((e) => e.toIncidentModel())
          .toList();

      return Success(incidents);
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  @override
  FutureResult<IncidentModel> createIncident(IncidentModel incident) async {
    try {
      final result = await _incidentCollection.add(incident.toJson());
      return Success(
        incident.copyWith(id: result.id),
      );
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  @override
  StreamResult<List<IncidentModel>> getIncidentsStream() {
    try {
      final snapshots = _incidentCollection
          .orderBy('created_at', descending: true)
          .snapshots().map(
        (event) => event.docs
            .where((element) => element.exists)
            .map((e) => e.toIncidentModel())
            .toList(),
      );

      return Success(snapshots);
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }
}
