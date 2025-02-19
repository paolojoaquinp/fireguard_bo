class AppUserEntity {
  const AppUserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.photoUrl,
  });

  final String id;
  final String email;
  final String username;
  final String? photoUrl;
}
