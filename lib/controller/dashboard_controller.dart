import 'package:get/get.dart';
import '../config/api_endpoints.dart';
import '../services/api_services.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final stats = <String, dynamic>{
    'totalDoctors': 0,
    'totalPatients': 0,
    'todayAppointments': 0,
    'totalTests': 0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    try {
      isLoading.value = true;

      // ✅ FIX: Use correct endpoints
      // Load doctors count
      final doctorsResponse = await _apiService.get(ApiEndpoints.DOCTORS);
      stats['totalDoctors'] = (doctorsResponse.data as List).length;

      // Load diagnostics count
      final testsResponse = await _apiService.get(ApiEndpoints.DIAGNOSTICS);
      stats['totalTests'] = (testsResponse.data as List).length;

      // ✅ FIX: Load real users count
      final usersResponse = await _apiService.get(ApiEndpoints.USERS);
      stats['totalPatients'] = (usersResponse.data as List).length;

      // ✅ FIX: Load real appointments and count today's
      final appointmentsResponse = await _apiService.get(ApiEndpoints.APPOINTMENTS);
      final appointments = appointmentsResponse.data is Map &&
          appointmentsResponse.data.containsKey('data')
          ? appointmentsResponse.data['data']
          : appointmentsResponse.data;

      // Count today's appointments
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      int todayCount = 0;
      for (var apt in appointments as List) {
        if (apt['date'] != null && apt['date'].toString().startsWith(todayStr)) {
          todayCount++;
        }
      }
      stats['todayAppointments'] = todayCount;

    } catch (e) {
      print('Error loading dashboard stats: $e');
      // Keep default values on error
    } finally {
      isLoading.value = false;
    }
  }
}