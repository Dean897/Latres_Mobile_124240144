import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService({this.preferences});

  static const loginKey = 'isLoggedIn';
  static const usernameKey = 'username';
  static const favoritesBoxName = 'favorites_box';

  final SharedPreferences? preferences;

  Future<SharedPreferences> get _prefs async =>
      preferences ?? SharedPreferences.getInstance();

  Future<void> saveLogin(String username) async {
    final prefs = await _prefs;
    await prefs.setBool(loginKey, true);
    await prefs.setString(usernameKey, username);
  }

  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(loginKey);
    await prefs.remove(usernameKey);
  }

  Future<String?> getUsername() async => (await _prefs).getString(usernameKey);

  Box<Map> get _favorites => Hive.box<Map>(favoritesBoxName);

  List<Map<String, dynamic>> getAllFavorites() {
    return _favorites.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  bool isFavorite(int id) => _favorites.containsKey(id);

  Future<void> addFavorite(Map<String, dynamic> show) async {
    final id = (show['id'] as num).toInt();
    await _favorites.put(id, show);
  }

  Future<void> removeFavorite(int id) => _favorites.delete(id);
}
