class DiagnosticBookingModel {
  final int id;
  final int diagnosticId;
  final int patientId;
  final String diagnosticName;
  final String diagnosticCategory;
  final String patientName;
  final String patientPhone;
  final String scheduleDate;
  final String status;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DiagnosticBookingModel({
    required this.id,
    required this.diagnosticId,
    required this.patientId,
    required this.diagnosticName,
    required this.diagnosticCategory,
    required this.patientName,
    required this.patientPhone,
    required this.scheduleDate,
    required this.status,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    this.updatedAt,
  });

  factory DiagnosticBookingModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticBookingModel(
      id: json['id'],
      diagnosticId: json['diagnosticId'] ?? json['diagnostic']?['id'] ?? 0,
      patientId: json['patientId'] ?? json['patient']?['id'] ?? 0,
      diagnosticName: json['diagnostic']?['test_name'] ?? 'Unknown Test',
      diagnosticCategory: json['diagnostic']?['category'] ?? 'General',
      patientName: json['patient']?['name'] ?? 'Unknown Patient',
      patientPhone: json['patient']?['phone'] ?? 'N/A',
      scheduleDate: json['scheduleDate'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      cancellationReason: json['cancellationReason'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagnosticId': diagnosticId,
      'patientId': patientId,
      'scheduleDate': scheduleDate,
      'status': status,
      'notes': notes,
    };
  }
}