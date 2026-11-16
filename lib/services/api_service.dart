import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/show_model.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://api.tvmaze.com';

  Future<List<ShowModel>> fetchShows() async {
    final response = await _client.get(Uri.parse('$_baseUrl/shows'));
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_parseShow)
        .toList();
  }

  Future<ShowModel> fetchShow(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/shows/$id'));
    _ensureSuccess(response);
    return _parseShow(jsonDecode(response.body) as Map<String, dynamic>);
  }

  ShowModel _parseShow(Map<String, dynamic> json) {
    final imageData = json['image'] as Map<String, dynamic>?;
    final ratingData = json['rating'] as Map<String, dynamic>?;
    return ShowModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Untitled show',
      image: (imageData?['original'] as String?) ??
          (imageData?['medium'] as String?) ??
          '',
      rating: (ratingData?['average'] as num?)?.toDouble(),
      genres: (json['genres'] as List<dynamic>?)?.whereType<String>().toList() ??
          const [],
      summary: json['summary'] as String? ?? '',
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('TVMaze request failed (${response.statusCode})');
    }
  }
}
