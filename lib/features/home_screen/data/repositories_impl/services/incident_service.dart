import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fireguard_bo/core/failures/failure.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/extensions/documents_snapshot_x.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';
import 'package:path/path.dart' as path;
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
  FutureResult<IncidentModel> createIncident(
    IncidentModel incident,
    String? localPhotoPath,
  ) async {
    try {
      String? photoUrl;
      if (localPhotoPath != null) {
        photoUrl = await uploadIncidentImage(localPhotoPath);
      }
      final incidentToSave = incident.copyWith(
        photoUrl: photoUrl,
      );
      final result = await _incidentCollection.add(incidentToSave.toJson());
      return Success(incidentToSave.copyWith(id: result.id));
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  @override
  StreamResult<List<IncidentModel>> getIncidentsStream() {
    try {
      final snapshots = _incidentCollection
          .orderBy('created_at', descending: true)
          .snapshots()
          .map(
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

  Future<String?> uploadIncidentImage(String localPhotoPath) async {
    try {
      final file = File(localPhotoPath);
      final fileName = path.basename(file.path);
      final dateTime = DateTime.now();

      final storagePath =
          'incidents/${dateTime.year}/${dateTime.month}/${dateTime.day}/$fileName';

      final storageRef = FirebaseStorage.instance.ref().child(storagePath);

      final uploadTask = await storageRef.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
