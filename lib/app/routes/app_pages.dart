import 'package:get/get.dart';
import '../modules/auth/auth_view.dart';
import '../modules/auth/auth_controller.dart';
import '../modules/student/student_dashboard_view.dart';
import '../modules/student/student_controller.dart';
import '../modules/guard/guard_dashboard_view.dart';
import '../modules/guard/guard_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_DASHBOARD,
      page: () => const StudentDashboardView(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: _Paths.GUARD_DASHBOARD,
      page: () => const GuardDashboardView(),
      binding: GuardBinding(),
    ),
  ];
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentController>(() => StudentController());
  }
}

class GuardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuardController>(() => GuardController());
  }
}
