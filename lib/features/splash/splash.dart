import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/features/feed/cubit/posts_cubit.dart';
import 'package:flutter_firebase_itp_app/features/feed/feed_page.dart';
import 'package:flutter_firebase_itp_app/features/splash/splash_cubit.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_colors.dart';
import 'package:flutter_firebase_itp_app/core/utils/context_extension.dart';
import 'package:flutter_firebase_itp_app/features/auth/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, bool>(
      listener: (context, state) => state
          ? context.navigateReplacement(
              BlocProvider(
                create: (context) => PostsCubit()..subscribeToPosts(), //kinda hustle i know
                child: FeedPage(),
              ),
            )
          : context.navigateReplacement(Login()),
      child: Scaffold(backgroundColor: AppColors.primaryColor),
    );
  }

  void _init() {
    Timer(const Duration(seconds: 3), () {
      context.read<SplashCubit>().init();
    });
  }
}
