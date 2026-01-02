import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/diagnostic_booking_controller.dart';
import '../../routes/admin_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/admin_sidebar.dart';

class DiagnosticBookingsListScreen extends StatelessWidget {
  const DiagnosticBookingsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiagnosticBookingsController());

    return Scaffold(
      body: Row(
        children: [
           AdminSidebar(selectedRoute: AdminRoutes.DIAGNOSTIC_BOOKINGS),
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

                      if (controller.filteredBookings.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.science_outlined,
                                size: 80.sp,
                                color: AppColors.textHint,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No diagnostic bookings found',
                                style: AppTextStyles.h4,
                              ),
                            ],
                          ),
                        );
                      }

                      return _buildBookingsTable(controller);
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

  Widget _buildTopBar(DiagnosticBookingsController controller) {
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
                'Diagnostic Bookings Management',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage all diagnostic test bookings',
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
                    hintText: 'Search by patient, test, phone...',
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
                  onChanged: controller.searchBookings,
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                onPressed: () => controller.loadBookings(),
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

  Widget _buildStatsBar(DiagnosticBookingsController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      color: Colors.white,
      child: Row(
        children: [
          _buildStatItem(
            'Total',
            controller.totalBookings.toString(),
            AppColors.info,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Pending',
            controller.pendingCount.toString(),
            AppColors.pending,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Confirmed',
            controller.confirmedCount.toString(),
            AppColors.approved,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Completed',
            controller.completedCount.toString(),
            AppColors.completed,
          ),
          SizedBox(width: 24.w),
          _buildStatItem(
            'Cancelled',
            controller.cancelledCount.toString(),
            AppColors.cancelled,
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

  Widget _buildFilterBar(DiagnosticBookingsController controller) {
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
          _buildFilterChip(controller, 'Confirmed', 'confirmed'),
          SizedBox(width: 12.w),
          _buildFilterChip(controller, 'Completed', 'completed'),
          SizedBox(width: 12.w),
          _buildFilterChip(controller, 'Cancelled', 'cancelled'),
        ],
      )),
    );
  }

  Widget _buildFilterChip(
      DiagnosticBookingsController controller,
      String label,
      String value,
      ) {
    final isSelected = controller.selectedStatus.value == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => controller.filterByStatus(value),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildBookingsTable(DiagnosticBookingsController controller) {
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
            DataColumn(label: Text('Test Name', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Category', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Schedule Date', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Status', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Actions', style: AppTextStyles.subtitle1)),
          ],
          rows: controller.filteredBookings.map((booking) {
            final date = DateTime.parse(booking.scheduleDate);
            final formattedDate = DateFormat('dd MMM yyyy').format(date);

            return DataRow(
              cells: [
                DataCell(Text(booking.id.toString())),
                DataCell(
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      booking.patientName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(booking.patientPhone)),
                DataCell(
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      booking.diagnosticName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(booking.diagnosticCategory)),
                DataCell(Text(formattedDate)),
                DataCell(StatusBadge(status: booking.status)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, color: AppColors.info),
                        onPressed: () => _showBookingDetails(booking),
                        tooltip: 'View Details',
                      ),
                      if (booking.status == 'pending')
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            controller.updateBookingStatus(
                              booking.id,
                              value,
                            );
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'confirmed',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.success),
                                  SizedBox(width: 8),
                                  Text('Confirm'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'cancelled',
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, color: AppColors.error),
                                  SizedBox(width: 8),
                                  Text('Cancel'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (booking.status == 'confirmed')
                        IconButton(
                          icon: const Icon(Icons.done_all, color: AppColors.success),
                          onPressed: () => controller.updateBookingStatus(
                            booking.id,
                            'completed',
                          ),
                          tooltip: 'Mark Completed',
                        ),
                      if (booking.status == 'pending')
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.error),
                          onPressed: () => _showCancelDialog(controller, booking.id),
                          tooltip: 'Cancel with Reason',
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        onPressed: () => controller.deleteBooking(booking.id),
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

  void _showBookingDetails(booking) {
    final date = DateTime.parse(booking.scheduleDate);
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
                    'Booking Details',
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
                _buildDetailRow('Name', booking.patientName),
                _buildDetailRow('Phone', booking.patientPhone),
              ]),

              SizedBox(height: 20.h),

              _buildDetailSection('Test Information', [
                _buildDetailRow('Test Name', booking.diagnosticName),
                _buildDetailRow('Category', booking.diagnosticCategory),
              ]),

              SizedBox(height: 20.h),

              _buildDetailSection('Booking Details', [
                _buildDetailRow('Schedule Date', formattedDate),
                _buildDetailRow('Status', ''),
              ]),

              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
                child: StatusBadge(status: booking.status, fontSize: 13.sp),
              ),

              if (booking.notes != null) ...[
                SizedBox(height: 20.h),
                _buildDetailSection('Notes', [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      booking.notes!,
                      style: AppTextStyles.body2,
                    ),
                  ),
                ]),
              ],

              if (booking.cancellationReason != null) ...[
                SizedBox(height: 20.h),
                _buildDetailSection('Cancellation Reason', [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      booking.cancellationReason!,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(DiagnosticBookingsController controller, int bookingId) {
    final reasonController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 450.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cancel Booking',
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Please provide a reason for cancellation:',
                style: AppTextStyles.body2,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter cancellation reason...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      reasonController.dispose();
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      if (reasonController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please provide a cancellation reason',
                          backgroundColor: AppColors.error,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.cancelBooking(bookingId, reasonController.text.trim());
                      reasonController.dispose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text('Confirm Cancel'),
                  ),
                ],
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