import 'package:isar/isar.dart';

part 'movie.g.dart';

@collection
class Movie {
  Id get isarId => id.hashCode;

  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final int voteCount;
  final bool adult;
  final List<int> genreIds;
  final bool isBookmarked;
  final DateTime? cachedAt;

  const Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount = 0,
    this.adult = false,
    this.genreIds = const [],
    this.isBookmarked = false,
    this.cachedAt,
  });

  String get fullPosterPath =>
      posterPath != null
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : 'https://via.placeholder.com/500x750?text=No+Image';

  String get fullBackdropPath =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w780$backdropPath'
          : 'https://via.placeholder.com/780x439?text=No+Image';

  Movie copyWith({
    int? id,
    String? title,
    String? originalTitle,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    bool? adult,
    List<int>? genreIds,
    bool? isBookmarked,
    DateTime? cachedAt,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      adult: adult ?? this.adult,
      genreIds: genreIds ?? this.genreIds,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
