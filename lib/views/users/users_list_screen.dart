import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/users_controller.dart';
import '../../routes/admin_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/custom_textfield.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: AdminRoutes.USERS),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildTopBar(controller),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.filteredUsers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outlined,
                                size: 80.sp,
                                color: AppColors.textHint,
                              ),
                              SizedBox(height: 16.h),
                              Text('No users found', style: AppTextStyles.h4),
                            ],
                          ),
                        );
                      }

                      return _buildUsersTable(controller);
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

  Widget _buildTopBar(UsersController controller) {
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
                'Users Management',
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage all registered patients',
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
                    hintText: 'Search by name or phone...',
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
                  onChanged: controller.searchUsers,
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                onPressed: () => controller.loadUsers(),
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

  Widget _buildUsersTable(UsersController controller) {
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
            DataColumn(label: Text('Name', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Phone', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Age', style: AppTextStyles.subtitle1)),
            DataColumn(label: Text('Gender', style: AppTextStyles.subtitle1)),
            DataColumn(
              label: Text('Registered', style: AppTextStyles.subtitle1),
            ),
            DataColumn(label: Text('Actions', style: AppTextStyles.subtitle1)),
          ],
          rows: controller.filteredUsers.map((user) {
            String formattedDate = 'N/A';
            try {
              if (user.createdAt.isNotEmpty) {
                final date = DateTime.parse(user.createdAt);
                formattedDate = DateFormat('dd MMM yyyy').format(date);
              }
            } catch (e) {
              formattedDate = user.createdAt;
            }

            return DataRow(
              cells: [
                DataCell(Text(user.id.toString())),
                DataCell(Text(user.name)),
                DataCell(Text(user.phone)),
                DataCell(Text(user.age?.toString() ?? 'N/A')),
                DataCell(Text(user.gender?.toUpperCase() ?? 'N/A')),
                DataCell(Text(formattedDate)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: AppColors.info,
                        ),
                        onPressed: () => _showUserDetails(user),
                        tooltip: 'View',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.warning),
                        onPressed: () => _showEditUserDialog(controller, user),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        onPressed: () => controller.deleteUser(user.id),
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

  void _showUserDetails(user) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 500.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User Details',
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
              _buildDetailRow('ID', user.id.toString()),
              _buildDetailRow('Name', user.name),
              _buildDetailRow('Phone', user.phone),
              _buildDetailRow('Age', user.age?.toString() ?? 'N/A'),
              _buildDetailRow('Gender', user.gender?.toUpperCase() ?? 'N/A'),
              _buildDetailRow('Registered', user.createdAt),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditUserDialog(UsersController controller, user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final ageController = TextEditingController(
      text: user.age?.toString() ?? '',
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          width: 500.w,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit User',
                style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24.h),
              CustomTextField(controller: nameController, label: 'Name'),
              SizedBox(height: 16.h),
              CustomTextField(controller: phoneController, label: 'Phone'),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: ageController,
                label: 'Age',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      nameController.dispose();
                      phoneController.dispose();
                      ageController.dispose();
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      final data = {
                        'name': nameController.text.trim(),
                        'phone': phoneController.text.trim(),
                        if (ageController.text.isNotEmpty)
                          'age': int.parse(ageController.text.trim()),
                      };
                      controller.updateUser(user.id, data);
                      nameController.dispose();
                      phoneController.dispose();
                      ageController.dispose();
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
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
