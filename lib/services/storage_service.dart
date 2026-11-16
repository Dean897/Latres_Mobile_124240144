import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstraksi seluruh penyimpanan lokal aplikasi.
///
/// SharedPreferences dipakai untuk sesi login dan username, sedangkan Hive
/// dipakai untuk daftar favorit. Perubahan cara penyimpanan sebaiknya dilakukan
/// di file ini agar controller dan view tidak perlu ikut berubah.
class StorageService {
  /// Membuat service dengan preferences opsional untuk pengujian atau reuse.
  StorageService({this.preferences});

  static const loginKey = 'isLoggedIn';
  static const usernameKey = 'username';
  static const favoritesBoxName = 'favorites_box';

  final SharedPreferences? preferences;

  Future<SharedPreferences> get _prefs async =>
      preferences ?? SharedPreferences.getInstance();

  /// Menyimpan status login dan username user.
  Future<void> saveLogin(String username) async {
    final prefs = await _prefs;
    await prefs.setBool(loginKey, true);
    await prefs.setString(usernameKey, username);
  }

  /// Menghapus data sesi login dari penyimpanan.
  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(loginKey);
    await prefs.remove(usernameKey);
  }

  /// Mengambil username yang tersimpan, atau null jika belum ada.
  Future<String?> getUsername() async => (await _prefs).getString(usernameKey);

  Box<Map> get _favorites => Hive.box<Map>(favoritesBoxName);

  /// Mengambil seluruh favorit dalam bentuk map untuk ditampilkan di view.
  List<Map<String, dynamic>> getAllFavorites() {
    return _favorites.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Memeriksa apakah tayangan dengan [id] sudah menjadi favorit.
  bool isFavorite(int id) => _favorites.containsKey(id);

  /// Menambah atau memperbarui favorit berdasarkan id tayangan.
  Future<void> addFavorite(Map<String, dynamic> show) async {
    final id = (show['id'] as num).toInt();
    await _favorites.put(id, show);
  }

  /// Menghapus favorit berdasarkan [id].
  Future<void> removeFavorite(int id) => _favorites.delete(id);
}
