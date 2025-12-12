import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/diagnostics_controller.dart';
import '../../data/models/diagnostic_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/custom_textfield.dart';

class AddDiagnosticScreen extends StatefulWidget {
  const AddDiagnosticScreen({Key? key}) : super(key: key);

  @override
  State<AddDiagnosticScreen> createState() => _AddDiagnosticScreenState();
}

class _AddDiagnosticScreenState extends State<AddDiagnosticScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<DiagnosticsController>();

  final _testNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _departmentController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _preparationController = TextEditingController();

  @override
  void dispose() {
    _testNameController.dispose();
    _categoryController.dispose();
    _departmentController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _preparationController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final diagnostic = DiagnosticModel(
        testName: _testNameController.text.trim(),
        category: _categoryController.text.trim(),
        department: _departmentController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        preparation: _preparationController.text.trim(),
      );

      controller.createDiagnostic(diagnostic);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          key: _formKey,
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
                                controller: _testNameController,
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
                                      controller: _categoryController,
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
                                      controller: _departmentController,
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
                                controller: _priceController,
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
                                controller: _descriptionController,
                                label: 'Description',
                                hint: 'Brief description of the test...',
                                maxLines: 3,
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: _preparationController,
                                label: 'Preparation Required',
                                hint: 'Fasting for 8-12 hours...',
                                maxLines: 3,
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
                                    onPressed: _handleSubmit,
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