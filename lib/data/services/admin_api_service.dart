import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../config/environment.dart';
import '../../../data/services/storage_service.dart';

class AdminApiService extends GetxService {
  late Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();

  Future<AdminApiService> init() async {
    _dio = Dio(
      BaseOptions(
        baseURL: Environment.BASE_URL,
        connectTimeout: const Duration(milliseconds: Environment.CONNECTION_TIMEOUT),
        receiveTimeout: const Duration(milliseconds: Environment.RECEIVE_TIMEOUT),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _storageService.read(Environment.ADMIN_TOKEN_KEY);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('🚀 ADMIN REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ADMIN RESPONSE[${response.statusCode}]');
          return handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ ADMIN ERROR[${error.response?.statusCode}]');
          if (error.response?.statusCode == 401) {
            await _storageService.remove(Environment.ADMIN_TOKEN_KEY);
            await _storageService.remove(Environment.ADMIN_KEY);
            Get.offAllNamed('/admin/login');
          }
          return handler.next(error);
        },
      ),
    );

    return this;
  }

  // Generic Methods
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }

  String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      default:
        return 'Network error';
    }
  }
}