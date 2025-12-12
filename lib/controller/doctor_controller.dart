import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../data/models/doctor_model.dart';
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
      final response = await _apiService.get('/doctors');

      if (response.data != null) {
        doctors.value = (response.data as List)
            .map((json) => DoctorModel.fromJson(json))
            .toList();
        filteredDoctors.value = doctors;
      }
    } catch (e) {
      print('Error loading doctors: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load doctors');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDoctor(DoctorModel doctor) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.post(
        '/doctors',
        data: doctor.toJson(),
      );

      Helpers.hideLoadingDialog();

      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadDoctors();
        Get.back();
        Helpers.showSuccessSnackbar('Success', 'Doctor added successfully');
      }
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to add doctor',
      );
    }
  }

  Future<void> updateDoctor(int id, DoctorModel doctor) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.put(
        '/doctors/$id',
        data: doctor.toJson(),
      );

      Helpers.hideLoadingDialog();

      if (response.statusCode == 200) {
        await loadDoctors();
        Get.back();
        Helpers.showSuccessSnackbar('Success', 'Doctor updated successfully');
      }
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update doctor',
      );
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
      await _apiService.delete('/doctors/$id');
      Helpers.hideLoadingDialog();
      await loadDoctors();
      Helpers.showSuccessSnackbar('Success', 'Doctor deleted successfully');
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete doctor',
      );
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