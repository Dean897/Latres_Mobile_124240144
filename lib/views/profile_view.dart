import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profil'),
        backgroundColor: AppColors.background,
      ),
      body: FutureBuilder<String?>(
        future: StorageService().getUsername(),
        builder: (context, snapshot) {
          final username = snapshot.data ?? '124240144';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(children: [
              const CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, size: 62, color: AppColors.accent),
              ),
              const SizedBox(height: 16),
              Text(username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 28),
              const Text(
                'Kesan: Praktikum mobile sangat seru (kayaknya) dan menantang (banget), banyak belajar hal-hal baru tentang pengembangan aplikasi mobile.\n\n'
                'Pesan: Terima kasih kepada kakak-kakak asisten praktikum atas bimbingannya selama satu semester ini!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mutedText, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: authController.logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
