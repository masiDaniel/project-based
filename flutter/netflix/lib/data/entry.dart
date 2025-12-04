class Entry {
  final String id;
  final String name;
  final String? description;
  final String ageRestriction;
  final Duration durationMinutes;
  final String thumbnailImageId;
  final String genres;
  final String tags;
  final DateTime? netflixReleaseDate;
  final DateTime? releaseDate;
  final double trendingIndex;
  final bool isOriginal;
  final String cast;

  bool isEmpty() {
    if (id.isEmpty || name.isEmpty) {
      return true;
    }
    return false;
  }

  Entry({
    required this.id,
    required this.name,
    this.description,
    required this.ageRestriction,
    required this.durationMinutes,
    required this.thumbnailImageId,
    required this.genres,
    required this.tags,
    this.netflixReleaseDate,
    this.releaseDate,
    required this.trendingIndex,
    required this.isOriginal,
    required this.cast,
  });

  static Entry empty() {
    return Entry(
      id: '',
      name: '',
      description: '',
      ageRestriction: '',
      durationMinutes: const Duration(minutes: -4),
      thumbnailImageId: '',
      genres: '',
      tags: '',
      trendingIndex: -1,
      isOriginal: false,
      cast: '',
    );
  }

  static Entry fromJson(Map<String, dynamic> data) {
    return Entry(
      id: data['\$id'],
      name: data['name'],
      description: data['description'],
      ageRestriction: data['ageRestriction'],
      durationMinutes: Duration(
        minutes:
            int.tryParse(data['durationMinutes']?.toString() ?? '-1') ?? -1,
      ),
      thumbnailImageId: data['thumbnailimageid'],
      genres: (data['genres'] as List<dynamic>).join(', '),
      tags: (data['tags'] as List<dynamic>).join(', '),
      releaseDate: data['releaseDate'] != null
          ? DateTime.tryParse(data['releaseDate'])
          : null,
      netflixReleaseDate: data['netflixReleaseDate'] != null
          ? DateTime.tryParse(data['netflixReleaseDate'])
          : null,
      trendingIndex: data['trendingIndex'],
      isOriginal: data['isOriginal'],
      cast: (data['cast'] as List<dynamic>).join(', '),
    );
  }

  @override
  String toString() {
    return 'Entry('
        'id: $id, '
        'name: $name, '
        'description: ${description ?? "N/A"}, '
        'ageRestriction: $ageRestriction, '
        'durationMinutes: ${durationMinutes.inMinutes}, '
        'thumbnailImageId: $thumbnailImageId, '
        'genres: $genres, '
        'tags: $tags, '
        'netflixReleaseDate: ${netflixReleaseDate ?? "N/A"}, '
        'releaseDate: ${releaseDate ?? "N/A"}, '
        'trendingIndex: $trendingIndex, '
        'isOriginal: $isOriginal, '
        'cast: $cast'
        ')';
  }
}
