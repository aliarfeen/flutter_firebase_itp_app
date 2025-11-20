import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_itp_app/core/common_widgets/app_text_field.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_button_style.dart';
import 'package:flutter_firebase_itp_app/core/resources/app_text_style.dart';
import 'package:flutter_firebase_itp_app/core/utils/app_validation.dart';
import 'package:flutter_firebase_itp_app/core/utils/context_extension.dart';
import 'package:flutter_firebase_itp_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_firebase_itp_app/features/profile/cubit/profile_state.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text =
        context.read<ProfileCubit>().getCurrentUser()?.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Personal Data',
                style: AppTextStyle.darkGreyColor24ExtraBold,
              ),
              SizedBox(height: 16),
              AppTextField(
                validator: (value) => AppValidation.validateUsername(value),
                label: 'Display Name',
                hint: 'Display Name',
                controller: _nameController,
              ),
              SizedBox(height: 8),
              AppTextField(
                label: 'Email',
                hint: 'Email',
                controller: _emailController,
                isReadOnly: true,
              ),
              SizedBox(height: 8),
              AppTextField(
                label: 'Phone',
                hint: 'Phone',
                controller: _phoneController,
                validator: (value) => AppValidation.validatePhoneNumber(value),
              ),
              SizedBox(height: 8),
              AppTextField(
                label: 'Address',
                hint: 'Address',
                controller: _addressController,
              ),
              SizedBox(height: 50),
              BlocConsumer<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProfileCubit>().addUserData(
                          _nameController.text,
                          _phoneController.text,
                          _addressController.text,
                        );
                      }
                    },
                    style: AppButtonStyle.primaryButtonStyle,
                    child: Text('Update', style: AppTextStyle.whiteColor16Bold),
                  );
                },
                listenWhen: (previous, current) =>
                    current is ProfileDataAdded ||
                    current is ProfileFailure ||
                    current is ProfileDataLoaded,
                listener: (context, state) {
                  if (state is ProfileDataAdded) {
                    context.showSnackBar('Profile updated successfully');
                  } else if (state is ProfileFailure) {
                    context.showSnackBar(state.errorMessage);
                  } else if (state is ProfileDataLoaded) {
                    _nameController.text = state.user?.displayName ?? '';
                    _phoneController.text = state.user?.phone ?? '';
                    _addressController.text = state.user?.address ?? '';
                  } else if (state is ProfileUpdated) {
                    context.showSnackBar('Profile updated successfully');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
