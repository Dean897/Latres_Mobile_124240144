import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/storage_service.dart';
import '../views/login_view.dart';
import '../views/main_nav_view.dart';
import '../theme/app_colors.dart';

class AuthController extends GetxController {
  AuthController({StorageService? storage})
      : _storage = storage ?? StorageService();

  final StorageService _storage;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    if (usernameController.text.trim() != '124240144' ||
        passwordController.text != '123') {
      Get.snackbar(
        'Login gagal',
        'Username atau password tidak sesuai.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
      );
      return;
    }
    isLoading.value = true;
    await _storage.saveLogin('124240144');
    isLoading.value = false;
    Get.offAll(() => const MainNavView());
  }

  Future<void> logout() async {
    await _storage.logout();
    Get.offAll(() => const LoginView());
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
