import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_itp_app/core/data/model/app_user.dart';

class FirebaseUserService {
  FirebaseUserService._();

  static final FirebaseUserService instance = FirebaseUserService._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // constants
  static const String collectionPath = 'users';

  //insert user data
  Future<bool> addUserData(AppUser user) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .set(user.toJson());
      return true;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  //load user data
  Future<AppUser?> loadUserData(String uid) async {
    try {
      DocumentSnapshot docSnapShot = await _firestore
          .collection(collectionPath)
          .doc(uid)
          .get();
      if (docSnapShot.exists) {
        print(docSnapShot.data().runtimeType); // Map<String, dynamic>
        Map<String, dynamic> appUserJson = Map.from(
          docSnapShot.data() as Map<String, dynamic>,
        );
        return AppUser.fromJson(appUserJson);
      }
      return null;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  //update user data
  Future<bool> updateUserData(AppUser user) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .update(user.toJson());
      return true;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
