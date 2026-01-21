class AppointmentModel {
  final int id;
  final int doctorId;
  final int patientId;
  final String doctorName;
  final String doctorSpecialty;
  final String patientName;
  final String patientPhone;
  final String date;
  final String timeSlot;
  final String status;
  final double? fee;
  final String? rejectionReason;
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
    required this.timeSlot,
    required this.status,
    this.fee,
    this.rejectionReason,
    this.cancellationReason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctorId: json['doctor']?['id'] ?? json['doctorId'] ?? 0,
      patientId: json['patient']?['id'] ?? json['patientId'] ?? 0,
      doctorName: json['doctor']?['name'] ?? 'Unknown Doctor',
      doctorSpecialty: json['doctor']?['specialty'] ?? 'General',
      patientName: json['patient']?['name'] ?? 'Unknown Patient',
      patientPhone: json['patient']?['phone'] ?? 'N/A',
      date: json['date'] ?? '',
      timeSlot: json['time_slot'] ?? json['timeSlot'] ?? '',
      status: json['status'] ?? 'pending',
      fee: json['doctor']?['fee']?.toDouble(),
      rejectionReason: json['rejectionReason'],
      cancellationReason: json['cancellationReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'date': date,
      'time_slot': timeSlot,
      'status': status,
    };
  }

  // Helper method to check if appointment can be modified
  bool get canBeModified => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isRejected => status == 'rejected';
}