import 'package:admin_panel_web_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleLogin(AuthController controller, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      controller.login(
        controller.emailController.text.trim(),
        controller.passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 450.w,
            padding: EdgeInsets.all(40.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40.sp,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    'Admin Panel',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Hospital Management System',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  CustomTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    hint: 'Enter admin email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),

                  SizedBox(height: 20.h),

                  CustomTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    hint: 'Enter password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: Validators.validatePassword,
                  ),

                  SizedBox(height: 40.h),

                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => _handleLogin(controller, formKey),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text('Login', style: AppTextStyles.button),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
