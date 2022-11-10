import 'package:chatapp/shared/shared_preferences_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      FirebaseFirestoreService(uid: user.uid).addUserData(fullName, email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign-out
  Future signOutUser() async {
    try {
      await SharedPreferencesState.setLoggedInStatus(false);
      await SharedPreferencesState.setUserNameSF("");
      await SharedPreferencesState.setUserEmailSF("");
      await firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
