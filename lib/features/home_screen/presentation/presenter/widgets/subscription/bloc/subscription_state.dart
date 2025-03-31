part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();

  @override
  List<Object?> get props => [];
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();

  @override
  List<Object?> get props => [];
}

class SubscriptionSuccess extends SubscriptionState {
  const SubscriptionSuccess(this.subscription);

  final SubscriptionModel subscription;

  @override
  List<Object?> get props => [subscription];
}

class UnsubscriptionSuccess extends SubscriptionState {
  const UnsubscriptionSuccess();

  @override
  List<Object?> get props => [];
}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SubscriptionExistsState extends SubscriptionState {
  const SubscriptionExistsState(this.subscription);

  final SubscriptionModel subscription;

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionNotExistsState extends SubscriptionState {
  const SubscriptionNotExistsState();

  @override
  List<Object?> get props => [];
} 