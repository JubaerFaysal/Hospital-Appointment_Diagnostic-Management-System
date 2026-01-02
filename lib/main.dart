import 'package:admin_panel_web_app/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'config/theme.dart';
import 'routes/admin_pages.dart';
import 'routes/admin_routes.dart';
import 'services/api_services.dart';
import 'services/storage_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Services
  await initServices();

  runApp(const MyApp());
}

var logger = Logger();

Future<void> initServices() async {
  try {
    logger.i('📦 Initializing Storage Service...');
    await Get.putAsync(() => StorageService().init());
    logger.i('✅ Storage Service Initialized');

    logger.i('🌐 Initializing API Service...');
    await Get.putAsync(() => ApiService().init());
    logger.i('✅ API Service Initialized');

    logger.i('🎉 All Services Initialized Successfully!');
  } catch (e) {
    logger.e('❌ Error Initializing Services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080), // Desktop design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Hospital Admin Panel',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialBinding: InitialBinding(),
          initialRoute: AdminRoutes.LOGIN,
          getPages: AdminPages.routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}