import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/diagnostic_booking_controller.dart';
import '../../routes/admin_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/status_badge.dart';

class DiagnosticBookingsListScreen extends StatefulWidget {
  const DiagnosticBookingsListScreen({super.key});

  @override
  State<DiagnosticBookingsListScreen> createState() =>
      _DiagnosticBookingsListScreenState();
}

class _DiagnosticBookingsListScreenState
    extends State<DiagnosticBookingsListScreen> {
  //final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiagnosticBookingsController());

    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(selectedRoute: AdminRoutes.DIAGNOSTIC_BOOKINGS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }

  Widget _buildTopBar(DiagnosticBookingsController controller) {
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
                  gradient: AppColors.warningGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.science_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diagnostic Bookings',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Manage all diagnostic test bookings',
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
                    hintText: 'Search by patient, test...',
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
                  onChanged: controller.searchBookings,
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
                  onPressed: () => controller.loadBookings(),
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

  Widget _buildStatsBar(DiagnosticBookingsController controller) {
    return Obx(
      () => Container(
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
        child: Row(
          children: [
            _buildStatItem(
              'Total',
              controller.totalBookings.toString(),
              AppColors.info,
              Icons.list_alt_rounded,
            ),
            SizedBox(width: 16.w),
            _buildStatItem(
              'Pending',
              controller.pendingCount.toString(),
              AppColors.pending,
              Icons.schedule_rounded,
            ),
            SizedBox(width: 16.w),
            _buildStatItem(
              'Confirmed',
              controller.confirmedCount.toString(),
              AppColors.confirmed,
              Icons.check_circle_rounded,
            ),
            SizedBox(width: 16.w),
            _buildStatItem(
              'Completed',
              controller.completedCount.toString(),
              AppColors.completed,
              Icons.task_alt_rounded,
            ),
            SizedBox(width: 16.w),
            _buildStatItem(
              'Cancelled',
              controller.cancelledCount.toString(),
              AppColors.cancelled,
              Icons.cancel_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.w),
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
              value,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: color,
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

  Widget _buildFilterBar(DiagnosticBookingsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Obx(
        () => Row(
          children: [
            Text(
              'Filter by Status:',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 16.w),
            _buildFilterChip(controller, 'All', 'all'),
            SizedBox(width: 10.w),
            _buildFilterChip(controller, 'Pending', 'pending'),
            SizedBox(width: 10.w),
            _buildFilterChip(controller, 'Confirmed', 'confirmed'),
            SizedBox(width: 10.w),
            _buildFilterChip(controller, 'Completed', 'completed'),
            SizedBox(width: 10.w),
            _buildFilterChip(controller, 'Cancelled', 'cancelled'),
          ],
        ),
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.textSecondary,
      ),
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      backgroundColor: AppColors.background,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
    );
  }

  Widget _buildBookingsTable(DiagnosticBookingsController controller) {
    return SingleChildScrollView(
      child: Container(
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.background),
            headingTextStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
            dataTextStyle: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
            ),
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Patient')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Test Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Schedule Date')),
              DataColumn(label: Text('Payment')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: controller.filteredBookings.map((booking) {
              final date = DateTime.parse(booking.scheduleDate);
              final formattedDate = DateFormat('dd MMM yyyy').format(date);

              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      '#${booking.id}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              booking.patientName.isNotEmpty
                                  ? booking.patientName[0].toUpperCase()
                                  : 'P',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            booking.patientName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      booking.patientPhone.isNotEmpty
                          ? booking.patientPhone
                          : 'N/A',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 180.w,
                      child: Text(
                        booking.diagnosticName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        booking.diagnosticCategory,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(formattedDate, style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                  ),
                  DataCell(
                    StatusBadge(
                      status: booking.isPaid == 'paid' ? 'paid' : 'unpaid',
                      showIcon: true,
                    ),
                  ),
                  DataCell(StatusBadge(status: booking.status)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.visibility,
                            color: AppColors.info,
                          ),
                          onPressed: () => _showBookingDetails(booking),
                          tooltip: 'View Details',
                        ),
                        if (booking.status == 'pending')
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              controller.updateBookingStatus(booking.id, value);
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'confirmed',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                    ),
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
                            icon: const Icon(
                              Icons.done_all,
                              color: AppColors.success,
                            ),
                            onPressed: () => controller.updateBookingStatus(
                              booking.id,
                              'completed',
                            ),
                            tooltip: 'Mark Completed',
                          ),
                        if (booking.status == 'pending')
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.error,
                            ),
                            onPressed: () =>
                                _showCancelDialog(controller, booking.id),
                            tooltip: 'Cancel with Reason',
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                          ),
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
                _buildDetailRow(
                  'Phone',
                  booking.patientPhone.isNotEmpty
                      ? booking.patientPhone
                      : 'N/A',
                ),
              ]),

              SizedBox(height: 20.h),

              _buildDetailSection('Test Information', [
                _buildDetailRow('Test Name', booking.diagnosticName),
                _buildDetailRow('Category', booking.diagnosticCategory),
              ]),

              SizedBox(height: 20.h),

              _buildDetailSection('Booking Details', [
                _buildDetailRow('Schedule Date', formattedDate),
                _buildDetailRow(
                  'Created',
                  DateFormat('dd MMM yyyy, hh:mm a').format(booking.createdAt),
                ),
                _buildDetailRow('Status', ''),
              ]),

              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 8.h),
                child: StatusBadge(status: booking.status, fontSize: 13.sp),
              ),

              if (booking.paymentMethod != null ||
                  booking.paidAmount != null) ...[
                SizedBox(height: 20.h),
                _buildDetailSection('Payment Information', [
                  if (booking.paymentMethod != null)
                    _buildDetailRow(
                      'Payment Method',
                      booking.paymentMethod == 'pay_now'
                          ? 'Pay Now'
                          : 'Pay in Hospital',
                    ),
                  if (booking.paymentStatus != null)
                    _buildDetailRow(
                      'Payment Status',
                      booking.paymentStatus!.toUpperCase(),
                    ),
                  if (booking.isPaid != null)
                    _buildDetailRow(
                      'Payment',
                      booking.isPaid == 'paid' ? '✅ Paid' : '❌ Unpaid',
                    ),
                  if (booking.paidAmount != null)
                    _buildDetailRow('Amount', '৳${booking.paidAmount}'),
                  if (booking.transactionId != null)
                    _buildDetailRow('Transaction ID', booking.transactionId!),
                  if (booking.bankTransactionId != null)
                    _buildDetailRow(
                      'Bank Transaction ID',
                      booking.bankTransactionId!,
                    ),
                ]),
              ],

              if (booking.notes != null) ...[
                SizedBox(height: 20.h),
                _buildDetailSection('Notes', [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(booking.notes!, style: AppTextStyles.body2),
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

  void _showCancelDialog(
    DiagnosticBookingsController controller,
    int bookingId,
  ) {
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
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
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
                      controller.cancelBooking(
                        bookingId,
                        reasonController.text.trim(),
                      );
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
              style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
