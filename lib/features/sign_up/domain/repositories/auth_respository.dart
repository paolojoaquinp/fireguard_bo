import 'package:fireguard_bo/core/failures/auth_failures.dart';
import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';

abstract interface class AuthRepository {
  FutureAuthResult<AppUserEntity, SignUpAuthFailure> signUp({
    required String email,
    required String password,
  });

  bool get logged;

  Future<void> logout();

  String get currentUserId;
}
