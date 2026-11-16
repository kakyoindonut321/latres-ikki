class ShowModel {
  final int id;
  final String name;
  final double? rating;
  final String? imageUrl;
  final List<String> genres;
  final String summary;

  ShowModel({
    required this.id,
    required this.name,
    this.rating,
    this.imageUrl,
    required this.genres,
    required this.summary,
  });

  // Dari JSON API TVMaze -> objek ShowModel
  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'],
      name: json['name'] ?? '-',
      rating: (json['rating']?['average'] as num?)?.toDouble(),
      imageUrl: json['image']?['medium'],
      genres: List<String>.from(json['genres'] ?? []),
      summary: _stripHtml(json['summary'] ?? ''),
    );
  }

  // Dari Map Hive -> objek ShowModel
  factory ShowModel.fromMap(Map map) {
    return ShowModel(
      id: map['id'],
      name: map['name'],
      rating: map['rating'],
      imageUrl: map['imageUrl'],
      genres: List<String>.from(map['genres']),
      summary: map['summary'],
    );
  }

  // Objek -> Map, supaya bisa disimpan di Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'imageUrl': imageUrl,
      'genres': genres,
      'summary': summary,
    };
  }

  // Summary dari API berisi tag HTML (<p>, <b>), kita bersihkan
  static String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}