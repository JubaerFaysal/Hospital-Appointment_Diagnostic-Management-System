import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../services/api_services.dart';
import '../utils/helpers.dart';
import '../models/user_model.dart';

class UsersController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final users = <UserModel>[].obs;
  final filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/admin-auth/users');

      if (response.data != null) {
        users.value = (response.data as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
        filteredUsers.value = users;
      }
    } catch (e) {
      print('Error loading users: $e');
      Helpers.showErrorSnackbar('Error', 'Failed to load users');
    } finally {
      isLoading.value = false;
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.phone.contains(query);
      }).toList();
    }
  }

  Future<void> deleteUser(int id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: 'Delete User',
      message: 'Are you sure you want to delete this user?',
      confirmText: 'Delete',
    );

    if (!confirmed) return;

    try {
      Helpers.showLoadingDialog();
      await _apiService.delete('/admin-auth/users/$id');
      Helpers.hideLoadingDialog();
      await loadUsers();
      Helpers.showSuccessSnackbar('Success', 'User deleted successfully');
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to delete user',
      );
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      Helpers.showLoadingDialog();

      final response = await _apiService.put(
        '/admin-auth/users/$id',
        data: data,
      );

      Helpers.hideLoadingDialog();

      if (response.statusCode == 200) {
        await loadUsers();
        Get.back();
        Helpers.showSuccessSnackbar('Success', 'User updated successfully');
      }
    } on DioException catch (e) {
      Helpers.hideLoadingDialog();
      Helpers.showErrorSnackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update user',
      );
    }
  }
}
