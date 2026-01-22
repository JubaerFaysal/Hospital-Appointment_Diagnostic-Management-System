import 'package:get/get.dart';

import '../controller/doctor_controller.dart';

class DoctorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorsController>(() => DoctorsController());
  }
}
