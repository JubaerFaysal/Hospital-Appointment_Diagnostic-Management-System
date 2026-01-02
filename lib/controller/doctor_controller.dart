import 'package:admin_panel_web_app/main.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../config/api_endpoints.dart';
import '../models/doctor_model.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';

class DoctorsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final doctors = <DoctorModel>[].obs;
  final filteredDoctors = <DoctorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      isLoading.value = true;

      // ✅ FIX: Use correct endpoint with timeout safety
      final response = await _apiService
          .get(ApiEndpoints.DOCTORS)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout - took more than 30 seconds');
            },
          );

      if (response.statusCode == 200 && response.data != null) {
        final list = response.data as List;
        doctors.value = list.map((json) => DoctorModel.fromJson(json)).toList();
        filteredDoctors.value = doctors;
        logger.i('✅ Loaded ${doctors.length} doctors successfully');
      } else {
        Helpers.showErrorSnackbar('Error', 'Failed to load doctors');
      }
    } on DioException catch (e) {
      String errorMsg = 'Failed to load doctors';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Server response timeout';
      }
      Helpers.showErrorSnackbar('Error', errorMsg);
    } catch (e) {
      Helpers.showErrorSnackbar('Error', 'Failed to load doctors');
    } finally {
      isLoading.value = false;
      logger.i('✅ Loading state reset to false');
    }
  }

  Future<void> createDoctor(DoctorModel doctor) async {
    try {
      Helpers.showLoadingDialog();

      // ✅ FIX: Use correct endpoint (POST to /admin-auth/doctors)
      final response = await _apiService.post(
        ApiEndpoints.DOCTORS,
        data: doctor.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadDoctors();
        Get.back(); // Close form
        Helpers.showSuccessSnackbar('Success', 'Doctor added successfully');
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to add doctor',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  Future<void> updateDoctor(int id, DoctorModel doctor) async {
    try {
      Helpers.showLoadingDialog();

      // ✅ FIX: Use PATCH method and correct endpoint
      final response = await _apiService.patch(
        ApiEndpoints.doctorById(id),
        data: doctor.toJson(),
      );

      if (response.statusCode == 200) {
        await loadDoctors();
        Get.back(); // Close form
        Helpers.showSuccessSnackbar('Success', 'Doctor updated successfully');
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update doctor',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  Future<void> deleteDoctor(int id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Delete Doctor',
      message: 'Are you sure you want to delete this doctor?',
      confirmText: 'Delete',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      await _apiService.delete(ApiEndpoints.doctorById(id));

      await loadDoctors();
      Get.back();
      Helpers.showSuccessSnackbar('Success', 'Doctor deleted successfully');
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete doctor',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.value = doctors;
    } else {
      filteredDoctors.value = doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
            doctor.specialty.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
