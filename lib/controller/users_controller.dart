import 'package:admin_panel_web_app/services/api_services.dart';
import 'package:get/get.dart';
import '../../utils/helpers.dart';
import '../data/models/user_model.dart';

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

      // Mock data - Replace with actual API call
      users.value = _getMockUsers();
      filteredUsers.value = users;

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
        return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  List<UserModel> _getMockUsers() {
    return [
      UserModel(
        id: 1,
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '01712345678',
        role: 'patient',
        isActive: true,
        createdAt: '2024-01-01',
      ),
      UserModel(
        id: 2,
        fullName: 'Jane Smith',
        email: 'jane@example.com',
        phone: '01812345679',
        role: 'patient',
        isActive: true,
        createdAt: '2024-01-02',
      ),
    ];
  }
}