import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_colors.dart';
import 'package:flutter_firebase_itp_app/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_firebase_itp_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_firebase_itp_app/features/splash/splash.dart';
import 'package:flutter_firebase_itp_app/features/splash/splash_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(create: (context) => ProfileCubit()..loadUserProfile()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: AppColors.whiteColor),
        home: Splash(),
      ),
    );
  }
}
