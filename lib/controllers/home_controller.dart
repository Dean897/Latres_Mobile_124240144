import 'package:get/get.dart';

import '../models/show_model.dart';
import '../services/api_service.dart';

/// Menyediakan daftar tayangan untuk [HomeView].
///
/// State yang diamati view adalah [shows], [isLoading], dan [errorMessage].
/// Pemanggilan ulang data dilakukan melalui [fetchShows].
class HomeController extends GetxController {
  /// Membuat controller dengan service API opsional untuk pengujian.
  HomeController({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  final shows = <ShowModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  /// Memuat data otomatis saat controller pertama kali digunakan.
  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

  /// Mengambil ulang daftar tayangan dan memperbarui state UI.
  Future<void> fetchShows() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      shows.assignAll(await _apiService.fetchShows());
    } catch (error) {
      errorMessage.value = 'Gagal memuat daftar tayangan. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }
}
