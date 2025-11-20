import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/services/firebase_auth_service.dart';

class SplashCubit extends Cubit<bool> {
  SplashCubit() : super(false);

  void init() {
    User? user = FirebaseAuthService.instance.getCurrentUser();
    if (user != null) {
      emit(true);
    } else {
      emit(false);
    }
  }
}
