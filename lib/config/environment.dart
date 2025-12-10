class Environment {
  // API Configuration
  static const String BASE_URL = 'http://localhost:3000'; // Your NestJS backend

  static const String API_VERSION = 'v1';

  // Storage Keys
  static const String TOKEN_KEY = 'auth_token';
  static const String ADMIN_TOKEN_KEY = 'admin_token';
  static const String USER_KEY = 'user_data';
  static const String ADMIN_KEY = 'admin_data';
  static const String LANGUAGE_KEY = 'app_language';

  // App Info
  static const String APP_NAME = 'Hospital App';
  static const String ADMIN_APP_NAME = 'Hospital Admin';
  static const String APP_VERSION = '1.0.0';

  // Timeouts
  static const int CONNECTION_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;
}