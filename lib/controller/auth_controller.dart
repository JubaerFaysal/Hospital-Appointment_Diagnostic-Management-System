import 'package:get/get.dart';
import '../config/environment.dart';
import '../services/api_services.dart';
import '../services/storage_services.dart';
import '../utils/helpers.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = _storageService.getToken();
    isLoggedIn.value = token != null;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        '/admin-auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        await _storageService.saveToken(response.data['token']);
        await _storageService.saveAdmin(response.data['admin']);

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
      await _storageService.clearAll();
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    }
  }
}