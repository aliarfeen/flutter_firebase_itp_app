import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/features/profile/cubit/profile_state.dart';
import 'package:flutter_firebase_itp_app/core/data/model/app_user.dart';
import 'package:flutter_firebase_itp_app/services/firebase_auth_service.dart';
import 'package:flutter_firebase_itp_app/services/firebase_realtime_db.dart';
import 'package:flutter_firebase_itp_app/services/firebase_user_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    try {
      AppUser? user = await FirebaseUserService.instance.loadUserData(
        getCurrentUser()!.uid,
      );
      emit(ProfileDataLoaded(user));
    } on FirebaseException catch (e) {
      emit(ProfileFailure(e.message ?? 'Unable to load user data'));
    }
  }

  User? getCurrentUser() {
    return FirebaseAuthService.instance.getCurrentUser();
  }

  Future<void> addUserData(
    String displayName,
    String phone,
    String address,
  ) async {
    AppUser user = AppUser(
      uid: getCurrentUser()!.uid,
      email: getCurrentUser()!.email!,
      displayName: displayName,
      phone: phone,
      address: address,
    );
    emit(ProfileLoading());
    try {
      // bool userAdded = await FirebaseUserService.instance.addUserData(user);
      bool dataSaved = await FirebaseRealtimeDb.instance.addUserData(user);
      emit(ProfileDataAdded());
    } on FirebaseException catch (e) {
      emit(ProfileFailure(e.message ?? 'Failed to add user data'));
    }
  }

  void updateUserProfile(
    String displayName,
    String phone,
    String address,
  ) async {
    AppUser user = AppUser(
      uid: getCurrentUser()!.uid,
      email: getCurrentUser()!.email!,
      displayName: displayName,
      phone: phone,
      address: address,
    );
    emit(ProfileLoading());
    try {
      bool dataUpdated = await FirebaseUserService.instance.updateUserData(
        user,
      );
      emit(ProfileUpdated());
    } on FirebaseException catch (e) {
      emit(ProfileFailure(e.message ?? 'Failed to update user data'));
    }
  }
}
