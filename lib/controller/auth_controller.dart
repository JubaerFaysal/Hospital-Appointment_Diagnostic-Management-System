import 'package:get/get.dart';
import '../services/api_services.dart';
import '../services/storage_services.dart';
import '../utils/helpers.dart';

class AuthController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final StorageService storageService = Get.find<StorageService>();

  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = storageService.getToken();
    isLoggedIn.value = token != null;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      Helpers.showLoadingDialog();

      final response = await apiService.post(
        '/admin-auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      Helpers.hideLoadingDialog();

      if (response.data['success'] == true) {
        await storageService.saveToken(response.data['token']);
        await storageService.saveAdmin(response.data['admin']);

        isLoggedIn.value = true;

        Helpers.showSuccessSnackbar('Success', 'Login successful');
        Get.offAllNamed('/dashboard');
      } else {
        Helpers.showErrorSnackbar(
          'Error',
          response.data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      Helpers.hideLoadingDialog();
      print('Login error: $e');
      Helpers.showErrorSnackbar('Error', 'Invalid email or password');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );

    if (confirmed) {
      await storageService.clearAll();
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    }
  }
}