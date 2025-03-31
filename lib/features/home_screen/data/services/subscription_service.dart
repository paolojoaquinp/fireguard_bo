// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fireguard_bo/core/failures/failure.dart';
// import 'package:fireguard_bo/core/result.dart';
// import 'package:fireguard_bo/core/typedefs.dart';
// import 'package:fireguard_bo/extensions/documents_snapshot_x.dart';
// import 'package:fireguard_bo/features/home_screen/data/models/subscription_model.dart';
// import 'package:fireguard_bo/features/home_screen/domain/repositories/subscription_repository.dart';

// class SubscriptionService implements SubscriptionRepository {
//   SubscriptionService(this.db);

//   final FirebaseFirestore db;

//   CollectionReference<Json> get _subscriptionCollection =>
//       db.collection('subscriptions');

//   @override
//   FutureResult<SubscriptionModel> subscribeToIncident(String incidentId, String userId) async {
//     try {
//       // Check if subscription already exists
//       final existingSubscription = await getSubscription(incidentId, userId);
//       if (existingSubscription is Success<SubscriptionModel?, Failure>) {
//         if (existingSubscription.value != null) {
//           return Success(existingSubscription.value!);
//         }
//       }

//       // Create new subscription
//       final subscription = SubscriptionModel(
//         id: '',
//         incidentId: incidentId,
//         userId: userId,
//         createdAt: DateTime.now(),
//       );

//       final result = await _subscriptionCollection.add(subscription.toJson());
//       return Success(subscription.copyWith(id: result.id));
//     } catch (e) {
//       return Err(Failure(message: e.toString()));
//     }
//   }

//   @override
//   FutureResult<void> unsubscribeFromIncident(String subscriptionId) async {
//     try {
//       await _subscriptionCollection.doc(subscriptionId).delete();
//       return Success(null);
//     } catch (e) {
//       return Err(Failure(message: e.toString()));
//     }
//   }

//   @override
//   FutureResult<List<SubscriptionModel>> getUserSubscriptions(String userId) async {
//     try {
//       final snapshots = await _subscriptionCollection
//           .where('user_id', isEqualTo: userId)
//           .get();

//       final subscriptions = snapshots.docs
//           .where((element) => element.exists)
//           .map((e) => e.toSubscriptionModel())
//           .toList();

//       return Success(subscriptions);
//     } catch (e) {
//       return Err(Failure(message: e.toString()));
//     }
//   }

//   @override
//   FutureResult<SubscriptionModel?> getSubscription(String incidentId, String userId) async {
//     try {
//       final snapshots = await _subscriptionCollection
          // .where('incident_id', isEqualTo: incidentId)
//           .where('user_id', isEqualTo: userId)
//           .limit(1)
//           .get();

//       if (snapshots.docs.isEmpty) {
//         return Success(null);
//       }

//       return Success(snapshots.docs.first.toSubscriptionModel());
//     } catch (e) {
//       return Err(Failure(message: e.toString()));
//     }
//   }
// } 