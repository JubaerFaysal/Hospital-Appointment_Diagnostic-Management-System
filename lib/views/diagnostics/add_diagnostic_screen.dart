import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/diagnostics_controller.dart';
import '../../models/diagnostic_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/custom_textfield.dart';

class AddDiagnosticScreen extends StatelessWidget {
  const AddDiagnosticScreen({super.key});

  void _handleSubmit(DiagnosticsController controller, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      final diagnostic = DiagnosticModel(
        testName: controller.testNameController.text.trim(),
        category: controller.categoryController.text.trim(),
        department: controller.departmentController.text.trim(),
        price: double.parse(controller.priceController.text.trim()),
        description: controller.descriptionController.text.trim(),
        preparation: controller.preparationController.text.trim(),
      );

      controller.createDiagnostic(diagnostic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiagnosticsController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(selectedRoute: '/diagnostics'),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Container(
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Test Information',
                                style: AppTextStyles.h4.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24.h),

                              CustomTextField(
                                controller: controller.testNameController,
                                label: 'Test Name',
                                hint: 'Complete Blood Count (CBC)',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Test name is required';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: controller.categoryController,
                                      label: 'Category',
                                      hint: 'Blood Tests',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Category is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: controller.departmentController,
                                      label: 'Department',
                                      hint: 'Pathology',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Department is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: controller.priceController,
                                label: 'Price (৳)',
                                hint: '500',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Price is required';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Enter valid amount';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: controller.descriptionController,
                                label: 'Description',
                                hint: 'Brief description of the test...',
                                maxLines: 3,
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: controller.preparationController,
                                label: 'Preparation Required',
                                hint: 'Fasting for 8-12 hours...',
                                maxLines: 3,
                              ),

                              SizedBox(height: 20.h),

                              // Image picker section
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Test Image',
                                      style: AppTextStyles.body2.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Obx(() {
                                      final imageFile = controller
                                          .imagePickerService
                                          .selectedImage
                                          .value;
                                      final hasImage = imageFile != null;

                                      return Column(
                                        children: [
                                          if (hasImage)
                                            Container(
                                              height: 200.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: FutureBuilder<Uint8List>(
                                                  future: imageFile.readAsBytes(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Image.memory(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          SizedBox(height: 12.h),
                                          Row(
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () => controller
                                                    .imagePickerService
                                                    .pickImage(),
                                                icon: Icon(
                                                  hasImage
                                                      ? Icons.edit
                                                      : Icons.add_photo_alternate,
                                                ),
                                                label: Text(
                                                  hasImage
                                                      ? 'Change Image'
                                                      : 'Select Image',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.secondary,
                                                ),
                                              ),
                                              if (hasImage) ...[
                                                SizedBox(width: 12.w),
                                                OutlinedButton.icon(
                                                  onPressed: () => controller
                                                      .imagePickerService
                                                      .clearImage(),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                  ),
                                                  label: const Text('Remove'),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),

                              SizedBox(height: 32.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.w,
                                        vertical: 16.h,
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                  SizedBox(width: 16.w),
                                  ElevatedButton(
                                    onPressed: () => _handleSubmit(controller, formKey),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.w,
                                        vertical: 16.h,
                                      ),
                                    ),
                                    child: const Text('Add Test'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
          Text(
            'Add New Diagnostic Test',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
