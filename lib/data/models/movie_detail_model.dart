import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/movie_detail.dart';

part 'movie_detail_model.g.dart';

@JsonSerializable()
class MovieDetailModel {
  final int id;
  final String title;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  final String overview;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  final String tagline;
  final int runtime;
  final String status;
  final int budget;
  final int revenue;
  final List<GenreModel> genres;
  @JsonKey(name: 'production_companies')
  final List<ProductionCompanyModel> productionCompanies;
  @JsonKey(name: 'production_countries')
  final List<ProductionCountryModel> productionCountries;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.tagline = '',
    this.runtime = 0,
    this.status = '',
    this.budget = 0,
    this.revenue = 0,
    this.genres = const [],
    this.productionCompanies = const [],
    this.productionCountries = const [],
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) => _$MovieDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);

  MovieDetail toDomain({bool isBookmarked = false}) {
    return MovieDetail(
      id: id,
      title: title,
      originalTitle: originalTitle,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      tagline: tagline,
      runtime: runtime,
      status: status,
      budget: budget,
      revenue: revenue,
      genres: genres.map((e) => e.toDomain()).toList(),
      productionCompanies: productionCompanies.map((e) => e.toDomain()).toList(),
      productionCountries: productionCountries.map((e) => e.toDomain()).toList(),
      isBookmarked: isBookmarked,
    );
  }
}

@JsonSerializable()
class GenreModel {
  final int id;
  final String name;

  GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) => _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  Genre toDomain() {
    return Genre(
      id: id,
      name: name,
    );
  }
}

@JsonSerializable()
class ProductionCompanyModel {
  final int id;
  final String name;
  @JsonKey(name: 'logo_path')
  final String? logoPath;
  @JsonKey(name: 'origin_country')
  final String originCountry;

  ProductionCompanyModel({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) => _$ProductionCompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompanyModelToJson(this);

  ProductionCompany toDomain() {
    return ProductionCompany(
      id: id,
      name: name,
      logoPath: logoPath,
      originCountry: originCountry,
    );
  }
}

@JsonSerializable()
class ProductionCountryModel {
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;

  ProductionCountryModel({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountryModel.fromJson(Map<String, dynamic> json) => _$ProductionCountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCountryModelToJson(this);

  ProductionCountry toDomain() {
    return ProductionCountry(
      iso31661: iso31661,
      name: name,
    );
  }
}
