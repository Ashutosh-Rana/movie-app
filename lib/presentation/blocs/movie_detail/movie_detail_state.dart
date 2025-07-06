part of 'movie_detail_bloc.dart';

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

final class MovieDetailInitialState extends MovieDetailState {
  const MovieDetailInitialState();
}

final class MovieDetailLoadingState extends MovieDetailState {
  const MovieDetailLoadingState();
}

final class MovieDetailLoadedState extends MovieDetailState {
  final MovieDetail movieDetail;
  final bool isBookmarked;

  const MovieDetailLoadedState({
    required this.movieDetail,
    this.isBookmarked = false,
  });

  MovieDetailLoadedState copyWith({
    MovieDetail? movieDetail,
    bool? isBookmarked,
  }) {
    return MovieDetailLoadedState(
      movieDetail: movieDetail ?? this.movieDetail,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object> get props => [movieDetail, isBookmarked];
}

final class MovieDetailErrorState extends MovieDetailState {
  final String message;

  const MovieDetailErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
