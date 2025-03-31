class SubscriptionEntity {
  const SubscriptionEntity({
    required this.id,
    required this.incidentId,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String incidentId;
  final String userId;
  final DateTime createdAt;
} 