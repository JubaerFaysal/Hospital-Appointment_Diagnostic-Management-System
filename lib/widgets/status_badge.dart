import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double? fontSize;
  final EdgeInsets? padding;
  final bool showIcon;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
    this.showIcon = true,
    this.isCompact = false,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      // Pending states
      case 'pending':
        return AppColors.pending;
      // Success/Confirmed states
      case 'confirmed':
      case 'accepted':
      case 'active':
      case 'paid':
        return AppColors.success;
      // Completed states
      case 'completed':
        return AppColors.completed;
      // Warning states
      case 'inactive':
      case 'unpaid':
      case 'processing':
        return AppColors.warning;
      // Danger states
      case 'rejected':
      case 'suspended':
      case 'failed':
        return AppColors.danger;
      // Cancelled states
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'confirmed':
      case 'accepted':
      case 'active':
      case 'paid':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.task_alt_rounded;
      case 'inactive':
      case 'unpaid':
      case 'processing':
        return Icons.hourglass_empty_rounded;
      case 'rejected':
      case 'suspended':
      case 'failed':
        return Icons.cancel_rounded;
      case 'cancelled':
        return Icons.do_not_disturb_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _getStatusLabel() {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'suspended':
        return 'Suspended';
      case 'paid':
        return 'Paid';
      case 'unpaid':
        return 'Unpaid';
      case 'processing':
        return 'Processing';
      case 'rejected':
        return 'Rejected';
      case 'failed':
        return 'Failed';
      default:
        return status[0].toUpperCase() + status.substring(1).toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final effectivePadding = isCompact
        ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
        : (padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h));

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isCompact ? 6.r : 8.r),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getStatusIcon(),
              color: color,
              size: isCompact ? 12.sp : 14.sp,
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            _getStatusLabel(),
            style: TextStyle(
              fontSize: fontSize ?? (isCompact ? 10.sp : 12.sp),
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Payment status specific badge with enhanced styling
class PaymentStatusBadge extends StatelessWidget {
  final bool isPaid;
  final String? method;

  const PaymentStatusBadge({super.key, required this.isPaid, this.method});

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? AppColors.success : AppColors.warning;
    final icon = isPaid ? Icons.payments_rounded : Icons.payment_rounded;
    final label = isPaid ? 'Paid' : 'Unpaid';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              if (method != null && method!.isNotEmpty)
                Text(
                  method!,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: color.withOpacity(0.8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
