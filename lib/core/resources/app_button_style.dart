import 'package:flutter/material.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_colors.dart';

class AppButtonStyle {
  AppButtonStyle._();

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.whiteColor,
    maximumSize: Size(double.infinity, 50),
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
