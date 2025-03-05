import 'package:fireguard_bo/core/typedefs.dart';
import 'package:fireguard_bo/features/sign_up/domain/entities/app_user_entity.dart';

abstract interface class ProfileRepository {
  FutureResult<AppUserEntity> userFromId(String id);

  Future<void> logout();
}
