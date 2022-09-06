import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  Future<void> singup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> singin(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  bool get isAuth {
    return fetchSignInUserId != null;
  }

  String? get fetchSignInUserId {
    // ignore: unnecessary_null_comparison
    if (FirebaseAuth.instance.authStateChanges() != null) {
      return FirebaseAuth.instance.currentUser?.uid;
    } else {
      return null;
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
