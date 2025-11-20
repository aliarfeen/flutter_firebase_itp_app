import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/features/auth/cubit/auth_state.dart';
import 'package:flutter_firebase_itp_app/core/data/model/app_user.dart';
import 'package:flutter_firebase_itp_app/services/firebase_auth_service.dart';
import 'package:flutter_firebase_itp_app/services/firebase_user_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      User? user = await FirebaseAuthService.instance.login(email, password);
      emit(AuthSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Failed to sign in'));
    }
  }

  Future<void> register(
    String email,
    String password,
    String displayName,
  ) async {
    emit(AuthLoading());
    try {
      User? user = await FirebaseAuthService.instance.register(email, password);
      if (user != null) {
        AppUser appUser = AppUser(
          displayName: displayName,
          email: user.email ?? email,
          uid: user.uid,
        );
        await FirebaseUserService.instance.addUserData(appUser);
      }
      emit(AuthSuccess(user: user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Failed to sign up'));
    } on FirebaseException catch (e) {
      emit(AuthFailure(e.message ?? 'Failed to save user data'));
    }
  }
}
