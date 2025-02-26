import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/failures/failure.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/extensions/documents_snapshot_x.dart';
import 'package:fireguard_bo/features/profile/domain/repositories/profile_repository.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';



class ProfileService implements ProfileRepository {
  ProfileService(this.auth, this.db);

  final FirebaseAuth auth;
  final FirebaseFirestore db;

  CollectionReference<Json> get _collection => db.collection('users');

  @override
  FutureResult<AppUserEntity> userFromId(String id) async {
    try {
      final snapshot = await _collection.doc(id).get();
      if (!snapshot.exists) {
        return Err(Failure(message: 'User no found'));
      }
      return Success(snapshot.toAppUserEntity());
    } catch (e) {
      return Err(Failure(message: e.toString()));
    }
  }

  @override
  Future<void> logout() => auth.signOut();
}
