class ShowModel {
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
    };
  }

  factory ShowModel.fromMap(Map<String, dynamic> map) {
    final ratingValue = map['rating'];
    return ShowModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name'] as String? ?? 'Untitled show',
      image: map['image'] as String? ?? '',
      rating: (ratingValue as num?)?.toDouble(),
      genres: (map['genres'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      summary: map['summary'] as String? ?? '',
    );
  }
}
