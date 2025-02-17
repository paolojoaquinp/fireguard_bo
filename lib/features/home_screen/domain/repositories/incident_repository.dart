import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/home_screen/domain/entities/incident.dart';

abstract interface class IncidentRepository {
  FutureResult<List<Incident>> getIncidents();
}