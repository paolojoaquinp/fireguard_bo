import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/features/home_screen/data/models/subscription_model.dart';
import 'package:fireguard_bo/features/home_screen/domain/repositories/subscription_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({
    required this.subscriptionRepository,
  }) : super(const SubscriptionInitial()) {
    on<SubscribeToIncidentEvent>(_onSubscribeToIncident);
    on<UnsubscribeFromIncidentEvent>(_onUnsubscribeFromIncident);
    on<CheckSubscriptionStatusEvent>(_onCheckSubscriptionStatus);
  }

  final SubscriptionRepository subscriptionRepository;

  Future<void> _onSubscribeToIncident(
      SubscribeToIncidentEvent event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionLoading());

    final result = await subscriptionRepository.subscribeToIncident(
        event.incidentId, event.userId);

    switch (result) {
      case Success(value: final subscription):
        emit(SubscriptionSuccess(subscription));
      case Err(value: final failure):
        emit(SubscriptionError(failure.message));
    }
  }

  Future<void> _onUnsubscribeFromIncident(
      UnsubscribeFromIncidentEvent event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionLoading());

    final result = await subscriptionRepository.unsubscribeFromIncident(
        event.subscriptionId);

    switch (result) {
      case Success():
        emit(const UnsubscriptionSuccess());
      case Err(value: final failure):
        emit(SubscriptionError(failure.message));
    }
  }

  Future<void> _onCheckSubscriptionStatus(
      CheckSubscriptionStatusEvent event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionLoading());

    final result = await subscriptionRepository.getSubscription(
        event.incidentId, event.userId);

    switch (result) {
      case Success(value: final subscription):
        if (subscription != null) {
          emit(SubscriptionExistsState(subscription));
        } else {
          emit(const SubscriptionNotExistsState());
        }
      case Err(value: final failure):
        emit(SubscriptionError(failure.message));
    }
  }
} 