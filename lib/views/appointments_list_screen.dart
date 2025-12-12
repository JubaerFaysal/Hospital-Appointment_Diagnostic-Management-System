import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/appointments_controller.dart';
import '../routes/admin_routes.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/status_badge.dart';
import '../widgets/admin_sidebar.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentsController());

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: AppRoutes.APPOINTMENTS),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildTopBar(controller),
                  _buildStatsBar(controller),
                  _buildFilterBar(controller),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.filteredAppointments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 80.sp,
                                color: AppColors.textHint,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No appointments found',
                                style: AppTextStyles.h4,
                              ),
                            ],
                          ),
                        );
                      }

                      return _buildAppointmentsTable(controller);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AppointmentsController controller) {
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
                'Appointments Management',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage all patient appointments',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 300.w,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by patient, doctor, phone...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  onChanged: controller.searchAppointments,
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                onPressed: () => controller.loadAppointments(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                iconSize: 28.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(AppointmentsController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      color: Colors.white,
      child: Row(
        children: [
          _buildStatItem(
            'Total',
            controller.totalAppointments.toString(),
            AppColors.info,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Pending',
            controller.pendingCount.toString(),
            AppColors.warning,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Approved',
            controller.approvedCount.toString(),
            AppColors.success,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Completed',
            controller.completedCount.toString(),
            AppColors.info,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Rejected',
            controller.rejectedCount.toString(),
            AppColors.error,
          ),
        ],
      ),
    ));
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(AppointmentsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      color: Colors.white,
      child: Obx(() => Row(
        children: [
          Text(
            'Filter by Status:',
            style: AppTextStyles.subtitle1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16.w),
          _buildFilterChip(controller, 'All', 'all'),
          SizedBox(width: 12.w),
          _buildFilterChip(controller, 'Pending', 'pending'),
          SizedBox(width: 12.w),
          _buildFilterChip(controller, 'Approved', 'approved'),
          SizedBox(width: 12.w),
          _buildFilterChip(controller, 'Completed', 'completed'),
          SizedBox(width: 12.w),
          _buildFilterChip(controller, 'Rejected', 'rejected'),
        ],
      )),
    );
  }

  Widget _buildFilterChip(
      AppointmentsController controller,
      String label,
      String value,
      ) {
    final isSelected = controller.selectedStatus.value == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => controller.filterByStatus(value),
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 13.sp,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
    );
  }

  Widget _buildAppointmentsTable(AppointmentsController controller) {
    return Container(
      margin: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Patient', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Phone', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Doctor', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Specialty', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Date', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Time Slot', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Fee', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Status', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Actions', style: AppTextStyles.subtitle1)),
          ],
          rows: controller.filteredAppointments.map((appointment) {
            final date = DateTime.parse(appointment.date);
            final formattedDate = DateFormat('dd MMM yyyy').format(date);

            return DataRow(
              cells: [
                DataCell(Text(appointment.id.toString())),
                DataCell(
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      appointment.patientName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(appointment.patientPhone)),
                DataCell(
                  SizedBox(
                    width: 150.w,
                    child: Text(
                      appointment.doctorName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(appointment.doctorSpecialty)),
                DataCell(Text(formattedDate)),
                DataCell(Text(appointment.timeSlot)),
                DataCell(
                  Text(
                    appointment.fee != null
                        ? '৳${appointment.fee!.toStringAsFixed(0)}'
                        : 'N/A',
                  ),
                ),
                DataCell(StatusBadge(status: appointment.status)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, color: AppColors.info),
                        onPressed: () => _showAppointmentDetails(appointment),
                        tooltip: 'View Details',
                      ),
                      if (appointment.status == 'pending')
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            controller.updateAppointmentStatus(
                              appointment.id,
                              value,
                            );
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'approved',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.success),
                                  SizedBox(width: 8),
                                  Text('Approve'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'rejected',
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, color: AppColors.error),
                                  SizedBox(width: 8),
                                  Text('Reject'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (appointment.status == 'approved')
                        IconButton(
                          icon: const Icon(Icons.done_all, color: AppColors.success),
                          onPressed: () => controller.updateAppointmentStatus(
                            appointment.id,
                            'completed',
                          ),
                          tooltip: 'Mark Completed',
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        onPressed: () => controller.deleteAppointment(appointment.id),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAppointmentDetails(appointment) {
    final date = DateTime.parse(appointment.date);
    final formattedDate = DateFormat('EEEE, dd MMM yyyy').format(date);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 600.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointment Details',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              _buildDetailSection('Patient Information', [
                _buildDetailRow('Name', appointment.patientName),
                _buildDetailRow('Phone', appointment.patientPhone),
              ]),

              SizedBox(height: 20.h),

              _buildDetailSection('Doctor Information', [
                _buildDetailRow('Name', appointment.doctorName),
                _buildDetailRow('Specialty', appointment.doctorSpecialty),
                _buildDetailRow('Fee', '৳${appointment.fee?.toStringAsFixed(0) ?? 'N/A'}'),
              ]),

              SizedBox(height: 20.h),

              _buildDetailSection('Appointment Details', [
                _buildDetailRow('Date', formattedDate),
                _buildDetailRow('Time Slot', appointment.timeSlot),
                _buildDetailRow('Status', ''),
              ]),

              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
                child: StatusBadge(status: appointment.status, fontSize: 13.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              '$label:',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}