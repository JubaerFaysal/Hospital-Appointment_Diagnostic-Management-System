import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnalyticsController extends GetxController {
  final isLoading = false.obs;

  // Stats Data
  final monthlyRevenue = '৳1,24,500'.obs;
  final totalAppointments = '248'.obs;
  final testsConducted = '156'.obs;
  final patientSatisfaction = '94%'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  void loadAnalytics() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  // Chart Data placeholders can be added here
}
