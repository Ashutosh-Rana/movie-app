import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/enums.dart';
import 'package:movies_app/domain/entities/app_error.dart';

import '../../../domain/entities/movie_detail.dart';
import '../../../domain/usecases/bookmark_usecases.dart';
import '../../../domain/usecases/get_movie_detail_usecase.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

@injectable
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  final IsMovieBookmarkedUseCase _isMovieBookmarkedUseCase;

  MovieDetailBloc(
    this._getMovieDetailUseCase,
    this._toggleBookmarkUseCase,
    this._isMovieBookmarkedUseCase,
  ) : super(const MovieDetailInitialState()) {
    on<LoadMovieDetailEvent>(_onLoadMovieDetail);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    try {
      emit(const MovieDetailLoadingState());

      final result = await _getMovieDetailUseCase(MovieParams(event.movieId));
      // Handle failure case for movie details
      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        emit(
          MovieDetailErrorState(
            error: failure ?? AppError(type: AppErrorType.unknown),
          ),
        );
        return;
      }

      // Extract movie detail data
      final movieDetail = result.fold((l) => null, (r) => r);
      if (movieDetail == null) {
        emit(
          MovieDetailErrorState(error: AppError(type: AppErrorType.unknown)),
        );
        return;
      }

      // Check if movie is bookmarked
      final isBookmarkedResult = await _isMovieBookmarkedUseCase(
        movieDetail.id,
      );

      // Extract bookmarked status
      final isBookmarked = isBookmarkedResult.fold(
        (error) => false,
        (value) => value,
      );

      // Check if we can still emit
      if (!emit.isDone) {
        emit(
          MovieDetailLoadedState(
            movieDetail: movieDetail,
            isBookmarked: isBookmarked,
          ),
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(MovieDetailErrorState(error: _unknownError()));
      }
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    final currentState = state;

    if (currentState is MovieDetailLoadedState) {
      try {
        // Convert the MovieDetail to a Movie object for bookmarking
        final movie = currentState.movieDetail.toMovie();

        // Pass the Movie object to the toggle bookmark use case
        final result = await _toggleBookmarkUseCase(movie);

        // Check if we can still emit
        if (emit.isDone) return;

        if (result.isLeft()) {
          // Handle failure case
          final failure = result.fold((l) => l, (r) => null);
          emit(MovieDetailErrorState(error: failure ?? _unknownError()));
        } else {
          // Extract the bookmarked status
          final isBookmarked = result.fold((l) => false, (r) => r);

          // Update the isBookmarked flag directly in the state
          emit(currentState.copyWith(isBookmarked: isBookmarked));
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(MovieDetailErrorState(error: _unknownError()));
        }
      }
    }
  }

  AppError _unknownError() {
    return AppError(
      type: AppErrorType.unknown,
      error: 'An unexpected error occurred',
    );
  }
}
