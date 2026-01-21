import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double? fontSize;
  final EdgeInsets? padding;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.pending;
      case 'confirmed':  
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.rejected;
      case 'cancelled':
        return AppColors.cancelled;
      case 'completed':
        return AppColors.completed;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel() {
    // ✅ Ensure consistent display
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'CONFIRMED';
      case 'accepted':
        return 'CONFIRMED'; // ✅ Show as CONFIRMED
      case 'pending':
        return 'PENDING';
      case 'completed':
        return 'COMPLETED';
      case 'rejected':
        return 'REJECTED';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _getStatusLabel(),
        style: TextStyle(
          fontSize: fontSize ?? 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}