import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/storage_service.dart';
import '../views/login_view.dart';
import '../views/main_nav_view.dart';
import '../theme/app_colors.dart';

/// Mengelola autentikasi sederhana dan sesi login aplikasi.
///
/// Controller ini menerima input dari [LoginView], memvalidasi kredensial,
/// menyimpan sesi melalui [StorageService], dan mengatur navigasi login/logout.
class AuthController extends GetxController {
  /// Membuat controller dengan storage yang dapat diganti saat pengujian.
  AuthController({StorageService? storage})
    : _storage = storage ?? StorageService();

  final StorageService _storage;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  /// Memvalidasi input, menyimpan sesi, lalu membuka halaman utama.
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

  /// Menghapus sesi dan mengembalikan user ke halaman login.
  Future<void> logout() async {
    await _storage.logout();
    Get.offAll(() => const LoginView());
  }

  /// Membersihkan controller text saat controller tidak lagi digunakan.
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
