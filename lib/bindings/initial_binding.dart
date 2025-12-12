import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Keep AuthController alive throughout the app
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}