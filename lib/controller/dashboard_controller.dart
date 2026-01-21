import 'package:get/get.dart';
import '../config/api_endpoints.dart';
import '../services/api_services.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final stats = <String, dynamic>{
    'totalDoctors': 0,
    'activeDoctors': 0,
    'totalPatients': 0,
    'totalDiagnosticTests': 0,
    // Appointments
    'totalAppointments': 0,
    'todayAppointments': 0,
    'pendingAppointments': 0,
    'confirmedAppointments': 0,
    'completedAppointments': 0,
    'cancelledAppointments': 0,
    // Diagnostic Bookings
    'totalDiagnosticBookings': 0,
    'todayDiagnosticBookings': 0,
    'pendingDiagnosticBookings': 0,
    'confirmedDiagnosticBookings': 0,
    'completedDiagnosticBookings': 0,
    'cancelledDiagnosticBookings': 0,
    // Revenue
    'totalAppointmentRevenue': 0.0,
    'totalDiagnosticRevenue': 0.0,
  }.obs;

  // Recent data for tables
  final recentAppointments = <Map<String, dynamic>>[].obs;
  final recentDiagnosticBookings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    try {
      isLoading.value = true;

      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // Load doctors
      final doctorsResponse = await _apiService.get(ApiEndpoints.DOCTORS);
      final doctors = doctorsResponse.data as List;
      stats['totalDoctors'] = doctors.length;
      stats['activeDoctors'] = doctors
          .where((d) => d['status'] == 'active')
          .length;

      // Load diagnostics count
      final testsResponse = await _apiService.get(ApiEndpoints.DIAGNOSTICS);
      stats['totalDiagnosticTests'] = (testsResponse.data as List).length;

      // Load users count
      final usersResponse = await _apiService.get(ApiEndpoints.USERS);
      stats['totalPatients'] = (usersResponse.data as List).length;

      // Load appointments with statistics
      final appointmentsResponse = await _apiService.get(
        '${ApiEndpoints.APPOINTMENTS}?limit=1000',
      );
      final appointments =
          appointmentsResponse.data is Map &&
              appointmentsResponse.data.containsKey('data')
          ? appointmentsResponse.data['data'] as List
          : appointmentsResponse.data as List;

      stats['totalAppointments'] = appointments.length;
      stats['pendingAppointments'] = appointments
          .where((a) => a['status'] == 'pending')
          .length;
      stats['confirmedAppointments'] = appointments
          .where((a) => a['status'] == 'confirmed')
          .length;
      stats['completedAppointments'] = appointments
          .where((a) => a['status'] == 'completed')
          .length;
      stats['cancelledAppointments'] = appointments
          .where((a) => a['status'] == 'cancelled')
          .length;

      // Today's appointments
      stats['todayAppointments'] = appointments
          .where(
            (a) =>
                a['date'] != null && a['date'].toString().startsWith(todayStr),
          )
          .length;

      // Calculate appointment revenue (from completed appointments)
      double appointmentRevenue = 0.0;
      for (var apt in appointments) {
        if (apt['status'] == 'completed' && apt['fee'] != null) {
          appointmentRevenue += (apt['fee'] is int)
              ? apt['fee'].toDouble()
              : double.tryParse(apt['fee'].toString()) ?? 0.0;
        }
      }
      stats['totalAppointmentRevenue'] = appointmentRevenue;

      // Store recent appointments (last 5)
      final sortedAppointments = List<Map<String, dynamic>>.from(appointments);
      sortedAppointments.sort(
        (a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''),
      );
      recentAppointments.value = sortedAppointments.take(5).toList();

      // Load diagnostic bookings with statistics
      final bookingsResponse = await _apiService.get(
        '${ApiEndpoints.DIAGNOSTIC_BOOKINGS}?limit=1000',
      );
      final bookings =
          bookingsResponse.data is Map &&
              bookingsResponse.data.containsKey('data')
          ? bookingsResponse.data['data'] as List
          : bookingsResponse.data as List;

      stats['totalDiagnosticBookings'] = bookings.length;
      stats['pendingDiagnosticBookings'] = bookings
          .where((b) => b['status'] == 'pending')
          .length;
      stats['confirmedDiagnosticBookings'] = bookings
          .where((b) => b['status'] == 'confirmed')
          .length;
      stats['completedDiagnosticBookings'] = bookings
          .where((b) => b['status'] == 'completed')
          .length;
      stats['cancelledDiagnosticBookings'] = bookings
          .where((b) => b['status'] == 'cancelled')
          .length;

      // Today's diagnostic bookings
      stats['todayDiagnosticBookings'] = bookings
          .where(
            (b) =>
                b['scheduleDate'] != null &&
                b['scheduleDate'].toString().startsWith(todayStr),
          )
          .length;

      // Calculate diagnostic revenue (from paid bookings)
      double diagnosticRevenue = 0.0;
      for (var booking in bookings) {
        if (booking['isPaid'] == 'paid' && booking['paidAmount'] != null) {
          diagnosticRevenue +=
              double.tryParse(booking['paidAmount'].toString()) ?? 0.0;
        }
      }
      stats['totalDiagnosticRevenue'] = diagnosticRevenue;

      // Store recent bookings (last 5)
      final sortedBookings = List<Map<String, dynamic>>.from(bookings);
      sortedBookings.sort(
        (a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''),
      );
      recentDiagnosticBookings.value = sortedBookings.take(5).toList();

      // Trigger UI update
      stats.refresh();
    } catch (e) {
      print('Error loading dashboard stats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Getters for easy access
  double get totalRevenue =>
      (stats['totalAppointmentRevenue'] as double) +
      (stats['totalDiagnosticRevenue'] as double);
}
