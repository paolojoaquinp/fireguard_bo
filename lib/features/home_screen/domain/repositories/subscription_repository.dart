import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/home_screen/data/models/subscription_model.dart';

abstract interface class SubscriptionRepository {
  FutureResult<SubscriptionModel> subscribeToIncident(String incidentId, String userId);
  FutureResult<void> unsubscribeFromIncident(String subscriptionId);
  FutureResult<List<SubscriptionModel>> getUserSubscriptions(String userId);
  FutureResult<SubscriptionModel?> getSubscription(String incidentId, String userId);
} 