import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../config/api_endpoints.dart';
import '../models/diagnostic_booking_model.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';

class DiagnosticBookingsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final bookings = <DiagnosticBookingModel>[].obs;
  final filteredBookings = <DiagnosticBookingModel>[].obs;
  final selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      isLoading.value = true;

      // Using the correct endpoint for diagnostic bookings
      final response = await _apiService.get(ApiEndpoints.DIAGNOSTIC_BOOKINGS);

      if (response.data != null) {
        // Check if response has pagination structure
        final data = response.data is Map && response.data.containsKey('data')
            ? response.data['data']
            : response.data;

        bookings.value = (data as List)
            .map((json) => DiagnosticBookingModel.fromJson(json))
            .toList();

        // Sort by created date (newest first)
        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        filterByStatus(selectedStatus.value);
      }
    } catch (e) {
      print('Error loading bookings: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load diagnostic bookings');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    if (status == 'all') {
      filteredBookings.value = bookings;
    } else {
      filteredBookings.value = bookings
          .where((booking) => booking.status.toLowerCase() == status.toLowerCase())
          .toList();
    }
  }

  void searchBookings(String query) {
    if (query.isEmpty) {
      filterByStatus(selectedStatus.value);
    } else {
      filteredBookings.value = bookings.where((booking) {
        return booking.patientName.toLowerCase().contains(query.toLowerCase()) ||
            booking.diagnosticName.toLowerCase().contains(query.toLowerCase()) ||
            booking.patientPhone.contains(query);
      }).toList();
    }
  }

  Future<void> updateBookingStatus(int id, String newStatus) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Update Status',
      message: 'Are you sure you want to change status to ${newStatus.toUpperCase()}?',
      confirmText: 'Update',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.patch(
        ApiEndpoints.diagnosticBookingById(id),
        data: {'status': newStatus},
      );

      if (response.statusCode == 200) {
        await loadBookings();
        Helpers.showSuccessSnackbar('Success', 'Booking status updated');
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

  Future<void> cancelBooking(int id, String reason) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.post(
        ApiEndpoints.diagnosticBookingCancel(id),
        data: {'reason': reason},
      );

      if (response.statusCode == 200) {
        await loadBookings();
        Get.back(); // Close dialog
        Helpers.showSuccessSnackbar('Success', 'Booking cancelled successfully');
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to cancel booking',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  Future<void> deleteBooking(int id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Delete Booking',
      message: 'Are you sure you want to delete this booking?',
      confirmText: 'Delete',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      await _apiService.delete(ApiEndpoints.diagnosticBookingById(id));

      await loadBookings();
      Helpers.showSuccessSnackbar('Success', 'Booking deleted successfully');
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete booking',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  Future<void> bulkUpdateStatus(List<int> ids, String status) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Bulk Update',
      message: 'Update ${ids.length} bookings to ${status.toUpperCase()}?',
      confirmText: 'Update All',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.post(
        ApiEndpoints.DIAGNOSTIC_BOOKINGS_BULK_STATUS,
        data: {
          'ids': ids,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        await loadBookings();
        Helpers.showSuccessSnackbar(
          'Success',
          '${ids.length} bookings updated successfully',
        );
      }
    } on DioException catch (e) {
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to bulk update',
      );
    } finally {
      Helpers.hideLoadingDialog();
    }
  }

  // Get statistics
  int get totalBookings => bookings.length;
  int get pendingCount => bookings.where((b) => b.status == 'pending').length;
  int get confirmedCount => bookings.where((b) => b.status == 'confirmed').length;
  int get completedCount => bookings.where((b) => b.status == 'completed').length;
  int get cancelledCount => bookings.where((b) => b.status == 'cancelled').length;
}