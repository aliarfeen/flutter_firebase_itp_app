import 'package:flutter_firebase_itp_app/core/data/model/app_user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileDataAdded extends ProfileState {}

class ProfileDataLoaded extends ProfileState {
  final AppUser? user;
  ProfileDataLoaded(this.user);
}

class ProfileUpdated extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String errorMessage;

  ProfileFailure(this.errorMessage);
}
