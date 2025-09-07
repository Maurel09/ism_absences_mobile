import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/api_service.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }

  void _checkAuthStatus() async {
    // Vérifier si l'utilisateur est déjà connecté
    // Cette logique peut être implémentée avec SharedPreferences
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Veuillez remplir tous les champs';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final authResponse = await _apiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      currentUser.value = authResponse.user;
      
      // Rediriger selon le rôle
      if (authResponse.user.isStudent) {
        Get.offAllNamed(Routes.STUDENT_DASHBOARD);
      } else if (authResponse.user.isGuard) {
        Get.offAllNamed(Routes.GUARD_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (emailController.text.isEmpty || 
        passwordController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty) {
      errorMessage.value = 'Veuillez remplir tous les champs';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final authResponse = await _apiService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        role: 'STUDENT', // Par défaut, on enregistre comme étudiant
      );

      currentUser.value = authResponse.user;
      Get.offAllNamed(Routes.STUDENT_DASHBOARD);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    currentUser.value = null;
    Get.offAllNamed(Routes.LOGIN);
  }

  void clearError() {
    errorMessage.value = '';
  }
}
