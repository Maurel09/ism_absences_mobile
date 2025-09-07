part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const STUDENT_DASHBOARD = _Paths.STUDENT_DASHBOARD;
  static const GUARD_DASHBOARD = _Paths.GUARD_DASHBOARD;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const STUDENT_DASHBOARD = '/student-dashboard';
  static const GUARD_DASHBOARD = '/guard-dashboard';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
}
