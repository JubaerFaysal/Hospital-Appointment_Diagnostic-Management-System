import 'package:admin_panel_web_app/views/analytics/dashboard_screen.dart';
import 'package:admin_panel_web_app/views/auth/login_screen.dart';
import 'package:get/get.dart';
import '../views/appointments_list_screen.dart';
import '../views/diagnostics/diagnostic_list_screen.dart';
import '../views/doctors/doctors_list_screen.dart';
import '../views/doctors/add_doctor_screen.dart';
import '../views/doctors/edit_doctor_screen.dart';
import '../views/diagnostics/add_diagnostic_screen.dart';
import '../views/diagnostics/edit_diagnostic_screen.dart';
import '../views/users/users_list_screen.dart';
import '../views/analytics/analytics_screen.dart';
import 'admin_routes.dart';

class AdminPages {
  static final routes = [
    // Auth
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
    ),

    // Dashboard
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardScreen(),
    ),

    // Doctors
    GetPage(
      name: AppRoutes.DOCTORS,
      page: () => const DoctorsListScreen(),
    ),
    GetPage(
      name: AppRoutes.DIAGNOSTICS_ADD,
      page: () => const AddDoctorScreen(),
    ),
    GetPage(
      name: AppRoutes.DOCTORS_EDIT,
      page: () => const EditDoctorScreen(),
    ),

    // Diagnostics
    GetPage(
      name: AppRoutes.DIAGNOSTICS,
      page: () => const DiagnosticsListScreen(),
    ),
    GetPage(
      name: AppRoutes.DIAGNOSTICS_ADD,
      page: () => const AddDiagnosticScreen(),
    ),
    GetPage(
      name: AppRoutes.DIAGNOSTICS_EDIT,
      page: () => const EditDiagnosticScreen(),
    ),

    // Appointments
    GetPage(
      name: AppRoutes.APPOINTMENTS,
      page: () => const AppointmentsListScreen(),
    ),

    // Users
    GetPage(
      name: AppRoutes.USERS,
      page: () => const UsersListScreen(),
    ),

    // Analytics
    GetPage(
      name: AppRoutes.ANALYTICS,
      page: () => const AnalyticsScreen(),
    ),
  ];
}