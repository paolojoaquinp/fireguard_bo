import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/typedefs.dart';

abstract interface class SignInRepository {
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required String email,
    required String password,
  });
}
