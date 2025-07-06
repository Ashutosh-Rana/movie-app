import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import 'movie.dart';

part 'movie_detail.g.dart';

@collection
class MovieDetail {
  Id get isarId => id.hashCode;

  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  final bool adult;
  final String tagline;
  final int runtime;
  final String status;
  final int budget;
  final int revenue;
  final List<Genre> genres;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final bool isBookmarked;

  const MovieDetail({
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
    this.tagline = '',
    this.runtime = 0,
    this.status = '',
    this.budget = 0,
    this.revenue = 0,
    this.genres = const [],
    this.productionCompanies = const [],
    this.productionCountries = const [],
    this.isBookmarked = false,
  });

  String get fullPosterPath =>
      posterPath != null
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : 'https://via.placeholder.com/500x750?text=No+Image';

  String get fullBackdropPath =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w780$backdropPath'
          : 'https://via.placeholder.com/780x439?text=No+Image';

  // Convert MovieDetail to a Movie object for bookmark operations
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      adult: adult,
      genreIds: genres.map((genre) => genre.id ?? 0).toList(),
      isBookmarked: isBookmarked,
      cachedAt: DateTime.now(),
    );
  }

  MovieDetail copyWith({
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
    String? tagline,
    int? runtime,
    String? status,
    int? budget,
    int? revenue,
    List<Genre>? genres,
    List<ProductionCompany>? productionCompanies,
    List<ProductionCountry>? productionCountries,
    bool? isBookmarked,
  }) {
    return MovieDetail(
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
      tagline: tagline ?? this.tagline,
      runtime: runtime ?? this.runtime,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      genres: genres ?? this.genres,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

@embedded
class Genre {
  final int? id;
  final String? name;

  const Genre({this.id, this.name});
}

@embedded
class ProductionCompany {
  final int? id;
  final String? name;
  final String? logoPath;
  final String? originCountry;

  const ProductionCompany({
    this.id,
    this.name,
    this.logoPath,
    this.originCountry,
  });

  String get fullLogoPath =>
      logoPath != null
          ? 'https://image.tmdb.org/t/p/w200$logoPath'
          : 'https://via.placeholder.com/200x200?text=No+Logo';
}

@embedded
class ProductionCountry {
  final String? iso31661;
  final String? name;

  const ProductionCountry({this.iso31661, this.name});
}
