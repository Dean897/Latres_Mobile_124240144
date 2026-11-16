import 'package:get/get.dart';

import '../models/show_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  HomeController({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  final shows = <ShowModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

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
