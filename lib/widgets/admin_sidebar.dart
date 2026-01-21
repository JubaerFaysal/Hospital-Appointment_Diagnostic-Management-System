import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedRoute;

  const AdminSidebar({super.key, required this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Container(
      width: 270.w,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Section
          Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hospital Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Menu Section Label
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'MAIN MENU',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              children: [
                _menuItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                _menuItem(
                  icon: Icons.medical_services_rounded,
                  title: 'Doctors',
                  route: '/doctors',
                ),
                _menuItem(
                  icon: Icons.biotech_rounded,
                  title: 'Diagnostics',
                  route: '/diagnostics',
                ),
                _menuItem(
                  icon: Icons.science_rounded,
                  title: 'Diagnostic Bookings',
                  route: '/diagnostic-bookings',
                ),
                _menuItem(
                  icon: Icons.calendar_month_rounded,
                  title: 'Appointments',
                  route: '/appointments',
                ),
                _menuItem(
                  icon: Icons.people_alt_rounded,
                  title: 'Users',
                  route: '/users',
                ),
              ],
            ),
          ),

          // Bottom Section
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Administrator',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => authController.logout(),
                  icon: Icon(
                    Icons.logout_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 20.sp,
                  ),
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = selectedRoute == route;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(route),
          borderRadius: BorderRadius.circular(10.r),
          hoverColor: AppColors.sidebarHover,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isSelected ? AppColors.primary : Colors.transparent,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.6),
                  size: 20.sp,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
