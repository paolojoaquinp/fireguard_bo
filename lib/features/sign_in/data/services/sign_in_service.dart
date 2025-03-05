import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/result.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/sign_in/domain/repositories/sign_in_repository.dart';

class SignInService implements SignInRepository {
  const SignInService(this.client);

  final FirebaseAuth client;

  @override
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await client.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credentials.user;
      if (user != null) {
        return Success(null);
      }
      return Err(SignInAuthFailure.userNotFound);
    } on FirebaseAuthException catch (e) {
      return Err(
        SignInAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignInAuthFailure.unknown,
        ),
      );
    } catch (_) {
      return Err(SignInAuthFailure.unknown);
    }
  }
}
