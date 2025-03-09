import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';

abstract interface class IncidentRepository {
  FutureResult<List<IncidentModel>> getIncidents();
  FutureResult<void> createIncident(IncidentModel incident);
}