import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/storage_service.dart';

/// Menyediakan daftar favorit dan menyinkronkannya dengan Hive.
///
/// Listener perubahan Hive membuat daftar favorit ikut diperbarui ketika item
/// ditambah atau dihapus dari halaman detail maupun halaman favorit.
class FavoriteController extends GetxController {
  /// Membuat controller dengan storage opsional untuk pengujian.
  FavoriteController({StorageService? storage})
    : _storage = storage ?? StorageService();

  final StorageService _storage;
  final favorites = <Map<String, dynamic>>[].obs;

  /// Memuat data awal dan memasang listener perubahan box Hive.
  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    Hive.box<Map>(StorageService.favoritesBoxName).watch().listen((_) {
      loadFavorites();
    });
  }

  /// Membaca ulang favorit dari penyimpanan lokal.
  void loadFavorites() => favorites.assignAll(_storage.getAllFavorites());

  /// Menghapus favorit; listener Hive akan menyegarkan daftar di UI.
  Future<void> removeFavorite(int id) => _storage.removeFavorite(id);
}
