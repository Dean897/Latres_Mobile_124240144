import 'package:flutter/material.dart';

/// Palet warna bersama untuk menjaga konsistensi visual aplikasi.
///
/// Tambahkan warna baru di sini jika warna tersebut dipakai oleh beberapa
/// halaman. Dengan begitu perubahan tema dapat dilakukan dari satu tempat.
abstract final class AppColors {
  static const background = Color(0xFF0B132B);
  static const surface = Color(0xFF1C2541);
  static const navigation = Color(0xFF111A33);
  static const accent = Color(0xFF2EC4B6);
  static const rating = Color(0xFFFFB703);
  static const text = Color(0xFFF8FAFC);
  static const mutedText = Color(0xFFB8C1D1);
}
