import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

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
                          // Stats Cards - First Row
                          Row(
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                color: AppColors.primary,
                                size: 22.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Key Metrics',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Obx(
                            () => controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : _buildMainStatsGrid(controller),
                          ),

                          SizedBox(height: 32.h),

                          // Appointments Section
                          _buildAppointmentsStats(controller),

                          SizedBox(height: 24.h),

                          // Diagnostic Bookings Section
                          _buildDiagnosticStats(controller),

                          SizedBox(height: 32.h),

                          // Revenue Section
                          _buildRevenueStats(controller),
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
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Breadcrumb
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: AppColors.primary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right side actions - Profile only
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Administrator',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatsGrid(DashboardController controller) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      childAspectRatio: 1.6,
      children: [
        DashboardCard(
          title: 'Total Doctors',
          value: controller.stats['totalDoctors'].toString(),
          subtitle: '${controller.stats['activeDoctors']} active',
          icon: Icons.medical_services_rounded,
          color: AppColors.primary,
          onTap: () => Get.toNamed('/doctors'),
        ),
        DashboardCard(
          title: 'Total Patients',
          value: controller.stats['totalPatients'].toString(),
          icon: Icons.people_alt_rounded,
          color: AppColors.secondary,
          trend: '+12%',
          isPositiveTrend: true,
          onTap: () => Get.toNamed('/users'),
        ),
        DashboardCard(
          title: 'Total Appointments',
          value: controller.stats['totalAppointments'].toString(),
          subtitle: '${controller.stats['todayAppointments']} today',
          icon: Icons.calendar_month_rounded,
          color: AppColors.info,
          onTap: () => Get.toNamed('/appointments'),
        ),
        DashboardCard(
          title: 'Diagnostic Bookings',
          value: controller.stats['totalDiagnosticBookings'].toString(),
          subtitle: '${controller.stats['todayDiagnosticBookings']} today',
          icon: Icons.science_rounded,
          color: AppColors.warning,
          onTap: () => Get.toNamed('/diagnostic-bookings'),
        ),
      ],
    );
  }

  Widget _buildAppointmentsStats(DashboardController controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.info,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Text(
                    'Appointments Overview',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed('/appointments'),
                icon: Icon(Icons.arrow_forward_rounded, size: 18.sp),
                label: const Text('View All'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Obx(
            () => Row(
              children: [
                _buildMiniStatCard(
                  'Pending',
                  controller.stats['pendingAppointments'].toString(),
                  AppColors.pending,
                  Icons.schedule_rounded,
                ),
                SizedBox(width: 16.w),
                _buildMiniStatCard(
                  'Confirmed',
                  controller.stats['confirmedAppointments'].toString(),
                  AppColors.confirmed,
                  Icons.check_circle_rounded,
                ),
                SizedBox(width: 16.w),
                _buildMiniStatCard(
                  'Completed',
                  controller.stats['completedAppointments'].toString(),
                  AppColors.completed,
                  Icons.task_alt_rounded,
                ),
                SizedBox(width: 16.w),
                _buildMiniStatCard(
                  'Cancelled',
                  controller.stats['cancelledAppointments'].toString(),
                  AppColors.cancelled,
                  Icons.cancel_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticStats(DashboardController controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.biotech_rounded,
                      color: AppColors.warning,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Text(
                    'Diagnostic Bookings Overview',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed('/diagnostic-bookings'),
                icon: Icon(Icons.arrow_forward_rounded, size: 18.sp),
                label: const Text('View All'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Obx(
            () => Row(
              children: [
                _buildMiniStatCard(
                  'Pending',
                  controller.stats['pendingDiagnosticBookings'].toString(),
                  AppColors.pending,
                  Icons.schedule_rounded,
                ),
                SizedBox(width: 16.w),
                _buildMiniStatCard(
                  'Confirmed',
                  controller.stats['confirmedDiagnosticBookings'].toString(),
                  AppColors.confirmed,
                  Icons.check_circle_rounded,
                ),
                SizedBox(width: 16.w),
                _buildMiniStatCard(
                  'Completed',
                  controller.stats['completedDiagnosticBookings'].toString(),
                  AppColors.completed,
                  Icons.task_alt_rounded,
                ),
                SizedBox(width: 16.w),
                _buildMiniStatCard(
                  'Cancelled',
                  controller.stats['cancelledDiagnosticBookings'].toString(),
                  AppColors.cancelled,
                  Icons.cancel_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueStats(DashboardController controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.success,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Text(
                'Revenue Overview',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildRevenueCard(
                    'Appointment Revenue',
                    '৳${(controller.stats['totalAppointmentRevenue'] as double).toStringAsFixed(0)}',
                    AppColors.info,
                    Icons.calendar_month_rounded,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildRevenueCard(
                    'Diagnostic Revenue',
                    '৳${(controller.stats['totalDiagnosticRevenue'] as double).toStringAsFixed(0)}',
                    AppColors.warning,
                    Icons.science_rounded,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildRevenueCard(
                    'Total Revenue',
                    '৳${controller.totalRevenue.toStringAsFixed(0)}',
                    AppColors.success,
                    Icons.trending_up_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.12), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 16.sp),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 26.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
