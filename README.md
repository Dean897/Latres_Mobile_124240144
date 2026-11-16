# NITFLIK

Aplikasi Flutter untuk menampilkan daftar tayangan, melihat detail tayangan,
menyimpan tayangan favorit, dan mengelola sesi login sederhana.

## Teknologi

- Flutter dan Dart
- GetX untuk state management, dependency injection, dan navigasi
- TVMaze API sebagai sumber data tayangan
- SharedPreferences untuk status login dan username
- Hive untuk penyimpanan daftar favorit secara lokal

## Package pada `pubspec.yaml`

### Dependencies aplikasi

| Package | Versi | Kegunaan |
| --- | --- | --- |
| `flutter` | SDK | Framework utama untuk membangun aplikasi |
| `get` | `^4.6.6` | State reaktif (`Obx`), controller, dependency injection, snackbar, dan navigasi |
| `http` | `^1.2.2` | Mengirim request HTTP ke TVMaze API |
| `shared_preferences` | `^2.3.3` | Menyimpan status login dan username dalam bentuk key-value |
| `hive` | `^2.2.3` | Database lokal ringan untuk data favorit |
| `hive_flutter` | `^1.1.0` | Inisialisasi Hive agar dapat dipakai pada aplikasi Flutter |

### Dev dependencies

| Package | Versi | Kegunaan |
| --- | --- | --- |
| `flutter_test` | SDK | Menulis dan menjalankan unit/widget test Flutter |
| `flutter_lints` | `^6.0.0` | Aturan lint untuk menjaga kualitas dan konsistensi kode Dart |

Package di atas adalah dependency yang tercantum pada `pubspec.yaml`. File
`pubspec.lock` menyimpan versi resolusi aktual yang dipakai pada mesin saat
dependency diambil.

## Menjalankan proyek

Pastikan Flutter SDK sudah terpasang, lalu jalankan:

```bash
flutter pub get
flutter run
```

Pemeriksaan kode:

```bash
flutter analyze
dart format lib
```

## Struktur kode

```text
lib/
├── main.dart                    # Inisialisasi storage dan root aplikasi
├── models/
│   └── show_model.dart          # Bentuk data tayangan
├── services/
│   ├── api_service.dart         # Komunikasi dengan TVMaze API
│   └── storage_service.dart     # SharedPreferences dan Hive
├── controllers/
│   ├── auth_controller.dart     # Login dan logout
│   ├── home_controller.dart     # Data beranda
│   ├── detail_controller.dart   # Data detail dan status favorit
│   └── favorite_controller.dart # Daftar favorit
├── views/
│   ├── login_view.dart          # Form login
│   ├── main_nav_view.dart       # Navigasi Beranda/Favorit/Profil
│   ├── home_view.dart           # Grid daftar tayangan
│   ├── detail_view.dart         # Detail dan aksi favorit
│   ├── favorite_view.dart       # Daftar tayangan favorit
│   └── profile_view.dart        # Profil dan logout
└── theme/
    └── app_colors.dart          # Palet warna bersama
```

## Alur aplikasi

1. `main.dart` menginisialisasi Hive dan membaca status login dari
   SharedPreferences.
2. User yang belum login diarahkan ke `LoginView`; user yang sudah login
   diarahkan ke `MainNavView`.
3. `AuthController` memvalidasi form, menyimpan sesi melalui
   `StorageService`, lalu membuka navigasi utama.
4. `HomeController` mengambil daftar tayangan melalui `ApiService`.
5. User dapat membuka `DetailView` untuk melihat detail dan menambah/menghapus
   favorit.
6. `FavoriteController` membaca data Hive dan menyegarkan daftar saat isi box
   berubah.
7. `ProfileView` membaca username dan menggunakan `AuthController` untuk
   logout.

## Panduan perubahan

| Kebutuhan | File yang diubah |
| --- | --- |
| Mengubah warna aplikasi | `lib/theme/app_colors.dart` |
| Mengubah endpoint atau format API | `lib/services/api_service.dart` |
| Mengubah penyimpanan login/favorit | `lib/services/storage_service.dart` |
| Mengubah validasi login | `lib/controllers/auth_controller.dart` |
| Mengubah layout halaman | File terkait di `lib/views/` |
| Menambah field login | `auth_controller.dart` dan `login_view.dart` |
| Menambah tab utama | `main_nav_view.dart` |
| Menambah atribut tayangan | `show_model.dart`, parser API, dan view yang menampilkannya |
| Menambah package | `pubspec.yaml`, lalu jalankan `flutter pub get` |

Setiap file Dart di dalam `lib/` juga memiliki dokumentasi inline mengenai
tanggung jawab class, method penting, dan lokasi perubahan yang umum.

## Contoh penggantian kode

Gunakan pola berikut ketika ingin mengubah aplikasi. Nilai di kolom **Sebelum**
adalah bagian yang saat ini digunakan, sedangkan **Sesudah** adalah contoh
penggantinya.

| Tujuan | Sebelum | Sesudah | File |
| --- | --- | --- | --- |
| Mengganti nama aplikasi di halaman utama | `NITFLIK` | `MovieKu` | `lib/views/home_view.dart` |
| Mengganti warna aksen | `AppColors.accent` | `Colors.red` atau warna baru di `AppColors` | `lib/theme/app_colors.dart` dan view terkait |
| Mengganti URL server API | `https://api.tvmaze.com` | `https://api.example.com` | `lib/services/api_service.dart` |
| Mengganti endpoint daftar | `$_baseUrl/shows` | `$_baseUrl/series` | `lib/services/api_service.dart` |
| Mengganti endpoint detail | `$_baseUrl/shows/$id` | `$_baseUrl/series/$id` | `lib/services/api_service.dart` |
| Mengganti field nama dari API | `json['name']` | `json['title']` | `_parseShow` di `api_service.dart` |
| Mengubah teks tombol login | `'Login'` | `'Masuk'` | `lib/views/login_view.dart` |
| Mengubah tinggi tombol | `height: 52` | `height: 60` | `lib/views/login_view.dart` |
| Mengubah jumlah kolom grid | `crossAxisCount: 2` | `crossAxisCount: 3` | `lib/views/home_view.dart` |
| Mengubah label tab | `'Beranda'` | `'Home'` | `lib/views/main_nav_view.dart` |

### Contoh mengganti API

Jika API baru memiliki format berikut:

```json
{
  "id": 1,
  "title": "Contoh Film",
  "poster": "https://example.com/poster.jpg",
  "score": 8.5
}
```

Jangan hanya mengganti URL. Ubah juga pemetaan di
`lib/services/api_service.dart`:

```dart
name: json['title'] as String? ?? 'Untitled show',
image: json['poster'] as String? ?? '',
rating: (json['score'] as num?)?.toDouble(),
```

Jika struktur data internal ikut berubah, sesuaikan `ShowModel`, service
penyimpanan favorit, dan view yang membaca `show.name`, `show.image`, atau
`show.rating`. Setelah perubahan, jalankan:

```bash
flutter pub get
dart format lib
flutter analyze
```
