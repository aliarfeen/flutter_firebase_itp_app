import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase_itp_app/core/data/model/app_user.dart';

class FirebaseRealtimeDb {
  FirebaseRealtimeDb._();

  static final FirebaseRealtimeDb instance = FirebaseRealtimeDb._();
  final FirebaseDatabase database = FirebaseDatabase.instance;

  //insert user data
  Future<bool> addUserData(AppUser user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    try {
      await ref.child('users').child(user.uid).set(user.toJson());
      //
      //  _firestore
      //     .collection(collectionPath)
      //     .doc(user.uid)
      //     .set(user.toJson());
      return true;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
