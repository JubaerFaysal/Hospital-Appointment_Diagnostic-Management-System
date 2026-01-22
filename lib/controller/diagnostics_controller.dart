import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/api_endpoints.dart';
import '../models/diagnostic_model.dart';
import '../services/api_services.dart';
import '../services/image_picker_service.dart';
import '../utils/helpers.dart';

class DiagnosticsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final imagePickerService = ImagePickerService();

  final isLoading = false.obs;
  final diagnostics = <DiagnosticModel>[].obs;
  final filteredDiagnostics = <DiagnosticModel>[].obs;

  // Add/Edit Diagnostic Form Controllers
  final testNameController = TextEditingController();
  final categoryController = TextEditingController();
  final departmentController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final preparationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadDiagnostics();
  }

  @override
  void onClose() {
    testNameController.dispose();
    categoryController.dispose();
    departmentController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    preparationController.dispose();
    super.onClose();
  }

  void clearForm() {
    testNameController.clear();
    categoryController.clear();
    departmentController.clear();
    priceController.clear();
    descriptionController.clear();
    preparationController.clear();
    imagePickerService.clearImage();
  }

  Future<void> loadDiagnostics() async {
    try {
      isLoading.value = true;

      // ✅ FIX: Use correct endpoint
      final response = await _apiService.get(ApiEndpoints.DIAGNOSTICS);

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
      // Helpers.showLoadingDialog();

      // Upload image to Cloudinary if selected
      String? imageUrl;
      if (imagePickerService.selectedImage.value != null) {
        imageUrl = await imagePickerService.uploadImageToCloudinary();
        if (imageUrl == null) {
          // Helpers.hideLoadingDialog();
          Helpers.showErrorSnackbar(
            'Error',
            'Failed to upload diagnostic image',
          );
          return;
        }
      }

      // Prepare diagnostic data
      final diagnosticData = {
        'test_name': diagnostic.testName,
        'category': diagnostic.category,
        'department': diagnostic.department,
        'price': diagnostic.price,
        if (diagnostic.description != null)
          'description': diagnostic.description,
        if (diagnostic.preparation != null)
          'preparation': diagnostic.preparation,
        if (imageUrl != null) 'image': imageUrl,
      };
      // Helpers.showLoadingDialog();

      final response = await _apiService.post(
        ApiEndpoints.DIAGNOSTICS,
        data: diagnosticData,
      );
      // Helpers.hideLoadingDialog();

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Helpers.hideLoadingDialog();
        clearForm(); // Clear form before navigating back
        Get.back(); // Close form
        Get.back(); // Close form
        Helpers.showSuccessSnackbar('Success', 'Test added successfully');
        await loadDiagnostics(); // Reload in background
      }
    } on DioException catch (e) {
      // Helpers.hideLoadingDialog();
      final errorMessage = e.response?.data is Map
          ? (e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to add test')
          : 'Failed to add test';
      Helpers.showErrorSnackbar('Error', errorMessage);
    } catch (e) {
      // Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> updateDiagnostic(int id, DiagnosticModel diagnostic) async {
    try {
      Helpers.showLoadingDialog();

      // ✅ FIX: Use PATCH method and correct endpoint
      final response = await _apiService.patch(
        ApiEndpoints.diagnosticById(id),
        data: diagnostic.toJson(),
      );

      if (response.statusCode == 200) {
        await loadDiagnostics();
        Get.back(); // Close form
        Helpers.showSuccessSnackbar('Success', 'Test updated successfully');
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update test',
      );
    } finally {
      Helpers.hideLoadingDialog();
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

      await _apiService.delete(ApiEndpoints.diagnosticById(id));

      await loadDiagnostics();
      Get.back();
      Helpers.showSuccessSnackbar('Success', 'Test deleted successfully');
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete test',
      );
    } finally {
      Helpers.hideLoadingDialog();
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
