import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/storage_service.dart';

class FavoriteController extends GetxController {
  FavoriteController({StorageService? storage})
      : _storage = storage ?? StorageService();

  final StorageService _storage;
  final favorites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    Hive.box<Map>(StorageService.favoritesBoxName).watch().listen((_) {
      loadFavorites();
    });
  }

  void loadFavorites() => favorites.assignAll(_storage.getAllFavorites());

  Future<void> removeFavorite(int id) => _storage.removeFavorite(id);
}
