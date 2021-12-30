class User {
  final String email;
  final String id;
  final String photoURL;
  final String username;
  final String displayName;
  final Map followers;
  final Map following;

  const User(
      {required this.username,
      required this.id,
      required this.photoURL,
      required this.email,
      required this.displayName,
      required this.followers,
      required this.following});
}
