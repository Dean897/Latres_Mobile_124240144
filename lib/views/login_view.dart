import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';

/// Halaman login aplikasi NITFLIK.
///
/// Tanggung jawab halaman ini hanya membangun tampilan dan meneruskan
/// tindakan login ke [AuthController]. Validasi username/password, penyimpanan
/// sesi, serta perpindahan halaman dilakukan oleh controller tersebut.
///
/// Panduan perubahan:
/// - Ganti nama/logo: ubah [Icons.local_movies] dan teks `NITFLIK` di [build].
/// - Ganti jarak atau ukuran komponen: ubah nilai `SizedBox`, `padding`, atau
///   ukuran ikon di [build].
/// - Ganti warna: ubah [AppColors], bukan warna pada setiap widget satu per satu.
/// - Menambah input: buat controller baru di [AuthController], lalu panggil
///   [_field] dari [build].
/// - Menambah aksi: tambahkan tombol di [build] dan method terkait di
///   [AuthController].
/// - Mengubah aturan login: ubah [AuthController.login], bukan kode tampilan.
class LoginView extends StatelessWidget {
  /// Membuat halaman login tanpa state lokal.
  const LoginView({super.key});

  /// Menyusun seluruh tampilan halaman login.
  ///
  /// [Get.put] mendaftarkan atau mengambil [AuthController] dari dependency
  /// injection GetX. Controller yang sama dipakai oleh semua field dan tombol
  /// pada halaman ini.
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      // Warna dasar halaman diambil dari tema terpusat aplikasi.
      backgroundColor: AppColors.background,
      body: SafeArea(
        // Mencegah konten tertutup notch/status bar perangkat.
        child: Center(
          // Memusatkan form dan memungkinkan halaman discroll saat keyboard
          // atau layar berukuran kecil mengurangi ruang yang tersedia.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                // Ikon identitas aplikasi.
                const Icon(
                  Icons.local_movies,
                  color: AppColors.accent,
                  size: 72,
                ),

                // Jarak antara ikon dan nama aplikasi.
                const SizedBox(height: 18),

                // Nama aplikasi yang ditampilkan di halaman login.
                const Text(
                  'NITFLIK',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                // Jarak antara identitas aplikasi dan form.
                const SizedBox(height: 40),

                // Input username. Controller menyimpan nilai yang diketik user.
                _field(
                  controller: controller.usernameController,
                  label: 'Username',
                  icon: Icons.person_outline,
                ),

                // Jarak antar-input.
                const SizedBox(height: 16),

                // Input password. obscureText menyamarkan karakter password.
                _field(
                  controller: controller.passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                // Jarak antara form dan tombol login.
                const SizedBox(height: 28),

                // Obx membangun ulang tombol ketika isLoading berubah.
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      // Tombol dinonaktifkan saat login sedang diproses agar
                      // user tidak mengirim permintaan berulang.
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,

                      // Gaya tombol login dan bentuk sudutnya.
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),

                      // Saat loading tampilkan spinner; jika tidak tampilkan
                      // label tombol biasa.
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Membuat field input yang memiliki gaya konsisten.
  ///
  /// Gunakan helper ini untuk field baru agar bentuk, warna, dan border tetap
  /// seragam. [controller] menghubungkan input dengan controller data,
  /// [label] adalah teks petunjuk field, [icon] adalah ikon di sebelah kiri,
  /// dan [obscureText] menyamarkan teks untuk password atau data sensitif.
  ///
  /// Cara menambah field baru:
  /// 1. Tambahkan `TextEditingController` di [AuthController].
  /// 2. Panggil helper ini di [build] dengan controller, label, dan ikon baru.
  /// 3. Baca nilainya dari controller saat method aksi dijalankan.
  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      // Sumber nilai input yang dikelola oleh AuthController.
      controller: controller,

      // Jika true, setiap karakter ditampilkan sebagai karakter tersembunyi.
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        // Label membantu user mengenali tujuan field.
        labelText: label,

        // Ikon visual yang menjelaskan jenis data yang diminta.
        prefixIcon: Icon(icon),

        // Mengaktifkan warna latar belakang field.
        filled: true,
        fillColor: AppColors.surface,

        // Border default, saat field belum aktif atau belum fokus.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white24),
        ),

        // Border saat field tersedia tetapi tidak sedang dipilih.
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white24),
        ),

        // Border saat user sedang mengetik pada field.
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
      ),
    );
  }
}
