import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../controller/analytics_controller.dart';
import '../../routes/admin_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/dashboard_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: AdminRoutes.ANALYTICS),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analytics Overview',
                            style: AppTextStyles.h3.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Monthly Stats
                          _buildStatsGrid(controller),

                          SizedBox(height: 32.h),

                          // Charts Section
                          Row(
                            children: [
                              Expanded(
                                child: _buildChartCard(
                                  'Appointments Trend',
                                  'Monthly appointments overview',
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: _buildChartCard(
                                  'Revenue Analysis',
                                  'Monthly revenue breakdown',
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          Row(
                            children: [
                              Expanded(
                                child: _buildChartCard(
                                  'Popular Specialties',
                                  'Most booked specializations',
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: _buildChartCard(
                                  'Test Categories',
                                  'Diagnostic tests distribution',
                                ),
                              ),
                            ],
                          ),
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
      padding: EdgeInsets.all(24.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics & Reports',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                'System performance and insights',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download),
                label: const Text('Export Report'),
              ),
              SizedBox(width: 16.w),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(controller) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      childAspectRatio: 1.8,
      children: [
        Obx(() => DashboardCard(
          title: 'Monthly Revenue',
          value: controller.monthlyRevenue.value,
          icon: Icons.attach_money,
          color: AppColors.success,
        )),
        Obx(() => DashboardCard(
          title: 'Total Appointments',
          value: controller.totalAppointments.value,
          icon: Icons.calendar_month,
          color: AppColors.primary,
        )),
        Obx(() => DashboardCard(
          title: 'Tests Conducted',
          value: controller.testsConducted.value,
          icon: Icons.science,
          color: AppColors.secondary,
        )),
        Obx(() => DashboardCard(
          title: 'Patient Satisfaction',
          value: controller.patientSatisfaction.value,
          icon: Icons.sentiment_satisfied_alt,
          color: AppColors.warning,
        )),
      ],
    );
  }

  Widget _buildChartCard(String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(subtitle, style: AppTextStyles.caption),
          SizedBox(height: 24.h),
          Container(
            height: 200.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, size: 48.sp, color: AppColors.textHint),
                SizedBox(height: 12.h),
                Text(
                  'Chart Placeholder',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
