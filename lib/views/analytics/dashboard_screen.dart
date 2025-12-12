import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const AdminSidebar(selectedRoute: '/dashboard'),

          // Main Content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),

                  // Dashboard Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard Overview',
                            style: AppTextStyles.h3.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Stats Cards
                          Obx(() => controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : _buildStatsGrid(controller)),

                          SizedBox(height: 32.h),

                          // Recent Activities
                          _buildRecentSection('Recent Appointments'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hospital Management System',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                iconSize: 24.sp,
              ),
              SizedBox(width: 16.w),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary,
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DashboardController controller) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      childAspectRatio: 1.8,
      children: [
        DashboardCard(
          title: 'Total Doctors',
          value: controller.stats['totalDoctors'].toString(),
          icon: Icons.medical_services,
          color: AppColors.primary,
          onTap: () => Get.toNamed('/doctors'),
        ),
        DashboardCard(
          title: 'Total Patients',
          value: controller.stats['totalPatients'].toString(),
          icon: Icons.people,
          color: AppColors.secondary,
          onTap: () => Get.toNamed('/users'),
        ),
        DashboardCard(
          title: 'Appointments Today',
          value: controller.stats['todayAppointments'].toString(),
          icon: Icons.calendar_today,
          color: AppColors.info,
          onTap: () => Get.toNamed('/appointments'),
        ),
        DashboardCard(
          title: 'Diagnostic Tests',
          value: controller.stats['totalTests'].toString(),
          icon: Icons.biotech,
          color: AppColors.warning,
          onTap: () => Get.toNamed('/diagnostics'),
        ),
      ],
    );
  }

  Widget _buildRecentSection(String title) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No recent activities',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}