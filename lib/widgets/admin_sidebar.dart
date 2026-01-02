import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedRoute;

  const AdminSidebar({
    super.key,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Container(
      width: 260.w,
      color: AppColors.primaryDark,
      child: Column(
        children: [
          // Logo
          Container(
            height: 70.h,
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 32.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Admin Panel',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.white.withOpacity(0.2), height: 1),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              children: [
                menuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                menuItem(
                  icon: Icons.medical_services,
                  title: 'Doctors',
                  route: '/doctors',
                ),
                menuItem(
                  icon: Icons.biotech,
                  title: 'Diagnostics',
                  route: '/diagnostics',
                ),
                menuItem(
                  icon: Icons.calendar_today,
                  title: 'Appointments',
                  route: '/appointments',
                ),
                // menuItem(
                //   icon: Icons.people,
                //   title: 'Users',
                //   route: '/users',
                // ),
                // menuItem(
                //   icon: Icons.analytics,
                //   title: 'Analytics',
                //   route: '/analytics',
                // ),
              ],
            ),
          ),

          // Logout
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Logout',
                style: AppTextStyles.body1.copyWith(color: Colors.white),
              ),
              onTap: () => authController.logout(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              hoverColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = selectedRoute == route;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 22.sp,
        ),
        title: Text(
          title,
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        onTap: () => Get.toNamed(route),
        hoverColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}