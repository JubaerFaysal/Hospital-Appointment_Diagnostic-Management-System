import 'package:get/get.dart';

import '../views/analytics/analytics_screen.dart';
import '../views/analytics/dashboard_screen.dart';
import '../views/appointments_list_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/diagnostic-booking/diagnostic_booking_list_screen.dart';
import '../views/diagnostics/add_diagnostic_screen.dart';
import '../views/diagnostics/diagnostic_list_screen.dart';
import '../views/diagnostics/edit_diagnostic_screen.dart';
import '../views/doctors/add_doctor_screen.dart';
import '../views/doctors/doctor_detail_screen.dart';
import '../views/doctors/doctors_list_screen.dart';
import '../views/doctors/edit_doctor_screen.dart';
import '../views/users/users_list_screen.dart';
import 'admin_routes.dart';

class AdminPages {
  static final routes = [
    GetPage(name: AdminRoutes.LOGIN, page: () => const LoginScreen()),
    GetPage(name: AdminRoutes.DASHBOARD, page: () => const DashboardScreen()),
    GetPage(name: AdminRoutes.DOCTORS, page: () => const DoctorsListScreen()),
    GetPage(name: AdminRoutes.DOCTORS_ADD, page: () => const AddDoctorScreen()),
    GetPage(
      name: AdminRoutes.DOCTORS_EDIT,
      page: () => const EditDoctorScreen(),
    ),
    GetPage(
      name: AdminRoutes.DOCTORS_DETAIL,
      page: () => const DoctorDetailScreen(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTICS,
      page: () => const DiagnosticsListScreen(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTIC_BOOKINGS,
      page: () => const DiagnosticBookingsListScreen(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTICS_ADD,
      page: () => const AddDiagnosticScreen(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTICS_EDIT,
      page: () => const EditDiagnosticScreen(),
    ),
    GetPage(
      name: AdminRoutes.APPOINTMENTS,
      page: () => const AppointmentsListScreen(),
    ),
    GetPage(name: AdminRoutes.USERS, page: () => const UsersListScreen()),
    GetPage(name: AdminRoutes.ANALYTICS, page: () => const AnalyticsScreen()),
  ];
}
