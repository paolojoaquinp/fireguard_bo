import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireguard_bo/core/mobile_core_auth/user_repository.dart';

class UserServiceAuth implements UserRepository {
  const UserServiceAuth(this.client);

  final FirebaseAuth client;

  @override
  String get currentUserId => client.currentUser!.uid;

  @override
  bool get logged => client.currentUser != null;
}
