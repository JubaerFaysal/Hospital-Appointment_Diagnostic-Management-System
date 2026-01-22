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

  Map<String, dynamic> toJson({bool includeStatus = false}) {
    final json = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'degrees': degrees,
      'specialty': specialty,
      'experience': experience,
      'working_at': workingAt,
      'fee': fee,
      'biography': biography,
      'consultLimitPerDay': consultLimitPerDay ?? 30,
    };

    // Only include status if explicitly requested (for updates)
    if (includeStatus) {
      json['status'] = status;
    }

    // Only add profilePic if it's not null
    if (profilePic != null) {
      json['profilePic'] = profilePic;
    }

    // Only add languages if it's not null
    if (languages != null) {
      json['languages'] = languages;
    }

    // Only add workingDays if it's not null
    if (workingDays != null) {
      json['workingDays'] = workingDays!.map((d) => d.toJson()).toList();
    }

    // Only add optional fields if they're not null
    if (slots != null) {
      json['slots'] = slots;
    }

    if (availableSlots != null) {
      json['available_slots'] = availableSlots;
    }

    if (suspensionReason != null) {
      json['suspensionReason'] = suspensionReason;
    }

    if (suspendedAt != null) {
      json['suspendedAt'] = suspendedAt!.toIso8601String();
    }

    return json;
  }
}
