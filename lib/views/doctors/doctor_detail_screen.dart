import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/doctor_controller.dart';
import '../../models/doctor_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({Key? key}) : super(key: key);

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final controller = Get.find<DoctorsController>();
  late DoctorModel doctor;
  String selectedStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    doctor = Get.arguments as DoctorModel;
    // Load appointments for this doctor
    controller.getDoctorAppointments(doctor.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: '/doctors'),
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
                          _buildDoctorProfileCard(),
                          SizedBox(height: 24.h),
                          _buildStatisticsCards(),
                          SizedBox(height: 24.h),
                          _buildWorkingScheduleCard(),
                          SizedBox(height: 24.h),
                          _buildAppointmentsSection(),
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
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor Details',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                'View doctor information and appointments',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed('/doctors/edit', arguments: doctor),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Doctor'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton.icon(
            onPressed: () => controller.deleteDoctor(doctor.id!),
            icon: const Icon(Icons.delete),
            label: const Text('Delete Doctor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorProfileCard() {
    return Container(
      padding: EdgeInsets.all(32.w),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: doctor.profilePic != null && doctor.profilePic!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      doctor.profilePic!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 60.sp,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  )
                : Icon(Icons.person, size: 60.sp, color: AppColors.primary),
          ),
          SizedBox(width: 32.w),
          // Doctor Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  doctor.specialty,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.degrees,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 24.w,
                  runSpacing: 12.h,
                  children: [
                    _buildInfoChip(
                      Icons.work_outline,
                      '${doctor.experience} years experience',
                    ),
                    _buildInfoChip(
                      Icons.location_on_outlined,
                      doctor.workingAt,
                    ),
                    _buildInfoChip(Icons.phone_outlined, doctor.phone ?? 'N/A'),
                    _buildInfoChip(Icons.email_outlined, doctor.email),
                    _buildInfoChip(
                      Icons.attach_money,
                      '৳${doctor.fee.toStringAsFixed(0)} consultation fee',
                    ),
                  ],
                ),
                if (doctor.languages != null &&
                    doctor.languages!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 18.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Languages: ${doctor.languages!.join(', ')}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 16.h),
                Text(
                  'Biography',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  doctor.biography,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18.sp, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          text,
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    return Obx(() {
      if (controller.isLoadingAppointments.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Appointments',
              controller.totalAppointments.toString(),
              Icons.calendar_today,
              AppColors.primary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatCard(
              'Pending',
              controller.pendingAppointments.toString(),
              Icons.pending_outlined,
              Colors.orange,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatCard(
              'Confirmed',
              controller.confirmedAppointments.toString(),
              Icons.check_circle_outline,
              Colors.blue,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatCard(
              'Completed',
              controller.completedAppointments.toString(),
              Icons.done_all,
              Colors.green,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatCard(
              'Cancelled',
              controller.cancelledAppointments.toString(),
              Icons.cancel_outlined,
              Colors.red,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28.sp),
              Text(
                value,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingScheduleCard() {
    if (doctor.workingDays == null || doctor.workingDays!.isEmpty) {
      return const SizedBox.shrink();
    }

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
            'Working Schedule',
            style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 12.h,
            children: doctor.workingDays!.map((schedule) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${schedule.day}: ${schedule.startTime} - ${schedule.endTime}',
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (doctor.consultLimitPerDay != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 18.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Consultation Limit: ${doctor.consultLimitPerDay} patients per day',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
              ),
              _buildStatusFilter(),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.isLoadingAppointments.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final filteredAppointments = selectedStatusFilter == 'all'
                ? controller.doctorAppointments
                : controller.doctorAppointments
                      .where((apt) => apt.status == selectedStatusFilter)
                      .toList();

            if (filteredAppointments.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64.sp,
                        color: AppColors.textHint,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No appointments found',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('Serial', style: AppTextStyles.subtitle1),
                  ),
                  DataColumn(
                    label: Text('Date', style: AppTextStyles.subtitle1),
                  ),
                  DataColumn(
                    label: Text('Patient', style: AppTextStyles.subtitle1),
                  ),
                  DataColumn(
                    label: Text('Phone', style: AppTextStyles.subtitle1),
                  ),
                  DataColumn(
                    label: Text('Status', style: AppTextStyles.subtitle1),
                  ),
                ],
                rows: filteredAppointments.map((appointment) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          appointment.serialNumber != null
                              ? '#${appointment.serialNumber}'
                              : 'N/A',
                          style: AppTextStyles.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      DataCell(Text(_formatDate(appointment.date))),
                      DataCell(Text(appointment.patientName)),
                      DataCell(Text(appointment.patientPhone)),
                      DataCell(_buildStatusBadge(appointment.status)),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    final statuses = ['all', 'pending', 'confirmed', 'completed', 'cancelled'];

    return DropdownButton<String>(
      value: selectedStatusFilter,
      items: statuses.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(
            status == 'all' ? 'All Status' : status.toUpperCase(),
            style: AppTextStyles.body2,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedStatusFilter = value ?? 'all';
        });
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
