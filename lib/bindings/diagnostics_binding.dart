import 'package:get/get.dart';
import '../controller/diagnostics_controller.dart';

class DiagnosticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiagnosticsController>(
      () => DiagnosticsController(),
    );
  }
}
