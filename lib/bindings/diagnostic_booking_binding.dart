import 'package:get/get.dart';
import '../controller/diagnostic_booking_controller.dart';

class DiagnosticBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiagnosticBookingsController>(
      () => DiagnosticBookingsController(),
    );
  }
}
