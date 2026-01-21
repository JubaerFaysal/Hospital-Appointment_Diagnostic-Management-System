import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final String? trend;
  final bool isPositiveTrend;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.gradient,
    this.onTap,
    this.trend,
    this.isPositiveTrend = true,
  }) : super(key: key);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, isHovered ? -4.0 : 0.0),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isHovered
                  ? widget.color.withOpacity(0.3)
                  : AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? widget.color.withOpacity(0.15)
                    : Colors.black.withOpacity(0.04),
                blurRadius: isHovered ? 20 : 12,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient:
                          widget.gradient ??
                          LinearGradient(
                            colors: [
                              widget.color.withOpacity(0.15),
                              widget.color.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24.sp),
                  ),
                  if (widget.trend != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isPositiveTrend
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isPositiveTrend
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: widget.isPositiveTrend
                                ? AppColors.success
                                : AppColors.danger,
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.trend!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: widget.isPositiveTrend
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.subtitle != null && widget.trend == null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        widget.subtitle!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: widget.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Enhanced stat card with gradient background
class GradientStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  const GradientStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.white, size: 22.sp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini stat card for compact views
class MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MiniStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
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
