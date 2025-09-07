import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/absence_model.dart';
import '../models/justification_model.dart';
import '../models/course_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _clearToken();
        }
        handler.next(error);
      },
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
  }

  // Auth endpoints
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        await _saveToken(authResponse.token);
        await _saveUser(authResponse.user);
        return authResponse;
      } else {
        throw Exception(response.data['error'] ?? 'Erreur de connexion');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur de connexion');
      }
      throw Exception('Erreur de connexion');
    }
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      });

      if (response.data['success']) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        await _saveToken(authResponse.token);
        await _saveUser(authResponse.user);
        return authResponse;
      } else {
        throw Exception(response.data['error'] ?? 'Erreur d\'inscription');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur d\'inscription');
      }
      throw Exception('Erreur d\'inscription');
    }
  }

  // Absence endpoints
  Future<List<AbsenceModel>> getAbsencesByStudentId(String studentId) async {
    try {
      final response = await _dio.get('/students/$studentId/absences');

      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((json) => AbsenceModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['error'] ?? 'Erreur lors de la récupération des absences');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur lors de la récupération des absences');
      }
      throw Exception('Erreur lors de la récupération des absences');
    }
  }

  Future<AbsenceModel> createPointage({
    required String studentId,
    required String courseId,
    required String status,
  }) async {
    try {
      final response = await _dio.post('/pointage', data: {
        'studentId': studentId,
        'courseId': courseId,
        'status': status,
      });

      if (response.data['success']) {
        return AbsenceModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['error'] ?? 'Erreur lors du pointage');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur lors du pointage');
      }
      throw Exception('Erreur lors du pointage');
    }
  }

  // Justification endpoints
  Future<List<JustificationModel>> getJustificationsByStudentId(String studentId) async {
    try {
      final response = await _dio.get('/students/$studentId/justifications');

      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((json) => JustificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['error'] ?? 'Erreur lors de la récupération des justifications');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur lors de la récupération des justifications');
      }
      throw Exception('Erreur lors de la récupération des justifications');
    }
  }

  Future<JustificationModel> createJustification({
    required String studentId,
    String? absenceId,
    required String reason,
    String? attachments,
  }) async {
    try {
      final response = await _dio.post('/justifications', data: {
        'studentId': studentId,
        'absenceId': absenceId,
        'reason': reason,
        'attachments': attachments,
      });

      if (response.data['success']) {
        return JustificationModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['error'] ?? 'Erreur lors de la création de la justification');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur lors de la création de la justification');
      }
      throw Exception('Erreur lors de la création de la justification');
    }
  }

  // Course endpoints
  Future<List<CourseModel>> getActiveCourses() async {
    try {
      final response = await _dio.get('/courses/active');

      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((json) => CourseModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['error'] ?? 'Erreur lors de la récupération des cours');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur lors de la récupération des cours');
      }
      throw Exception('Erreur lors de la récupération des cours');
    }
  }

  Future<List<CourseModel>> getAllCourses() async {
    try {
      final response = await _dio.get('/courses');

      if (response.data['success']) {
        return (response.data['data'] as List)
            .map((json) => CourseModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.data['error'] ?? 'Erreur lors de la récupération des cours');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response!.data['error'] ?? 'Erreur lors de la récupération des cours');
      }
      throw Exception('Erreur lors de la récupération des cours');
    }
  }

  Future<void> logout() async {
    await _clearToken();
  }
}
