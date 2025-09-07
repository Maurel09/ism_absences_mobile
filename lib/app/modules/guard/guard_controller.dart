import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/providers/api_service.dart';
import '../../data/models/course_model.dart';
import '../auth/auth_controller.dart';

class GuardController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController _authController = Get.find<AuthController>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  final studentIdController = TextEditingController();
  final RxString selectedStatus = 'PRESENT'.obs;
  final RxString selectedCourseId = ''.obs;
  final RxList<CourseModel> courses = <CourseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  @override
  void onClose() {
    studentIdController.dispose();
    super.onClose();
  }

  Future<void> loadCourses() async {
    try {
      final coursesList = await _apiService.getActiveCourses();
      courses.value = coursesList;
      if (coursesList.isNotEmpty) {
        selectedCourseId.value = coursesList.first.id;
      }
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des cours';
    }
  }

  Future<void> createPointage() async {
    if (studentIdController.text.trim().isEmpty) {
      errorMessage.value = 'Veuillez saisir l\'ID de l\'étudiant';
      return;
    }

    if (selectedCourseId.value.isEmpty) {
      errorMessage.value = 'Veuillez sélectionner un cours';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      await _apiService.createPointage(
        studentId: studentIdController.text.trim(),
        courseId: selectedCourseId.value,
        status: selectedStatus.value,
      );

      studentIdController.clear();
      successMessage.value = 'Pointage enregistré avec succès';
      
      Get.snackbar(
        'Succès',
        'Pointage enregistré avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void setStatus(String status) {
    selectedStatus.value = status;
  }

  void setCourse(String courseId) {
    selectedCourseId.value = courseId;
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  String get statusDisplayName {
    switch (selectedStatus.value) {
      case 'PRESENT':
        return 'Présent';
      case 'ABSENT':
        return 'Absent';
      case 'LATE':
        return 'En retard';
      default:
        return selectedStatus.value;
    }
  }
}
