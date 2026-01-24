import 'package:get/get.dart';
import '../controller/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
  }
}
