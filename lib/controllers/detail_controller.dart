import 'package:get/get.dart';

import '../models/show_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Mengelola data detail satu tayangan dan status favoritnya.
///
/// [showId] berasal dari kartu tayangan di [HomeView] atau [FavoriteView].
/// Controller ini menggabungkan data remote dari [ApiService] dengan data
/// lokal dari [StorageService].
class DetailController extends GetxController {
  /// Membuat controller untuk tayangan dengan id tertentu.
  DetailController({
    required this.showId,
    ApiService? apiService,
    StorageService? storage,
  }) : _apiService = apiService ?? ApiService(),
       _storage = storage ?? StorageService();

  final int showId;
  final ApiService _apiService;
  final StorageService _storage;
  final show = Rxn<ShowModel>();
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final isFavorite = false.obs;

  /// Memuat detail tayangan saat halaman dibuka.
  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  /// Mengambil detail dan mengecek apakah tayangan sudah menjadi favorit.
  Future<void> fetchDetails() async {
    try {
      show.value = await _apiService.fetchShow(showId);
      isFavorite.value = _storage.isFavorite(showId);
    } catch (error) {
      errorMessage.value = 'Gagal memuat detail tayangan.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Menambah atau menghapus tayangan dari daftar favorit.
  Future<void> toggleFavorite() async {
    final current = show.value;
    if (current == null) return;
    if (isFavorite.value) {
      await _storage.removeFavorite(current.id);
    } else {
      await _storage.addFavorite(current.toMap());
    }
    isFavorite.toggle();
  }
}
