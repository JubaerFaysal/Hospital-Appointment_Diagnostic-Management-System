import 'package:get/get.dart';

import '../bindings/analytics_binding.dart';
import '../bindings/appointments_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/diagnostic_booking_binding.dart';
import '../bindings/diagnostics_binding.dart';
import '../bindings/doctor_bindings.dart';
import '../bindings/users_binding.dart';
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
    GetPage(
      name: AdminRoutes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AdminRoutes.DOCTORS,
      page: () => const DoctorsListScreen(),
      binding: DoctorsBinding(),
    ),
    GetPage(name: AdminRoutes.DOCTORS_ADD, page: () => const AddDoctorScreen()),
    GetPage(
      name: AdminRoutes.DOCTORS_EDIT,
      page: () => EditDoctorScreen(),
    ),
    GetPage(
      name: AdminRoutes.DOCTORS_DETAIL,
      page: () => const DoctorDetailScreen(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTICS,
      page: () => const DiagnosticsListScreen(),
      binding: DiagnosticsBinding(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTIC_BOOKINGS,
      page: () => const DiagnosticBookingsListScreen(),
      binding: DiagnosticBookingBinding(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTICS_ADD,
      page: () => const AddDiagnosticScreen(),
    ),
    GetPage(
      name: AdminRoutes.DIAGNOSTICS_EDIT,
      page: () => EditDiagnosticScreen(),
    ),
    GetPage(
      name: AdminRoutes.APPOINTMENTS,
      page: () => const AppointmentsListScreen(),
      binding: AppointmentsBinding(),
    ),
    GetPage(
      name: AdminRoutes.USERS,
      page: () => const UsersListScreen(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: AdminRoutes.ANALYTICS,
      page: () => const AnalyticsScreen(),
      binding: AnalyticsBinding(),
    ),
  ];
}
