part of 'movie_detail_bloc.dart';

sealed class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  
  @override
  List<Object> get props => [];
}

final class LoadMovieDetailEvent extends MovieDetailEvent {
  final int movieId;
  
  const LoadMovieDetailEvent({required this.movieId});
  
  @override
  List<Object> get props => [movieId];
}

final class ToggleBookmarkEvent extends MovieDetailEvent {
  final int movieId;
  
  const ToggleBookmarkEvent({required this.movieId});
  
  @override
  List<Object> get props => [movieId];
}
