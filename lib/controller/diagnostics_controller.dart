import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../data/models/diagnostic_model.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';

class DiagnosticsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final diagnostics = <DiagnosticModel>[].obs;
  final filteredDiagnostics = <DiagnosticModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDiagnostics();
  }

  Future<void> loadDiagnostics() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/diagnostics');

      if (response.data != null) {
        diagnostics.value = (response.data as List)
            .map((json) => DiagnosticModel.fromJson(json))
            .toList();
        filteredDiagnostics.value = diagnostics;
      }
    } catch (e) {
      print('Error loading diagnostics: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load diagnostic tests');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDiagnostic(DiagnosticModel diagnostic) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.post(
        '/diagnostics/create',
        data: diagnostic.toJson(),
      );

      Helpers.hideLoadingDialog();

      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadDiagnostics();
        Get.back();
        Helpers.showSuccessSnackbar('Success', 'Test added successfully');
      }
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to add test',
      );
    }
  }

  Future<void> updateDiagnostic(int id, DiagnosticModel diagnostic) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.put(
        '/diagnostics/$id',
        data: diagnostic.toJson(),
      );

      Helpers.hideLoadingDialog();

      if (response.statusCode == 200) {
        await loadDiagnostics();
        Get.back();
        Helpers.showSuccessSnackbar('Success', 'Test updated successfully');
      }
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update test',
      );
    }
  }

  Future<void> deleteDiagnostic(int id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Delete Test',
      message: 'Are you sure you want to delete this diagnostic test?',
      confirmText: 'Delete',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();
      await _apiService.delete('/diagnostics/$id');
      Helpers.hideLoadingDialog();
      await loadDiagnostics();
      Helpers.showSuccessSnackbar('Success', 'Test deleted successfully');
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete test',
      );
    }
  }

  void searchDiagnostics(String query) {
    if (query.isEmpty) {
      filteredDiagnostics.value = diagnostics;
    } else {
      filteredDiagnostics.value = diagnostics.where((test) {
        return test.testName.toLowerCase().contains(query.toLowerCase()) ||
            test.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}