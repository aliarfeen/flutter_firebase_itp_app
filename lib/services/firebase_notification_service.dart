import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    String? token = await _messaging.getToken();
    if (token != null) {
      //register token to BE
      print('token: $token');
    }
    _messaging.onTokenRefresh.listen((refreshToken) {
      //send refresh token to BE
    });
  }
}
