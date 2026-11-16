import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/storage_service.dart';
import 'theme/app_colors.dart';
import 'views/login_view.dart';
import 'views/main_nav_view.dart';

/// Titik masuk aplikasi.
///
/// Inisialisasi penyimpanan dilakukan sebelum widget pertama ditampilkan agar
/// status login dan data favorit sudah siap digunakan oleh halaman aplikasi.
/// Jika ingin mengubah proses startup, tema, atau halaman awal, file ini adalah
/// tempat utama yang perlu diperiksa.
Future<void> main() async {
  // Memastikan binding Flutter siap sebelum menjalankan operasi async.
  WidgetsFlutterBinding.ensureInitialized();

  // Menyiapkan Hive untuk penyimpanan data lokal.
  await Hive.initFlutter();
  await Hive.openBox<Map>('favorites_box');

  // Membaca sesi login yang tersimpan di SharedPreferences.
  final preferences = await SharedPreferences.getInstance();
  final isLoggedIn = preferences.getBool(StorageService.loginKey) ?? false;

  runApp(NontonSkuyApp(isLoggedIn: isLoggedIn));
}

/// Widget root yang mengatur konfigurasi global aplikasi.
///
/// [isLoggedIn] menentukan halaman pertama: [MainNavView] untuk user yang
/// masih memiliki sesi atau [LoginView] untuk user yang belum login.
class NontonSkuyApp extends StatelessWidget {
  /// Membuat root aplikasi dengan status sesi awal.
  const NontonSkuyApp({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  /// Membuat navigator GetX, tema global, dan halaman awal aplikasi.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NontonSkuy!',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MainNavView() : const LoginView(),
    );
  }
}
