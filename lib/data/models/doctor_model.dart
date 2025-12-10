class DoctorModel {
  final int? id;
  final String name;
  final String degrees;
  final String specialty;
  final int experience;
  final String workingAt;
  final double fee;
  final String? profilePic;
  final String biography;
  final List<String>? languages;
  final Map<String, String>? slots;

  DoctorModel({
    this.id,
    required this.name,
    required this.degrees,
    required this.specialty,
    required this.experience,
    required this.workingAt,
    required this.fee,
    this.profilePic,
    required this.biography,
    this.languages,
    this.slots,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'degrees': degrees,
      'specialty': specialty,
      'experience': experience,
      'working_at': workingAt,
      'fee': fee,
      'profilePic': profilePic,
      'biography': biography,
      'languages': languages,
      'slots': slots,
    };
  }
}