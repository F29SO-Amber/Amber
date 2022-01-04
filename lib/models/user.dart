class User {
  final String id;
  final String email;
  final String username;
  final String displayName;
  final String accountType;
  final DateTime dob;
  final String gender;
  final String photoURL;
  final Map followers;
  final Map following;

  const User(
      {required this.dob,
      required this.gender,
      required this.accountType,
      required this.username,
      required this.id,
      required this.photoURL,
      required this.email,
      required this.displayName,
      required this.followers,
      required this.following});
}
