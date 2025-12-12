import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../data/models/appointment_model.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';


class AppointmentsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final appointments = <AppointmentModel>[].obs;
  final filteredAppointments = <AppointmentModel>[].obs;
  final selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/appointments');

      if (response.data != null) {
        appointments.value = (response.data as List)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        // Sort by date (newest first)
        appointments.sort((a, b) => b.date.compareTo(a.date));

        filterByStatus(selectedStatus.value);
      }
    } catch (e) {
      print('Error loading appointments: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load appointments');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    if (status == 'all') {
      filteredAppointments.value = appointments;
    } else {
      filteredAppointments.value = appointments
          .where((apt) => apt.status.toLowerCase() == status.toLowerCase())
          .toList();
    }
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
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Update Status',
      message: 'Are you sure you want to change status to ${newStatus.toUpperCase()}?',
      confirmText: 'Update',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      // TODO: Update this endpoint based on your backend API
      final response = await _apiService.put(
        '/appointments/$id',
        data: {'status': newStatus},
      );

      Helpers.hideLoadingDialog();

      if (response.statusCode == 200) {
        await loadAppointments();
        Helpers.showSuccessSnackbar('Success', 'Appointment status updated');
      }
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update status',
      );
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

      await _apiService.delete('/appointments/$id');

      Helpers.hideLoadingDialog();
      await loadAppointments();
      Helpers.showSuccessSnackbar('Success', 'Appointment deleted successfully');
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete appointment',
      );
    }
  }

  // Get statistics
  int get totalAppointments => appointments.length;
  int get pendingCount => appointments.where((a) => a.status == 'pending').length;
  int get approvedCount => appointments.where((a) => a.status == 'approved').length;
  int get completedCount => appointments.where((a) => a.status == 'completed').length;
  int get rejectedCount => appointments.where((a) => a.status == 'rejected').length;
}