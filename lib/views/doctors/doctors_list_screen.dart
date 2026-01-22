import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/doctor_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/doctor_filter_panel.dart';

class DoctorsListScreen extends GetView<DoctorsController> {
  const DoctorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: '/doctors'),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildTopBar(controller),
                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (controller.filteredDoctors.isEmpty) {
                              return _buildEmptyState();
                            }

                            return _buildDoctorsTable(controller);
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Filter Panel
                  Obx(() {
                    if (controller.showFilters.value) {
                      return const DoctorFilterPanel();
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(DoctorsController controller) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctors Management',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(
                    () => Text(
                      '${controller.filteredDoctors.length} doctors found',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Filter Toggle Button
                  Obx(
                    () => OutlinedButton.icon(
                      onPressed: controller.toggleFilters,
                      icon: Icon(
                        controller.showFilters.value
                            ? Icons.filter_list_off
                            : Icons.filter_list,
                        size: 18.sp,
                      ),
                      label: Text(
                        controller.showFilters.value
                            ? 'Hide Filters'
                            : 'Show Filters',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        side: BorderSide(
                          color: controller.activeFilterCount > 0
                              ? AppColors.primary
                              : Colors.grey[300]!,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Search Field
                  SizedBox(
                    width: 300.w,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search doctors...',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        // contentPadding: EdgeInsets.symmetric(
                        //   horizontal: 16.w,
                        //   vertical: 12.h,
                        // ),
                      ),
                      onChanged: controller.searchDoctors,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Add Doctor Button
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed('/doctors/add'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Doctor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Quick Filters and Sorting
          Row(
            children: [
              // View Mode Chips
              Obx(
                () => _buildViewModeChip(
                  'All Doctors',
                  controller.doctors.length,
                  controller.filteredDoctors.length ==
                      controller.doctors.length,
                  () {
                    controller.clearFilters();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Obx(
                () => _buildViewModeChip(
                  'With Appointments',
                  controller.doctorsWithAppointments.length,
                  false,
                  () {
                    controller.loadDoctorsWithAppointments();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              if (controller.isLoadingDoctorsWithAppointments.value)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              const Spacer(),
              // Sort Dropdown
              Text(
                'Sort by:',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => DropdownButton<String>(
                  value: controller.sortBy.value,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name')),
                    DropdownMenuItem(
                      value: 'experience',
                      child: Text('Experience'),
                    ),
                    DropdownMenuItem(value: 'fee', child: Text('Fee')),
                    DropdownMenuItem(value: 'status', child: Text('Status')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.changeSortBy(value);
                    }
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => IconButton(
                  icon: Icon(
                    controller.sortAscending.value
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 20.sp,
                  ),
                  onPressed: () => controller.toggleSortDirection(),
                  tooltip: controller.sortAscending.value
                      ? 'Ascending'
                      : 'Descending',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeChip(
    String label,
    int count,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey[300]!,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey[400],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsTable(DoctorsController controller) {
    return Container(
      margin: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppColors.primary.withOpacity(0.05),
          ),
          headingRowHeight: 56.h,
          dataRowHeight: 72.h,
          columns: [
            DataColumn(
              label: Text(
                'ID',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Doctor',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Specialty',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Experience',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Fee',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Appointment',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: AppTextStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: controller.filteredDoctors.map((doctor) {
            return DataRow(
              cells: [
                DataCell(Text('#${doctor.id}')),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        doctor.name,
                        style: AppTextStyles.subtitle2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doctor.degrees,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      doctor.specialty,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text('${doctor.experience} years'),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    '৳${doctor.fee.toStringAsFixed(0)}',
                    style: AppTextStyles.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: (doctor.appointmentsCount ?? 0) > 0
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: (doctor.appointmentsCount ?? 0) > 0
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      (doctor.appointmentsCount ?? 0) > 0
                          ? '${doctor.appointmentsCount} Appointments'
                          : 'No Appointment',
                      style: AppTextStyles.caption.copyWith(
                        color: (doctor.appointmentsCount ?? 0) > 0
                            ? AppColors.primary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Tooltip(
                    message: 'View Details',
                    child: IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () =>
                          Get.toNamed('/doctors/detail', arguments: doctor),
                      iconSize: 20.sp,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16.h),
          Text(
            'No doctors found',
            style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or add a new doctor',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/doctors/add'),
            icon: const Icon(Icons.add),
            label: const Text('Add Doctor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            ),
          ),
        ],
      ),
    );
  }
}
