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

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentsController());

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: AdminRoutes.APPOINTMENTS),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
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
                'Manage all doctor appointments',
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
                    hintText: 'Search appointments...',
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

  Widget _buildFilterChips(AppointmentsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      color: Colors.white,
      child: Obx(() => Wrap(
        spacing: 12.w,
        children: controller.statusFilters.map((status) {
          final isSelected = controller.selectedStatus.value == status;
          return FilterChip(
            label: Text(_getStatusLabel(status)),
            selected: isSelected,
            onSelected: (_) => controller.filterByStatus(status),
            backgroundColor: Colors.white,
            selectedColor: _getStatusChipColor(status),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? _getStatusChipColor(status)
                  : AppColors.border,
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget _buildStatistics(AppointmentsController controller) {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(() => Row(
        children: [
          _buildStatCard('Total', controller.totalAppointments, AppColors.primary),
          _buildStatCard('Pending', controller.pendingCount, AppColors.pending),
          _buildStatCard('Confirmed', controller.confirmedCount, AppColors.confirmed),
          _buildStatCard('Completed', controller.completedCount, AppColors.completed),
          _buildStatCard('Rejected', controller.rejectedCount, AppColors.rejected),
          _buildStatCard('Cancelled', controller.cancelledCount, AppColors.cancelled),
        ],
      )),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: AppTextStyles.h3.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTable(AppointmentsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30.w,
          columns: [
            DataColumn(label: Text('ID', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Patient', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Doctor', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Date', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Time', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Fee', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Status', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Actions', style: AppTextStyles.subtitle1)),
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
                DataCell(Text(appointment.id.toString())),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appointment.patientName,
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        appointment.patientPhone,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        appointment.doctorSpecialty,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
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
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'Actions',
                        onSelected: (value) => _handleAction(
                          controller,
                          value,
                          appointment.id,
                          appointment.status,
                        ),
                        itemBuilder: (context) => _buildActionMenuItems(appointment.status),
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

  List<PopupMenuEntry<String>> _buildActionMenuItems(String currentStatus) {
    final items = <PopupMenuEntry<String>>[];

    // ✅ Correct status transitions
    if (currentStatus == 'pending') {
      items.addAll([
        const PopupMenuItem(value: 'confirmed', child: Text('✅ Confirm')),
        const PopupMenuItem(value: 'rejected', child: Text('❌ Reject')),
        const PopupMenuItem(value: 'cancelled', child: Text('🚫 Cancel')),
      ]);
    } else if (currentStatus == 'confirmed') {
      items.addAll([
        const PopupMenuItem(value: 'completed', child: Text('✔️ Complete')),
        const PopupMenuItem(value: 'cancelled', child: Text('🚫 Cancel')),
      ]);
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
                controller.cancelAppointment(appointmentId, reasonController.text.trim());
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
          Text(
            'No appointments found',
            style: AppTextStyles.h4,
          ),
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
      case 'rejected':
        return 'Rejected';
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
      case 'rejected':
        return AppColors.rejected;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.primary;
    }
  }
}