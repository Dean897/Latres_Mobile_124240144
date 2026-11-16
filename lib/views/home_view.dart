import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../models/show_model.dart';
import 'detail_view.dart';
import '../theme/app_colors.dart';

/// Halaman beranda yang menampilkan daftar tayangan dari TVMaze.
///
/// Controller menyediakan state loading/error/data, sedangkan widget privat
/// di bawahnya memecah tampilan kartu, poster, rating, dan error state.
class HomeView extends StatelessWidget {
  /// Membuat halaman beranda.
  const HomeView({super.key});

  /// Menampilkan loading, error, atau grid tayangan sesuai state controller.
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('NITFLIK'),
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        if (controller.errorMessage.value != null) {
          return _ErrorState(
            message: controller.errorMessage.value!,
            onRetry: controller.fetchShows,
          );
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: controller.fetchShows,
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .63,
            ),
            itemCount: controller.shows.length,
            itemBuilder: (_, index) => _ShowCard(show: controller.shows[index]),
          ),
        );
      }),
    );
  }
}

class _ShowCard extends StatelessWidget {
  /// Membuat kartu ringkas untuk satu tayangan.
  const _ShowCard({required this.show});
  final ShowModel show;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Get.to(() => DetailView(showId: show.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Poster(url: show.image)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  _Rating(rating: show.rating),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  /// Menampilkan poster jaringan atau placeholder jika URL gagal/kosong.
  const _Poster({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.white10,
    child: const Center(
      child: Icon(Icons.movie_outlined, size: 42, color: Colors.white38),
    ),
  );
}

class _Rating extends StatelessWidget {
  /// Menampilkan rating numerik atau `N/A` jika tidak tersedia.
  const _Rating({required this.rating});
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.rating, size: 16),
        const SizedBox(width: 4),
        Text(
          rating?.toStringAsFixed(1) ?? 'N/A',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  /// Menampilkan pesan error dan aksi untuk memuat ulang data.
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
      ],
    ),
  );
}
