// Interface for day schedule configuration
class DaySchedule {
  final String day;
  final String startTime;
  final String endTime;

  DaySchedule({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'startTime': startTime, 'endTime': endTime};
  }
}

class DoctorModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String degrees;
  final String specialty;
  final int experience;
  final String workingAt;
  final double fee;
  final String? profilePic;
  final String biography;
  final List<String>? languages;
  final Map<String, String>? slots;
  final int? availableSlots;
  final List<DaySchedule>? workingDays;
  final int? consultLimitPerDay;
  final String status; // 'active', 'inactive', 'suspended'
  final String? suspensionReason;
  final DateTime? suspendedAt;
  final int? appointmentsCount;

  DoctorModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    required this.degrees,
    required this.specialty,
    required this.experience,
    required this.workingAt,
    required this.fee,
    this.profilePic,
    required this.biography,
    this.languages,
    this.slots,
    this.availableSlots,
    this.workingDays,
    this.consultLimitPerDay,
    this.status = 'active',
    this.suspensionReason,
    this.suspendedAt,
    this.appointmentsCount,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'] ?? '',
      phone: json['phone'],
      degrees: json['degrees'],
      specialty: json['specialty'],
      experience: json['experience'],
      workingAt: json['working_at'],
      fee: (json['fee'] as num).toDouble(),
      profilePic: json['profilePic'],
      biography: json['biography'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      slots: json['slots'] != null
          ? Map<String, String>.from(json['slots'])
          : null,
      availableSlots: json['available_slots'],
      workingDays: json['workingDays'] != null
          ? (json['workingDays'] as List)
                .map((item) => DaySchedule.fromJson(item))
                .toList()
          : null,
      consultLimitPerDay: json['consultLimitPerDay'] ?? 30,
      status: json['status'] ?? 'active',
      suspensionReason: json['suspensionReason'],
      suspendedAt: json['suspendedAt'] != null
          ? DateTime.parse(json['suspendedAt'])
          : null,
      appointmentsCount: json['appointmentsCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'degrees': degrees,
      'specialty': specialty,
      'experience': experience,
      'working_at': workingAt,
      'fee': fee,
      'profilePic': profilePic,
      'biography': biography,
      'languages': languages,
      'slots': slots,
      'available_slots': availableSlots,
      'workingDays': workingDays?.map((d) => d.toJson()).toList(),
      'consultLimitPerDay': consultLimitPerDay ?? 30,
      'status': status,
      if (suspensionReason != null) 'suspensionReason': suspensionReason,
      if (suspendedAt != null) 'suspendedAt': suspendedAt!.toIso8601String(),
    };
  }
}
