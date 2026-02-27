class UserModel {
  final String uid;
  final String displayName;
  final String? photoUrl;
  final String email;

  const UserModel({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    required this.email,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'],
      email: map['email'],
    );
  }
}
