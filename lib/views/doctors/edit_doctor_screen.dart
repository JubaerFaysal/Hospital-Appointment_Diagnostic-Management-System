import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/doctor_controller.dart';
import '../../models/doctor_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/custom_textfield.dart';

class EditDoctorScreen extends StatefulWidget {
  const EditDoctorScreen({Key? key}) : super(key: key);

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<DoctorsController>();
  late DoctorModel doctor;

  late TextEditingController _nameController;
  late TextEditingController _degreesController;
  late TextEditingController _specialtyController;
  late TextEditingController _experienceController;
  late TextEditingController _workingAtController;
  late TextEditingController _feeController;
  late TextEditingController _biographyController;

  @override
  void initState() {
    super.initState();
    doctor = Get.arguments as DoctorModel;

    _nameController = TextEditingController(text: doctor.name);
    _degreesController = TextEditingController(text: doctor.degrees);
    _specialtyController = TextEditingController(text: doctor.specialty);
    _experienceController = TextEditingController(text: doctor.experience.toString());
    _workingAtController = TextEditingController(text: doctor.workingAt);
    _feeController = TextEditingController(text: doctor.fee.toString());
    _biographyController = TextEditingController(text: doctor.biography);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _degreesController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _workingAtController.dispose();
    _feeController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final updatedDoctor = DoctorModel(
        id: doctor.id,
        name: _nameController.text.trim(),
        degrees: _degreesController.text.trim(),
        specialty: _specialtyController.text.trim(),
        experience: int.parse(_experienceController.text.trim()),
        workingAt: _workingAtController.text.trim(),
        fee: double.parse(_feeController.text.trim()),
        biography: _biographyController.text.trim(),
      );

      controller.updateDoctor(doctor.id!, updatedDoctor);
    }
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
                                'Edit Doctor Information',
                                style: AppTextStyles.h4.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _nameController,
                                      label: 'Full Name',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _degreesController,
                                      label: 'Degrees',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Degrees required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _specialtyController,
                                      label: 'Specialty',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Specialty is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _experienceController,
                                      label: 'Experience (Years)',
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Experience is required';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Enter valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _workingAtController,
                                      label: 'Working At',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Working place is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _feeController,
                                      label: 'Consultation Fee (৳)',
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Fee is required';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Enter valid amount';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: _biographyController,
                                label: 'Biography',
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Biography is required';
                                  }
                                  return null;
                                },
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
                                      backgroundColor: AppColors.primary,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.w,
                                        vertical: 16.h,
                                      ),
                                    ),
                                    child: const Text('Update Doctor'),
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
            'Edit Doctor',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}