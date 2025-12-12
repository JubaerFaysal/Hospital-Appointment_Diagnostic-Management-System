class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? profilePhoto;
  final bool isActive;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePhoto,
    required this.isActive,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? json['fullName'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'] ?? 'patient',
      profilePhoto: json['profile_photo'] ?? json['profilePhoto'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'profile_photo': profilePhoto,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}