/// Model data tayangan yang digunakan oleh API, favorit, dan tampilan.
///
/// Model ini menjadi bentuk data yang konsisten di dalam aplikasi meskipun
/// struktur respons API dan struktur penyimpanan lokal berbeda.
class ShowModel {
  /// Membuat data tayangan.
  ///
  /// [rating], [genres], dan [summary] boleh kosong karena API tidak selalu
  /// mengirimkan nilai untuk semua tayangan.
  const ShowModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    this.genres = const [],
    this.summary = '',
  });

  final int id;
  final String name;
  final String image;
  final double? rating;
  final List<String> genres;
  final String summary;

  /// Mengubah model menjadi map ringkas untuk disimpan sebagai favorit.
  ///
  /// Hanya data yang diperlukan oleh daftar favorit yang disimpan.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'image': image, 'rating': rating};
  }

  /// Membuat model dari map, termasuk data yang dibaca dari penyimpanan lokal.
  ///
  /// Nilai default digunakan agar data lama atau respons tidak lengkap tidak
  /// menyebabkan aplikasi gagal saat ditampilkan.
  factory ShowModel.fromMap(Map<String, dynamic> map) {
    final ratingValue = map['rating'];
    return ShowModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name'] as String? ?? 'Untitled show',
      image: map['image'] as String? ?? '',
      rating: (ratingValue as num?)?.toDouble(),
      genres:
          (map['genres'] as List<dynamic>?)?.whereType<String>().toList() ??
          const [],
      summary: map['summary'] as String? ?? '',
    );
  }
}
