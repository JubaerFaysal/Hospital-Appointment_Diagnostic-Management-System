import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/appointments_controller.dart';
import '../../routes/admin_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/status_badge.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({super.key});

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentsController>();

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: AdminRoutes.APPOINTMENTS),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(controller),
                  _buildFilterChips(controller),
                  _buildStatistics(controller),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.filteredAppointments.isEmpty) {
                        return _buildEmptyState();
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointments Management',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Manage and track all doctor appointments',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 280.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search appointments...',
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onChanged: controller.searchAppointments,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: IconButton(
                  onPressed: () => controller.loadAppointments(),
                  icon: Icon(Icons.refresh_rounded, size: 20.sp),
                  tooltip: 'Refresh',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppointmentsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Obx(
        () => Wrap(
          spacing: 10.w,
          children: controller.statusFilters.map((status) {
            final isSelected = controller.selectedStatus.value == status;
            return FilterChip(
              label: Text(_getStatusLabel(status)),
              selected: isSelected,
              onSelected: (_) => controller.filterByStatus(status),
              backgroundColor: Colors.white,
              selectedColor: _getStatusChipColor(status),
              labelStyle: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              side: BorderSide(
                color: isSelected
                    ? _getStatusChipColor(status)
                    : AppColors.border,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatistics(AppointmentsController controller) {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildStatCard(
              'Total',
              controller.totalAppointments,
              AppColors.primary,
              Icons.calendar_today_rounded,
            ),
            _buildStatCard(
              'Pending',
              controller.pendingCount,
              AppColors.pending,
              Icons.schedule_rounded,
            ),
            _buildStatCard(
              'Confirmed',
              controller.confirmedCount,
              AppColors.confirmed,
              Icons.check_circle_rounded,
            ),
            _buildStatCard(
              'Completed',
              controller.completedCount,
              AppColors.completed,
              Icons.task_alt_rounded,
            ),
            _buildStatCard(
              'Cancelled',
              controller.cancelledCount,
              AppColors.cancelled,
              Icons.cancel_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.w),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.12), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22.sp,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTable(AppointmentsController controller) {
    return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DataTable(
              columnSpacing: 40.w,
              headingRowColor: WidgetStateProperty.all(AppColors.background),
              headingTextStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
              dataTextStyle: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textPrimary,
              ),
              columns: [
                DataColumn(label: Text('#ID')),
                DataColumn(label: Text('Patient')),
                DataColumn(label: Text('Doctor')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Serial #')),
                DataColumn(label: Text('Fee')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: controller.filteredAppointments.map((appointment) {
                String formattedDate = 'N/A';
                try {
                  if (appointment.date.isNotEmpty) {
                    final date = DateTime.parse(appointment.date);
                    formattedDate = DateFormat('dd MMM yyyy').format(date);
                  }
                } catch (e) {
                  formattedDate = appointment.date;
                }
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '#${appointment.id}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                appointment.patientName.isNotEmpty
                                    ? appointment.patientName[0].toUpperCase()
                                    : 'P',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
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
                                appointment.patientName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                appointment.patientPhone.isNotEmpty?appointment.patientPhone:appointment.patientEmail,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.medical_services_rounded,
                                color: AppColors.secondary,
                                size: 18.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                appointment.doctorName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                appointment.doctorSpecialty,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 6.w),
                          Text(formattedDate),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          appointment.serialNumber != null
                              ? '#${appointment.serialNumber}'
                              : 'N/A',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        appointment.fee != null
                            ? '৳${appointment.fee!.toStringAsFixed(0)}'
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    DataCell(StatusBadge(status: appointment.status)),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.visibility_rounded,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              onPressed: () => _showAppointmentDetails(
                                context,
                                appointment,
                              ),
                              tooltip: 'View Details',
                            ),
                          ),
                          SizedBox(width: 4.w),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.textSecondary,
                              size: 20.sp,
                            ),
                            tooltip: 'Actions',
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            onSelected: (value) => _handleAction(
                              controller,
                              value,
                              appointment.id,
                              appointment.status,
                            ),
                            itemBuilder: (context) =>
                                _buildActionMenuItems(appointment.status),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_rounded,
                                color: AppColors.error,
                                size: 18.sp,
                              ),
                              onPressed: () => controller.deleteAppointment(
                                appointment.id,
                              ),
                              tooltip: 'Delete',
                            ),
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

  List<PopupMenuEntry<String>> _buildActionMenuItems(String currentStatus) {
    final items = <PopupMenuEntry<String>>[];

    // Show status options based on current status
    if (currentStatus == 'pending') {
      // Show all remaining statuses
      items.addAll([
        const PopupMenuItem(value: 'confirmed', child: Text('✅ Confirm')),
        const PopupMenuItem(value: 'completed', child: Text('✔️ Complete')),
        const PopupMenuItem(value: 'cancelled', child: Text('🚫 Cancel')),
      ]);
    } else if (currentStatus == 'confirmed') {
      // Show remaining statuses without pending
      items.addAll([
        const PopupMenuItem(value: 'completed', child: Text('✔️ Complete')),
        const PopupMenuItem(value: 'cancelled', child: Text('🚫 Cancel')),
      ]);
    } else if (currentStatus == 'cancelled') {
      // Show nothing - no status changes allowed
    } else if (currentStatus == 'completed') {
      items.add(
        const PopupMenuItem(value: 'view', child: Text('👁️ View Only')),
      );
    }

    return items;
  }

  void _handleAction(
    AppointmentsController controller,
    String action,
    int appointmentId,
    String currentStatus,
  ) {
    if (action == 'view') {
      Get.snackbar('Info', 'Appointment is already completed');
      return;
    }

    if (action == 'cancelled') {
      _showCancelDialog(controller, appointmentId);
    } else {
      controller.updateAppointmentStatus(appointmentId, action);
    }
  }

  void _showCancelDialog(AppointmentsController controller, int appointmentId) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a cancellation reason:'),
            SizedBox(height: 16.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              reasonController.dispose();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                controller.cancelAppointment(
                  appointmentId,
                  reasonController.text.trim(),
                );
                reasonController.dispose();
                Get.back();
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
          Text('No appointments found', style: AppTextStyles.h4),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'all':
        return 'All';
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed'; // ✅ Changed from 'Approved'
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _getStatusChipColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.pending;
      case 'confirmed':
        return AppColors.confirmed;
      case 'completed':
        return AppColors.completed;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.primary;
    }
  }

  void _showAppointmentDetails(BuildContext context, appointment) {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Status Badge
              Row(
                children: [
                  Text('Status: ', style: AppTextStyles.subtitle1),
                  StatusBadge(status: appointment.status),
                ],
              ),
              SizedBox(height: 16.h),

              // Patient Information
              _buildSectionTitle('Patient Information'),
              SizedBox(height: 8.h),
              _buildDetailRow('Name', appointment.patientName),
              _buildDetailRow('Phone', appointment.patientPhone),

              SizedBox(height: 16.h),

              // Doctor Information
              _buildSectionTitle('Doctor Information'),
              SizedBox(height: 8.h),
              _buildDetailRow('Name', appointment.doctorName),
              _buildDetailRow('Specialty', appointment.doctorSpecialty),

              SizedBox(height: 16.h),

              // Appointment Information
              _buildSectionTitle('Appointment Information'),
              SizedBox(height: 8.h),
              _buildDetailRow(
                'Date',
                dateFormatter.format(DateTime.parse(appointment.date)),
              ),
              _buildDetailRow(
                'Serial Number',
                appointment.serialNumber != null
                    ? '#${appointment.serialNumber}'
                    : 'N/A',
              ),
              _buildDetailRow(
                'Fee',
                appointment.fee != null
                    ? '৳${appointment.fee!.toStringAsFixed(0)}'
                    : 'N/A',
              ),

              if (appointment.cancellationReason != null) ...[
                SizedBox(height: 16.h),
                _buildSectionTitle('Cancellation Information'),
                SizedBox(height: 8.h),
                _buildDetailRow('Reason', appointment.cancellationReason!),
              ],

              SizedBox(height: 24.h),

              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.subtitle1.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              '$label:',
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body2)),
        ],
      ),
    );
  }
}
