import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/auth/auth_controller.dart';
import 'app/modules/student/student_controller.dart';
import 'app/modules/guard/guard_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ISM - Gestion des Absences',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: const Color(0xFF442A1B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF442A1B),
          primary: const Color(0xFF442A1B),
          secondary: const Color(0xFFD17E1F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF442A1B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD17E1F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFD17E1F),
              width: 2,
            ),
          ),
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<StudentController>(() => StudentController());
    Get.lazyPut<GuardController>(() => GuardController());
  }
}
