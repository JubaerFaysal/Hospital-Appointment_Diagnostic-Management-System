import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/diagnostics_controller.dart';
import '../../data/models/diagnostic_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/custom_textfield.dart';

class EditDiagnosticScreen extends StatefulWidget {
  const EditDiagnosticScreen({Key? key}) : super(key: key);

  @override
  State<EditDiagnosticScreen> createState() => _EditDiagnosticScreenState();
}

class _EditDiagnosticScreenState extends State<EditDiagnosticScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<DiagnosticsController>();
  late DiagnosticModel diagnostic;

  late TextEditingController _testNameController;
  late TextEditingController _categoryController;
  late TextEditingController _departmentController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _preparationController;

  @override
  void initState() {
    super.initState();
    diagnostic = Get.arguments as DiagnosticModel;

    _testNameController = TextEditingController(text: diagnostic.testName);
    _categoryController = TextEditingController(text: diagnostic.category);
    _departmentController = TextEditingController(text: diagnostic.department);
    _priceController = TextEditingController(text: diagnostic.price.toString());
    _descriptionController = TextEditingController(text: diagnostic.description ?? '');
    _preparationController = TextEditingController(text: diagnostic.preparation ?? '');
  }

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
      final updatedDiagnostic = DiagnosticModel(
        id: diagnostic.id,
        testName: _testNameController.text.trim(),
        category: _categoryController.text.trim(),
        department: _departmentController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        preparation: _preparationController.text.trim(),
      );

      controller.updateDiagnostic(diagnostic.id!, updatedDiagnostic);
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
                                'Edit Test Information',
                                style: AppTextStyles.h4.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24.h),

                              CustomTextField(
                                controller: _testNameController,
                                label: 'Test Name',
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
                                maxLines: 3,
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: _preparationController,
                                label: 'Preparation Required',
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
                                    child: const Text('Update Test'),
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
            'Edit Diagnostic Test',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}