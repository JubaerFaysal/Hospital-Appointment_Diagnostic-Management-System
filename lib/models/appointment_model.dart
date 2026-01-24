class AppointmentModel {
  final int id;
  final int doctorId;
  final int patientId;
  final String doctorName;
  final String doctorSpecialty;
  final String patientName;
  final String patientPhone;
  final String patientEmail;
  final String date;
  final String status;
  final int? serialNumber;
  final double? fee;
  final String? cancellationReason;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.patientName,
    required this.patientPhone,
    required this.date,
    required this.status,
    required this.patientEmail,
    this.serialNumber,
    this.fee,
    this.cancellationReason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctorId: json['doctor']?['id'] ??  0,
      doctorName: json['doctor']?['name'] ?? 'Unknown Doctor',
      doctorSpecialty: json['doctor']?['specialty'] ?? 'General',
      patientId: json['patient']?['id'] ??  0,
      patientName: json['patient']?['name'] ?? 'Unknown Patient',
      patientPhone: json['patient']?['phone'] ?? 'N/A',
      patientEmail: json['patient']?['email'] ?? 'N/A',
      date: json['date'] ?? '',
      status: json['status'] ?? 'pending',
      serialNumber: json['serialNumber'],
      fee: json['doctor']?['fee']?.toDouble(),
      cancellationReason: json['cancellationReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'date': date,
      'status': status,
    };
  }

  // Helper method to check if appointment can be modified
  bool get canBeModified => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}
