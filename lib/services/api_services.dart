import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import '../config/environment.dart';
import 'storage_services.dart';

class ApiService extends GetxService {
  late Dio dio;
  final StorageService storageService = Get.find<StorageService>();

  var logger = Logger();

  Future<ApiService> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: Environment.BASE_URL,
        connectTimeout: const Duration(
          milliseconds: Environment.CONNECTION_TIMEOUT,
        ),
        receiveTimeout: const Duration(
          milliseconds: Environment.RECEIVE_TIMEOUT,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ✅ Add interceptor for automatic token attachment
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ✅ Automatically attach JWT token to all requests
          final token = storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          logger.i('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
          logger.d('Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i(
            '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          logger.e(
            '❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          logger.e('Error message: ${error.message}');

          // ✅ Handle 401 Unauthorized (token expired or invalid)
          if (error.response?.statusCode == 401) {
            logger.w(
              '⚠️ Unauthorized! Clearing storage and redirecting to login...',
            );
            await storageService.clearAll();
            Get.offAllNamed('/login');
          }

          return handler.next(error);
        },
      ),
    );

    return this;
  }

  // GET Request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(endpoint, queryParameters: queryParameters);
  }

  // POST Request
  Future<Response> post(String endpoint, {dynamic data}) async {
    return await dio.post(endpoint, data: data);
  }

  // PUT Request
  Future<Response> put(String endpoint, {dynamic data}) async {
    return await dio.put(endpoint, data: data);
  }

  // ✅ ADDED: PATCH Request (required by backend)
  Future<Response> patch(String endpoint, {dynamic data}) async {
    return await dio.patch(endpoint, data: data);
  }

  // DELETE Request
  Future<Response> delete(String endpoint) async {
    return await dio.delete(endpoint);
  }

  // Handle Errors
  String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error';
    }
  }
}
