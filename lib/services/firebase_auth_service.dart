import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ajout de l'import Firestore
import 'package:flutter/foundation.dart';
import 'package:coutureapp/screens/models/app_user.dart'; // Chemin d'accès correct au fichier AppUser

class FirebaseAuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialisation de Firestore

  AppUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return AppUser(uid: user.uid, email: user.email ?? '', role: ''); // Initialisation du rôle avec une valeur vide
  }

  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      final appUser = _userFromFirebase(user);
      if (appUser != null && user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          appUser.role = userDoc.data()?['role'] ?? ''; // Récupération du rôle depuis Firestore
        }
      }
      return appUser;
    });
  }

  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return _userFromFirebase(user);
  }

  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String role) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    if (user != null) {
      // Stocker le rôle de l'utilisateur dans Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'role': role,
      });
    }

    return _userFromFirebase(user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
