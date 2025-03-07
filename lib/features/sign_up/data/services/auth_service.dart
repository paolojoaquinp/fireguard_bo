import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';
import 'package:fireguard_bo/features/sign_up/domain/repositories/auth_respository.dart';

class FirebaseAuthService implements AuthRepository {
  const FirebaseAuthService(this.client);
  final FirebaseAuth client;

  @override
  FutureAuthResult<AppUserEntity, SignUpAuthFailure> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await client.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user;
      if (user != null) {
        return Success(
          AppUserEntity(
            id: user.uid,
            email: email,
            username: user.displayName ?? '',
            photoUrl: user.photoURL,
          ),
        );
      }
      return Err(SignUpAuthFailure.userNotCreate);
    } on FirebaseAuthException catch (e) {
      return Err(
        SignUpAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignUpAuthFailure.unknown,
        ),
      );
    } catch (e) {
      return Err(SignUpAuthFailure.unknown);
    }
  }

  @override
  bool get logged => client.currentUser != null;

  @override
  Future<void> logout() => client.signOut();

  @override
  String get currentUserId => client.currentUser!.uid;
}
