

import 'package:fireguard_bo/core/failures/failure.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/home_screen/data/models/incident_model.dart';

typedef Json = Map<String, dynamic>;

typedef FutureResult<T> = Future<Result<T, Failure>>;
typedef FutureAuthResult<T, E> = Future<Result<T, E>>;
// typedef IncidentData = ({AppUser user, Incident? friendships});
typedef IncidentData = ({IncidentModel? incidents});