import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/show_model.dart';

/// Service untuk mengambil data tayangan dari TVMaze API.
///
/// Controller memanggil service ini agar detail komunikasi HTTP dan parsing
/// JSON tidak bercampur dengan logika tampilan. Untuk mengganti sumber API,
/// ubah [_baseUrl] dan [_parseShow], lalu sesuaikan endpoint di method fetch.
///
/// Contoh penggantian:
/// - Ganti server: ubah
///   `https://api.tvmaze.com` menjadi `https://api.example.com`.
/// - Jika endpoint daftar berubah dari `/shows` menjadi `/series`, ubah
///   URL di [fetchShows].
/// - Jika endpoint detail berubah dari `/shows/$id` menjadi `/series/$id`,
///   ubah URL di [fetchShow].
/// - Jika nama field API berubah dari `name` menjadi `title`, ganti
///   `json['name']` menjadi `json['title']` di [_parseShow].
/// - Jika gambar API tidak lagi memakai `image.original`/`image.medium`,
///   sesuaikan pembacaan [imageData] di [_parseShow].
/// Setelah mengubah format JSON, periksa juga [ShowModel] dan view yang
/// menggunakan field tersebut.
class ApiService {
  /// Membuat service dengan client HTTP yang dapat diganti saat pengujian.
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://api.tvmaze.com';

  /// Mengambil daftar tayangan dari endpoint TVMaze.
  ///
  /// URL saat ini: `$_baseUrl/shows`.
  Future<List<ShowModel>> fetchShows() async {
    final response = await _client.get(Uri.parse('$_baseUrl/shows'));
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.whereType<Map<String, dynamic>>().map(_parseShow).toList();
  }

  /// Mengambil satu tayangan berdasarkan [id].
  ///
  /// URL saat ini: `$_baseUrl/shows/$id`.
  Future<ShowModel> fetchShow(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/shows/$id'));
    _ensureSuccess(response);
    return _parseShow(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Memetakan JSON TVMaze ke [ShowModel] aplikasi.
  ShowModel _parseShow(Map<String, dynamic> json) {
    final imageData = json['image'] as Map<String, dynamic>?;
    final ratingData = json['rating'] as Map<String, dynamic>?;
    return ShowModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Untitled show',
      image:
          (imageData?['original'] as String?) ??
          (imageData?['medium'] as String?) ??
          '',
      rating: (ratingData?['average'] as num?)?.toDouble(),
      genres:
          (json['genres'] as List<dynamic>?)?.whereType<String>().toList() ??
          const [],
      summary: json['summary'] as String? ?? '',
    );
  }

  /// Mengubah respons HTTP non-2xx menjadi error yang dapat ditangani controller.
  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('TVMaze request failed (${response.statusCode})');
    }
  }
}
