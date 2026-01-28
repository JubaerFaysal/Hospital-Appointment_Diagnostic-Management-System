// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../controller/doctor_controller.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_text_styles.dart';
//
// class DoctorFilterPanel extends StatelessWidget {
//   const DoctorFilterPanel({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<DoctorsController>();
//
//     return Container(
//       width: 320.w,
//       height: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(2, 0),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildHeader(controller),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildStatusFilter(controller),
//                   SizedBox(height: 24.h),
//                   _buildSpecialtyFilter(controller),
//                   SizedBox(height: 24.h),
//                   _buildExperienceFilter(controller),
//                   SizedBox(height: 24.h),
//                   _buildFeeFilter(controller),
//                 ],
//               ),
//             ),
//           ),
//           _buildFooter(controller),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(DoctorsController controller) {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.05),
//         border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.filter_list, color: AppColors.primary, size: 24.sp),
//               SizedBox(width: 12.w),
//               Text(
//                 'Filters',
//                 style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           Obx(() {
//             final count = controller.activeFilterCount;
//             if (count == 0) return const SizedBox.shrink();
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Text(
//                 count.toString(),
//                 style: AppTextStyles.caption.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusFilter(DoctorsController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Status',
//           style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 12.h),
//         Obx(
//           () => Wrap(
//             spacing: 8.w,
//             runSpacing: 8.h,
//             children: ['active', 'inactive', 'suspended'].map((status) {
//               final isSelected = controller.selectedStatuses.contains(status);
//               return FilterChip(
//                 label: Text(status.toUpperCase()),
//                 selected: isSelected,
//                 onSelected: (selected) {
//                   if (selected) {
//                     controller.selectedStatuses.add(status);
//                   } else {
//                     controller.selectedStatuses.remove(status);
//                   }
//                   controller.applyFilters();
//                 },
//                 selectedColor: AppColors.primary.withOpacity(0.2),
//                 checkmarkColor: AppColors.primary,
//                 labelStyle: AppTextStyles.caption.copyWith(
//                   color: isSelected
//                       ? AppColors.primary
//                       : AppColors.textSecondary,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSpecialtyFilter(DoctorsController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Specialty',
//           style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 12.h),
//         Obx(() {
//           if (controller.availableSpecialties.isEmpty) {
//             return Text(
//               'No specialties available',
//               style: AppTextStyles.body2.copyWith(color: AppColors.textHint),
//             );
//           }
//
//           return Column(
//             children: controller.availableSpecialties.map((specialty) {
//               final isSelected = controller.selectedSpecialties.contains(
//                 specialty,
//               );
//               return CheckboxListTile(
//                 title: Text(specialty, style: AppTextStyles.body2),
//                 value: isSelected,
//                 onChanged: (selected) {
//                   if (selected == true) {
//                     controller.selectedSpecialties.add(specialty);
//                   } else {
//                     controller.selectedSpecialties.remove(specialty);
//                   }
//                   controller.applyFilters();
//                 },
//                 activeColor: AppColors.primary,
//                 dense: true,
//                 contentPadding: EdgeInsets.zero,
//               );
//             }).toList(),
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _buildExperienceFilter(DoctorsController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Experience (Years)',
//           style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8.h),
//         Obx(
//           () => Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '${controller.minExperience.value} years',
//                 style: AppTextStyles.body2.copyWith(color: AppColors.primary),
//               ),
//               Text(
//                 '${controller.maxExperience.value} years',
//                 style: AppTextStyles.body2.copyWith(color: AppColors.primary),
//               ),
//             ],
//           ),
//         ),
//         Obx(
//           () => RangeSlider(
//             values: RangeValues(
//               controller.minExperience.value.toDouble(),
//               controller.maxExperience.value.toDouble(),
//             ),
//             min: 0,
//             max: 50,
//             divisions: 50,
//             activeColor: AppColors.primary,
//             onChanged: (values) {
//               controller.minExperience.value = values.start.toInt();
//               controller.maxExperience.value = values.end.toInt();
//             },
//             onChangeEnd: (values) {
//               controller.applyFilters();
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFeeFilter(DoctorsController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Consultation Fee (৳)',
//           style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8.h),
//         Obx(
//           () => Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '৳${controller.minFee.value.toInt()}',
//                 style: AppTextStyles.body2.copyWith(color: AppColors.primary),
//               ),
//               Text(
//                 '৳${controller.maxFee.value.toInt()}',
//                 style: AppTextStyles.body2.copyWith(color: AppColors.primary),
//               ),
//             ],
//           ),
//         ),
//         Obx(
//           () => RangeSlider(
//             values: RangeValues(
//               controller.minFee.value,
//               controller.maxFee.value,
//             ),
//             min: 0,
//             max: 10000,
//             divisions: 100,
//             activeColor: AppColors.primary,
//             onChanged: (values) {
//               controller.minFee.value = values.start;
//               controller.maxFee.value = values.end;
//             },
//             onChangeEnd: (values) {
//               controller.applyFilters();
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFooter(DoctorsController controller) {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey[200]!)),
//       ),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: () => controller.applyFilters(),
//               icon: const Icon(Icons.check),
//               label: const Text('Apply Filters'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//               ),
//             ),
//           ),
//           SizedBox(height: 12.h),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: () => controller.clearFilters(),
//               icon: const Icon(Icons.clear_all),
//               label: const Text('Clear All'),
//               style: OutlinedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 14.h),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
