import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/doctor_controller.dart';
import '../../models/doctor_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/admin_sidebar.dart';
import '../../widgets/custom_textfield.dart';


class EditDoctorScreen extends StatelessWidget {
  EditDoctorScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  void _addWorkingDay(BuildContext context, DoctorsController controller) {
    final List<String> days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    showDialog(
      context: context,
      builder: (context) {
        String selectedDay = days[0];
        final startTimeController = TextEditingController(text: '09:00');
        final endTimeController = TextEditingController(text: '17:00');

        return AlertDialog(
          title: const Text('Add Working Day'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedDay,
                isExpanded: true,
                items: days
                    .map(
                      (day) => DropdownMenuItem(value: day, child: Text(day)),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedDay = value ?? selectedDay;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  label: Text('Start Time (HH:MM)'),
                  hintText: '09:00',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endTimeController,
                decoration: const InputDecoration(
                  label: Text('End Time (HH:MM)'),
                  hintText: '17:00',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.addWorkingDay(
                  DaySchedule(
                    day: selectedDay,
                    startTime: startTimeController.text.trim(),
                    endTime: endTimeController.text.trim(),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(BuildContext context, DoctorsController controller, DoctorModel doctor) {
    if (_formKey.currentState!.validate()) {
      if (controller.workingDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one working day')),
        );
        return;
      }

      final languages = controller.languagesController.text
          .trim()
          .split(',')
          .map((e) => e.trim())
          .toList();

      final updatedDoctor = DoctorModel(
        id: doctor.id,
        name: controller.nameController.text.trim(),
        email: controller.emailController.text.trim(),
        password: controller.passwordController.text.trim(),
        phone: controller.phoneController.text.trim(),
        degrees: controller.degreesController.text.trim(),
        specialty: controller.specialtyController.text.trim(),
        experience: int.parse(controller.experienceController.text.trim()),
        workingAt: controller.workingAtController.text.trim(),
        fee: double.parse(controller.feeController.text.trim()),
        biography: controller.biographyController.text.trim(),
        languages: languages,
        workingDays: controller.workingDays,
        consultLimitPerDay: int.parse(controller.consultLimitController.text),
      );

      controller.updateDoctor(doctor.id!, updatedDoctor);
    }
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DoctorsController>();
    final doctor = Get.arguments as DoctorModel;
    // Pre-fill controller fields if not already set
    controller.nameController.text = doctor.name;
    controller.emailController.text = doctor.email;
    controller.passwordController.text = doctor.password;
    controller.phoneController.text = doctor.phone ?? '';
    controller.degreesController.text = doctor.degrees;
    controller.specialtyController.text = doctor.specialty;
    controller.experienceController.text = doctor.experience.toString();
    controller.workingAtController.text = doctor.workingAt;
    controller.feeController.text = doctor.fee.toString();
    controller.biographyController.text = doctor.biography;
    controller.languagesController.text = doctor.languages?.join(', ') ?? '';
    controller.consultLimitController.text = (doctor.consultLimitPerDay ?? 30).toString();
    controller.workingDays.value = doctor.workingDays ?? [];

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
                                      controller: controller.nameController,
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
                                      controller: controller.emailController,
                                      label: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email is required';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Enter valid email';
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
                                      controller: controller.passwordController,
                                      label: 'Password',
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password is required';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: controller.phoneController,
                                      label: 'Phone Number',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Phone is required';
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
                                      controller: controller.degreesController,
                                      label: 'Degrees',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Degrees required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: controller.specialtyController,
                                      label: 'Specialty',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Specialty is required';
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
                                      controller: controller.experienceController,
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
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: controller.workingAtController,
                                      label: 'Working At',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Working place is required';
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
                                      controller: controller.feeController,
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
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: controller.consultLimitController,
                                      label: 'Consult Limit Per Day',
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
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
                                      controller: controller.languagesController,
                                      label: 'Languages (comma-separated)',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Languages required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              CustomTextField(
                                controller: controller.biographyController,
                                label: 'Biography',
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Biography is required';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 24.h),

                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Working Days',
                                          style: AppTextStyles.body2,
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () => _addWorkingDay(context, controller),
                                          icon: const Icon(Icons.add),
                                          label: const Text('Add Day'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Obx(() {
                                      if (controller.workingDays.isEmpty) {
                                        return Text(
                                          'No working days added yet',
                                          style: AppTextStyles.body2.copyWith(
                                            color: Colors.grey,
                                          ),
                                        );
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: controller.workingDays.length,
                                          itemBuilder: (context, index) {
                                            final day = controller.workingDays[index];
                                            return Padding(
                                              padding: EdgeInsets.only(top: 8.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${day.day}: ${day.startTime} - ${day.endTime}',
                                                    style: AppTextStyles.body2,
                                                  ),
                                                  IconButton(
                                                    onPressed: () => controller.removeWorkingDay(index),
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    constraints: BoxConstraints(
                                                      minWidth: 24.w,
                                                      minHeight: 24.h,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    iconSize: 18.sp,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
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
                                    onPressed: () => _handleSubmit(context, controller, doctor),
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
