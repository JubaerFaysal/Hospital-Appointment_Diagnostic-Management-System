class AdminModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role; // ✅ Added role field

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'] ?? 'admin', // ✅ Default to 'admin' if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  // ✅ Helper methods for role checking
  bool get isSuperAdmin => role == 'super_admin';
  bool get isAdmin => role == 'admin';
  bool get isManager => role == 'manager';
  bool get isViewer => role == 'viewer';

  // ✅ Permission helpers
  bool get canManageAdmins => isSuperAdmin;
  bool get canDelete => isSuperAdmin || isAdmin;
  bool get canCreate => isSuperAdmin || isAdmin || isManager;
  bool get canUpdate => !isViewer;
  bool get canRead => true; // All roles can read
}
