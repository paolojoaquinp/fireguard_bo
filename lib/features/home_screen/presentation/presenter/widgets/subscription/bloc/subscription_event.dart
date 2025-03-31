part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
}

class SubscribeToIncidentEvent extends SubscriptionEvent {
  const SubscribeToIncidentEvent({
    required this.incidentId,
    required this.userId,
  });

  final String incidentId;
  final String userId;

  @override
  List<Object?> get props => [incidentId, userId];
}

class UnsubscribeFromIncidentEvent extends SubscriptionEvent {
  const UnsubscribeFromIncidentEvent({
    required this.subscriptionId,
  });

  final String subscriptionId;

  @override
  List<Object?> get props => [subscriptionId];
}

class CheckSubscriptionStatusEvent extends SubscriptionEvent {
  const CheckSubscriptionStatusEvent({
    required this.incidentId,
    required this.userId,
  });

  final String incidentId;
  final String userId;

  @override
  List<Object?> get props => [incidentId, userId];
} 