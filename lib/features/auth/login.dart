import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/core/common_widgets/app_rich_text.dart';
import 'package:flutter_firebase_itp_app/core/common_widgets/app_text_field.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_button_style.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_colors.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_text_style.dart';
import 'package:flutter_firebase_itp_app/core/utils/app_validation.dart';
import 'package:flutter_firebase_itp_app/core/utils/context_extension.dart';
import 'package:flutter_firebase_itp_app/features/auth/cubit/auth_cubit.dart';
import 'package:flutter_firebase_itp_app/features/auth/cubit/auth_state.dart';
import 'package:flutter_firebase_itp_app/features/feed/cubit/posts_cubit.dart';
import 'package:flutter_firebase_itp_app/features/feed/feed_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  _isLogin ? 'Welcome back!' : 'Create your account',
                  style: AppTextStyle.darkGreyColor24ExtraBold,
                ),
                SizedBox(height: 16),
                if (!_isLogin)
                  AppTextField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    label: 'Name',
                    hint: 'Enter your name',
                    controller: _nameController,
                  ),
                if (!_isLogin) SizedBox(height: 8),
                AppTextField(
                  validator: (value) => AppValidation.validateEmail(value),
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                ),
                SizedBox(height: 8),
                AppTextField(
                  validator: (value) => AppValidation.validatePassword(value),
                  label: 'Password',
                  hint: 'Enter your password',
                  isPassword: true,
                  controller: _passwordController,
                ),
                SizedBox(height: 60),
                BlocConsumer<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() != true) {
                            return;
                          }
                          if (_isLogin) {
                            context.read<AuthCubit>().login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          } else {
                            context.read<AuthCubit>().register(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                            );
                          }
                        },
                        style: AppButtonStyle.primaryButtonStyle,
                        child: Text(
                          _isLogin ? 'Sign In' : 'Sign Up',
                          style: AppTextStyle.whiteColor16Bold,
                        ),
                      );
                    }
                  },
                  listenWhen: (previous, current) =>
                      current is AuthSuccess || current is AuthFailure,
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.showSnackBar('Welcome ${state.user!.email!}');
                      Future.delayed(Duration(milliseconds: 500), () {
                        if (!context.mounted) return;
                        context.navigateReplacement(
                          BlocProvider(
                            create: (context) => PostsCubit()..subscribeToPosts(),
                            child: FeedPage(),
                          ),
                        );
                      });
                    } else {
                      context.showSnackBar((state as AuthFailure).errorMessage);
                    }
                  },
                ),
                SizedBox(height: 20),
                AppRichText(
                  originalText: _isLogin
                      ? 'Don\'t have an account? '
                      : 'Already have an account? ',
                  originalTextStyle: AppTextStyle.darkGreyColor14Medium,
                  highlightedText: _isLogin ? 'Sign Up Now' : 'Sign In',
                  highlightedTextStyle: AppTextStyle.darkGreyColor14Medium
                      .copyWith(color: AppColors.primaryColor),
                  onTap: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
