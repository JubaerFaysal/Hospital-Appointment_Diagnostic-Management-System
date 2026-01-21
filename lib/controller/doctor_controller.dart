import 'package:admin_panel_web_app/main.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../config/api_endpoints.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';

class DoctorsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final doctors = <DoctorModel>[].obs;
  final filteredDoctors = <DoctorModel>[].obs;
  final doctorAppointments = <AppointmentModel>[].obs;
  final doctorsWithAppointments = <DoctorModel>[].obs;
  final isLoadingAppointments = false.obs;
  final isLoadingDoctorsWithAppointments = false.obs;

  // Filter properties
  final selectedSpecialties = <String>[].obs;
  final minExperience = 0.obs;
  final maxExperience = 50.obs;
  final minFee = 0.0.obs;
  final maxFee = 10000.0.obs;
  final selectedStatuses = <String>['active'].obs;
  final availableSpecialties = <String>[].obs;
  final sortBy = 'name'.obs; // name, experience, fee, status
  final sortAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      isLoading.value = true;

      // ✅ Use DOCTORS_WITH_APPOINTMENTS endpoint to get appointment counts
      final response = await _apiService
          .get(ApiEndpoints.DOCTORS_WITH_APPOINTMENTS)
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

    // Extract specialties for filter dropdown
    extractSpecialties();
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

  /// Fetch appointments for a specific doctor
  Future<void> getDoctorAppointments(int doctorId) async {
    try {
      isLoadingAppointments.value = true;
      doctorAppointments.clear();

      logger.i('📋 Fetching appointments for doctor ID: $doctorId');

      final response = await _apiService.get(
        ApiEndpoints.doctorAppointments(doctorId),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map && response.data.containsKey('data')
            ? response.data['data']
            : response.data;

        doctorAppointments.value = (data as List)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        // Sort by date (most recent first)
        doctorAppointments.sort((a, b) => b.date.compareTo(a.date));

        logger.i(
          '✅ Loaded ${doctorAppointments.length} appointments for doctor $doctorId',
        );
      }
    } catch (e) {
      logger.e('❌ Error loading doctor appointments: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load doctor appointments');
    } finally {
      isLoadingAppointments.value = false;
    }
  }

  /// Fetch all doctors who have appointments
  Future<void> loadDoctorsWithAppointments() async {
    try {
      isLoadingDoctorsWithAppointments.value = true;

      logger.i('📋 Loading doctors with appointments');

      final response = await _apiService.get(
        ApiEndpoints.DOCTORS_WITH_APPOINTMENTS,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map && response.data.containsKey('data')
            ? response.data['data']
            : response.data;

        // Filter to only include doctors with appointments (appointmentsCount > 0)
        doctorsWithAppointments.value = (data as List)
            .map((json) => DoctorModel.fromJson(json))
            .where((doctor) => (doctor.appointmentsCount ?? 0) > 0)
            .toList();

        logger.i(
          '✅ Loaded ${doctorsWithAppointments.length} doctors with appointments',
        );
      }
    } catch (e) {
      logger.e('❌ Error loading doctors with appointments: $e');
      Helpers.showErrorSnackbar(
        'Error',
        'Failed to load doctors with appointments',
      );
    } finally {
      isLoadingDoctorsWithAppointments.value = false;
    }
  }

  // Computed properties for appointment statistics
  int getAppointmentCount(String status) {
    return doctorAppointments.where((apt) => apt.status == status).length;
  }

  int get totalAppointments => doctorAppointments.length;
  int get pendingAppointments => getAppointmentCount('pending');
  int get confirmedAppointments => getAppointmentCount('confirmed');
  int get completedAppointments => getAppointmentCount('completed');
  int get cancelledAppointments => getAppointmentCount('cancelled');

  /// Apply all filters and sorting
  void applyFilters() {
    var filtered = doctors.toList();

    // Filter by specialty
    if (selectedSpecialties.isNotEmpty) {
      filtered = filtered.where((doctor) {
        return selectedSpecialties.contains(doctor.specialty);
      }).toList();
    }

    // Filter by experience range
    filtered = filtered.where((doctor) {
      return doctor.experience >= minExperience.value &&
          doctor.experience <= maxExperience.value;
    }).toList();

    // Filter by fee range
    filtered = filtered.where((doctor) {
      return doctor.fee >= minFee.value && doctor.fee <= maxFee.value;
    }).toList();

    // Filter by status
    if (selectedStatuses.isNotEmpty) {
      filtered = filtered.where((doctor) {
        return selectedStatuses.contains(doctor.status);
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (sortBy.value) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'experience':
          comparison = a.experience.compareTo(b.experience);
          break;
        case 'fee':
          comparison = a.fee.compareTo(b.fee);
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
      }
      return sortAscending.value ? comparison : -comparison;
    });

    filteredDoctors.value = filtered;
    logger.i('🔍 Filters applied. ${filtered.length} doctors match criteria');
  }

  /// Clear all filters
  void clearFilters() {
    selectedSpecialties.clear();
    minExperience.value = 0;
    maxExperience.value = 50;
    minFee.value = 0.0;
    maxFee.value = 10000.0;
    selectedStatuses.value = ['active'];
    sortBy.value = 'name';
    sortAscending.value = true;
    filteredDoctors.value = doctors;
    logger.i('🧹 All filters cleared');
  }

  /// Extract unique specialties from doctors list
  void extractSpecialties() {
    final specialties = doctors.map((d) => d.specialty).toSet().toList();
    specialties.sort();
    availableSpecialties.value = specialties;
  }

  /// Toggle sort direction
  void toggleSortDirection() {
    sortAscending.value = !sortAscending.value;
    applyFilters();
  }

  /// Change sort field
  void changeSortBy(String field) {
    if (sortBy.value == field) {
      toggleSortDirection();
    } else {
      sortBy.value = field;
      sortAscending.value = true;
      applyFilters();
    }
  }

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (selectedSpecialties.isNotEmpty) count++;
    if (minExperience.value > 0 || maxExperience.value < 50) count++;
    if (minFee.value > 0 || maxFee.value < 10000) count++;
    if (selectedStatuses.length != 1 || !selectedStatuses.contains('active'))
      count++;
    return count;
  }
}
