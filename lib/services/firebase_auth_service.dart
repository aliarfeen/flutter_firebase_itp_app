import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseAuthService instance = FirebaseAuthService._();

  //login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  //register
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  //sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }


  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

/*
1- return user , throw exceptions
2- dartZ return Either user or exception
3- freezed return Result<User>
 */
