import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;

  AppUser({required this.uid, required this.email, this.displayName});

  // Factory method to create a User object from a Firebase User
  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
    );
  }

  // Convert AppUser to a map (for storing in Firestore or other databases)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }

  // Create an AppUser from a map (for retrieving from Firestore or other databases)
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
    );
  }
}
