import 'package:get/get.dart';
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

      // Load doctors count
      final doctorsResponse = await _apiService.get('/doctors');
      stats['totalDoctors'] = (doctorsResponse.data as List).length;

      // Load diagnostics count
      final testsResponse = await _apiService.get('/diagnostics');
      stats['totalTests'] = (testsResponse.data as List).length;

      // Mock data for others
      stats['totalPatients'] = 150;
      stats['todayAppointments'] = 23;

    } catch (e) {
      print('Error loading dashboard stats: $e');
    } finally {
      isLoading.value = false;
    }
  }
}