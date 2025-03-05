
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireguard_bo/core/failures/failure.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/extensions/documents_snapshot_x.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';

extension type UserService(FirebaseFirestore db) {
  CollectionReference<Json> get _collection => db.collection('users');

  FutureResult<AppUserEntity> userFromId(String id) async {
    try {
      final snapshot = await _collection.doc(id).get();
      if (!snapshot.exists) {
        return Err(Failure(message: 'User not found'));
      }
      return Success(snapshot.toAppUserEntity());
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  FutureResult<AppUserEntity> createUser({
    required String id,
    required String username,
    required String email,
    String? photoUrl,
  }) async {
    try {
      await _collection.doc(id).set({
        'id': id,
        'email': email,
        'username': username,
        'photoUrl': photoUrl,
      });
      return Success(
        AppUserEntity(
          id: id,
          email: email,
          username: username,
          photoUrl: photoUrl,
        ),
      );
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }
}
