import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/detail_controller.dart';
import '../theme/app_colors.dart';

class DetailView extends StatelessWidget {
  const DetailView({required this.showId, super.key});
  final int showId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailController(showId: showId));
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }
        final show = controller.show.value;
        if (show == null) return Center(child: Text(controller.errorMessage.value ?? 'Tidak ada data.'));
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 250, width: double.infinity, child: _image(show.image)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(show.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.star, color: AppColors.rating),
                  const SizedBox(width: 5),
                  Text(show.rating?.toStringAsFixed(1) ?? 'N/A'),
                ]),
                const SizedBox(height: 10),
                Text(show.genres.isEmpty ? 'Genre tidak tersedia' : show.genres.join(', '),
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.snackbar('Nonton', 'Memutar ${show.name}...'),
                      icon: const Text('▶'),
                      label: const Text('Nonton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => IconButton(
                        onPressed: controller.toggleFavorite,
                        icon: Icon(
                          controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                          color: controller.isFavorite.value ? AppColors.accent : Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          side: const BorderSide(color: Colors.white38),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )),
                ]),
                const SizedBox(height: 28),
                const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(_stripHtml(show.summary), style: const TextStyle(color: Colors.white70, height: 1.5)),
              ]),
            ),
          ]),
        );
      }),
    );
  }

  Widget _image(String url) {
    if (url.isEmpty) return Container(color: Colors.white10, child: const Icon(Icons.movie, size: 70));
    return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(
      color: Colors.white10, child: const Icon(Icons.movie, size: 70),
    ));
  }

  String _stripHtml(String value) => value.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
