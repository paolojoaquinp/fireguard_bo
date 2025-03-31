

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/features/home_screen/data/repositories_impl/services/incident_service.dart';
import 'package:get_it/get_it.dart';
import 'package:fireguard_bo/features/home_screen/presentation/presenter/widgets/map_page/bloc/map_page_bloc.dart';

GetIt getIt = GetIt.instance;

void serviceLocatorInit() {
 
 getIt.registerSingleton(MapPageBloc(incidentRepository: IncidentService(FirebaseFirestore.instance)));

}