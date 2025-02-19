import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/sign_in/domain/entities/app_user_entity.dart';
import 'package:fireguard_bo/features/sign_in/domain/repositories/auth_respository.dart';

class FirebaseAuthAdapter implements AuthRepository {
  const FirebaseAuthAdapter(this.client);
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

  bool get logged => client.currentUser != null;
}
