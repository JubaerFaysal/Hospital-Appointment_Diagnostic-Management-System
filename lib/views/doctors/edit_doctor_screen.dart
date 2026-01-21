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
  const EditDoctorScreen({super.key});

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<DoctorsController>();
  late DoctorModel doctor;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  late TextEditingController _degreesController;
  late TextEditingController _specialtyController;
  late TextEditingController _experienceController;
  late TextEditingController _workingAtController;
  late TextEditingController _feeController;
  late TextEditingController _biographyController;
  late TextEditingController _languagesController;
  late TextEditingController _consultLimitController;

  late List<DaySchedule> _workingDays;

  @override
  void initState() {
    super.initState();
    doctor = Get.arguments as DoctorModel;

    _nameController = TextEditingController(text: doctor.name);
    _emailController = TextEditingController(text: doctor.email);
    _passwordController = TextEditingController(text: doctor.password);
    _phoneController = TextEditingController(text: doctor.phone ?? '');
    _degreesController = TextEditingController(text: doctor.degrees);
    _specialtyController = TextEditingController(text: doctor.specialty);
    _experienceController = TextEditingController(
      text: doctor.experience.toString(),
    );
    _workingAtController = TextEditingController(text: doctor.workingAt);
    _feeController = TextEditingController(text: doctor.fee.toString());
    _biographyController = TextEditingController(text: doctor.biography);
    _languagesController = TextEditingController(
      text: doctor.languages?.join(', ') ?? '',
    );
    _consultLimitController = TextEditingController(
      text: (doctor.consultLimitPerDay ?? 30).toString(),
    );
    _workingDays = doctor.workingDays ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _degreesController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _workingAtController.dispose();
    _feeController.dispose();
    _biographyController.dispose();
    _languagesController.dispose();
    _consultLimitController.dispose();
    super.dispose();
  }

  void _addWorkingDay() {
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
                setState(() {
                  _workingDays.add(
                    DaySchedule(
                      day: selectedDay,
                      startTime: startTimeController.text.trim(),
                      endTime: endTimeController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_workingDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one working day')),
        );
        return;
      }

      final languages = _languagesController.text
          .trim()
          .split(',')
          .map((e) => e.trim())
          .toList();

      final updatedDoctor = DoctorModel(
        id: doctor.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        degrees: _degreesController.text.trim(),
        specialty: _specialtyController.text.trim(),
        experience: int.parse(_experienceController.text.trim()),
        workingAt: _workingAtController.text.trim(),
        fee: double.parse(_feeController.text.trim()),
        biography: _biographyController.text.trim(),
        languages: languages,
        workingDays: _workingDays,
        consultLimitPerDay: int.parse(_consultLimitController.text),
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
                                      controller: _emailController,
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
                                      controller: _passwordController,
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
                                      controller: _phoneController,
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
                                  SizedBox(width: 20.w),
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
                                ],
                              ),

                              SizedBox(height: 20.h),

                              Row(
                                children: [
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
                                  SizedBox(width: 20.w),
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
                                ],
                              ),

                              SizedBox(height: 20.h),

                              Row(
                                children: [
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
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _consultLimitController,
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
                                      controller: _languagesController,
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
                                          onPressed: _addWorkingDay,
                                          icon: const Icon(Icons.add),
                                          label: const Text('Add Day'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    if (_workingDays.isEmpty)
                                      Text(
                                        'No working days added yet',
                                        style: AppTextStyles.body2.copyWith(
                                          color: Colors.grey,
                                        ),
                                      )
                                    else
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _workingDays.length,
                                        itemBuilder: (context, index) {
                                          final day = _workingDays[index];
                                          return Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${day.day}: ${day.startTime} - ${day.endTime}',
                                                  style: AppTextStyles.body2,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _workingDays.removeAt(
                                                        index,
                                                      );
                                                    });
                                                  },
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
                                      ),
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
