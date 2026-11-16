import 'package:get/get.dart';

import '../models/show_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class DetailController extends GetxController {
  DetailController({
    required this.showId,
    ApiService? apiService,
    StorageService? storage,
  })  : _apiService = apiService ?? ApiService(),
        _storage = storage ?? StorageService();

  final int showId;
  final ApiService _apiService;
  final StorageService _storage;
  final show = Rxn<ShowModel>();
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

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
