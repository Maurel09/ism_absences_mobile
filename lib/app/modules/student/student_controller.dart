import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../data/models/absence_model.dart';
import '../../data/models/justification_model.dart';
import '../../data/providers/api_service.dart';
import '../auth/auth_controller.dart';

class StudentController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController _authController = Get.find<AuthController>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<AbsenceModel> absences = <AbsenceModel>[].obs;
  final RxList<JustificationModel> justifications = <JustificationModel>[].obs;

  // Pagination states
  final RxInt currentAbsencePage = 1.obs;
  final RxInt currentJustificationPage = 1.obs;
  final int itemsPerPage = 5;

  final reasonController = TextEditingController();

  // Pagination methods
  List<AbsenceModel> get paginatedAbsences {
    final startIndex = (currentAbsencePage.value - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return absences.skip(startIndex).take(itemsPerPage).toList();
  }

  List<JustificationModel> get paginatedJustifications {
    final startIndex = (currentJustificationPage.value - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return justifications.skip(startIndex).take(itemsPerPage).toList();
  }

  int get totalAbsencePages => (absences.length / itemsPerPage).ceil();
  int get totalJustificationPages => (justifications.length / itemsPerPage).ceil();

  void nextAbsencePage() {
    if (currentAbsencePage.value < totalAbsencePages) {
      currentAbsencePage.value++;
    }
  }

  void previousAbsencePage() {
    if (currentAbsencePage.value > 1) {
      currentAbsencePage.value--;
    }
  }

  void nextJustificationPage() {
    if (currentJustificationPage.value < totalJustificationPages) {
      currentJustificationPage.value++;
    }
  }

  void previousJustificationPage() {
    if (currentJustificationPage.value > 1) {
      currentJustificationPage.value--;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    if (_authController.currentUser.value == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final studentId = _authController.currentUser.value!.id;
      
      final [absencesData, justificationsData] = await Future.wait([
        _apiService.getAbsencesByStudentId(studentId),
        _apiService.getJustificationsByStudentId(studentId),
      ]);

      absences.value = absencesData as List<AbsenceModel>;
      justifications.value = justificationsData as List<JustificationModel>;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createJustification() async {
    if (reasonController.text.trim().isEmpty) {
      errorMessage.value = 'Veuillez saisir une raison';
      return;
    }

    if (_authController.currentUser.value == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final studentId = _authController.currentUser.value!.id;
      
      await _apiService.createJustification(
        studentId: studentId,
        reason: reasonController.text.trim(),
      );

      reasonController.clear();
      await loadData(); // Recharger les données
      
      Get.snackbar(
        'Succès',
        'Justification envoyée avec succès',
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

  Future<void> createJustificationForAbsence(String absenceId, String reason, List<Map<String, dynamic>>? attachments) async {
    if (_authController.currentUser.value == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final studentId = _authController.currentUser.value!.id;
      
      // Convertir les attachments en JSON string
      String? attachmentsJson;
      if (attachments != null && attachments.isNotEmpty) {
        attachmentsJson = jsonEncode(attachments);
      }
      
      await _apiService.createJustification(
        studentId: studentId,
        absenceId: absenceId,
        reason: reason,
        attachments: attachmentsJson,
      );

      await loadData(); // Recharger les données
      
      Get.snackbar(
        'Succès',
        'Justification envoyée avec succès',
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

  void clearError() {
    errorMessage.value = '';
  }

  int get totalAbsences => absences.where((a) => a.isAbsent).length;
  int get totalLates => absences.where((a) => a.isLate).length;
  int get pendingJustifications => justifications.where((j) => j.isPending).length;
}
