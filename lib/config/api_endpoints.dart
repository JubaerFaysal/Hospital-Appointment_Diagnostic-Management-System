class ApiEndpoints {
  // Authentication
  static const String LOGIN = '/admin-auth/login';
  static const String CREATE_ADMIN = '/admin-auth/create';
  static const String ALL_ADMINS = '/admin-auth/all-admin';

  // Doctors
  static const String DOCTORS = '/admin-auth/doctors';
  static String doctorById(int id) => '/admin-auth/doctors/$id';
  static String doctorAppointments(int id) =>
      '/admin-auth/doctors/$id/appointments';
  static const String DOCTORS_WITH_APPOINTMENTS =
      '/admin-auth/doctors-with-appointments';

  // Diagnostics
  static const String DIAGNOSTICS = '/admin-auth/diagnostics';
  static String diagnosticById(int id) => '/admin-auth/diagnostics/$id';
  static String diagnosticStatus(int id) =>
      '/admin-auth/diagnostics/$id/status';
  static const String DIAGNOSTICS_IMPORT = '/admin-auth/diagnostics/import';
  static const String DIAGNOSTICS_EXPORT = '/admin-auth/diagnostics/export';

  // Appointments
  static const String APPOINTMENTS = '/admin-auth/appointments';
  static String appointmentById(int id) => '/admin-auth/appointments/$id';
  static String appointmentStatus(int id) =>
      '/admin-auth/appointments/$id/status';
  static String appointmentCancel(int id) =>
      '/admin-auth/appointments/$id/cancel';
  static String appointmentReassign(int id) =>
      '/admin-auth/appointments/$id/reassign';
  static const String APPOINTMENTS_BULK_STATUS =
      '/admin-auth/appointments/bulk-status';

  // Diagnostic Bookings
  static const String DIAGNOSTIC_BOOKINGS = '/admin-auth/diagnostic-bookings';
  static String diagnosticBookingById(int id) =>
      '/admin-auth/diagnostic-bookings/$id';
  static String diagnosticBookingCancel(int id) =>
      '/admin-auth/diagnostic-bookings/$id/cancel';
  static const String DIAGNOSTIC_BOOKINGS_BULK_STATUS =
      '/admin-auth/diagnostic-bookings/bulk-status';

  // Users
  static const String USERS = '/admin-auth/users';
  static String userById(int id) => '/admin-auth/users/$id';

  // Role Management
  static String assignRole(int adminId) =>
      '/admin-auth/admins/$adminId/assign-role';
  static String adminRole(int adminId) => '/admin-auth/admins/$adminId/role';
  static const String ADMINS_WITH_ROLES = '/admin-auth/admins-with-roles';
  static const String ALL_ROLES = '/admin-auth/roles';
  static String rolePermissions(String role) =>
      '/admin-auth/roles/$role/permissions';
}
