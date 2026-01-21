import 'package:admin_panel_web_app/main.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../config/api_endpoints.dart';
import '../models/appointment_model.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';

class AppointmentsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final appointments = <AppointmentModel>[].obs;
  final filteredAppointments = <AppointmentModel>[].obs;
  final selectedStatus = 'all'.obs;
  final currentPage = 1.obs;
  final pageLimit = 100.obs;
  final totalAppointmentsCount = 0.obs;

  final List<String> statusFilters = [
    'all',
    'pending',
    'confirmed',
    'completed',
    'rejected',
    'cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;

      final queryParams = {
        'page': currentPage.value,
        'limit': pageLimit.value,
        if (selectedStatus.value != 'all') 'status': selectedStatus.value,
      };

      logger.i('📋 Loading appointments with params: $queryParams');

      final response = await _apiService.get(
        ApiEndpoints.APPOINTMENTS,
        queryParameters: queryParams,
      );

      logger.i('✅ API Response Status: ${response.statusCode}');
      logger.i('📊 API Response Data: ${response.data}');

      if (response.data != null) {
        final data = response.data is Map && response.data.containsKey('data')
            ? response.data['data']
            : response.data;

        logger.i('📁 Extracted data: $data');

        appointments.value = (data as List)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        logger.i('✨ Parsed ${appointments.length} appointments');

        if (response.data is Map && response.data.containsKey('total')) {
          totalAppointmentsCount.value = response.data['total'];
        }

        appointments.sort((a, b) => b.date.compareTo(a.date));
        filteredAppointments.value = appointments;
      }
    } catch (e) {
      logger.e('❌ Error loading appointments: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load appointments');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    loadAppointments();
  }

  void searchAppointments(String query) {
    if (query.isEmpty) {
      filterByStatus(selectedStatus.value);
    } else {
      filteredAppointments.value = appointments.where((apt) {
        return apt.patientName.toLowerCase().contains(query.toLowerCase()) ||
            apt.doctorName.toLowerCase().contains(query.toLowerCase()) ||
            apt.patientPhone.contains(query);
      }).toList();
    }
  }

  Future<void> updateAppointmentStatus(int id, String newStatus) async {
    if (!['pending', 'confirmed', 'completed', 'rejected', 'cancelled'].contains(newStatus)) {
      Helpers.showErrorSnackbar('Error', 'Invalid status: $newStatus');
      return;
    }

    final confirmed = await Helpers.showConfirmDialog(
      title: 'Update Status',
      message: 'Are you sure you want to change status to ${newStatus.toUpperCase()}?',
      confirmText: 'Update',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.patch(
        ApiEndpoints.appointmentById(id),
        data: {'status': newStatus},
      );

      if (response.statusCode == 200) {
        await loadAppointments();
        Helpers.showSuccessSnackbar('Success', 'Appointment status updated to $newStatus');
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update status',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  Future<void> cancelAppointment(int id, String reason) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.post(
        ApiEndpoints.appointmentCancel(id),
        data: {'reason': reason},
      );

      if (response.statusCode == 200) {
        await loadAppointments();
        Helpers.showSuccessSnackbar('Success', 'Appointment cancelled');
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to cancel appointment',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  Future<void> deleteAppointment(int id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Delete Appointment',
      message: 'Are you sure you want to delete this appointment?',
      confirmText: 'Delete',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      await _apiService.delete(ApiEndpoints.appointmentById(id));

      await loadAppointments();
      Helpers.showSuccessSnackbar('Success', 'Appointment deleted successfully');
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete appointment',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  int get totalAppointments => appointments.length;
  int get pendingCount => appointments.where((a) => a.status == 'pending').length;
  int get confirmedCount => appointments.where((a) => a.status == 'confirmed').length;
  int get completedCount => appointments.where((a) => a.status == 'completed').length;
  int get rejectedCount => appointments.where((a) => a.status == 'rejected').length;
  int get cancelledCount => appointments.where((a) => a.status == 'cancelled').length;
}