import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies_usecase.dart';
import '../../../domain/usecases/get_trending_movies_usecase.dart';
import '../../../domain/usecases/bookmark_usecases.dart';
import '../../../domain/usecases/usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrendingMoviesUseCase _getTrendingMoviesUseCase;
  final GetNowPlayingMoviesUseCase _getNowPlayingMoviesUseCase;
  final GetBookmarkedMoviesUseCase _getBookmarkedMoviesUseCase;

  HomeBloc(
    this._getTrendingMoviesUseCase, 
    this._getNowPlayingMoviesUseCase,
    this._getBookmarkedMoviesUseCase
  ) : super(HomeInitialState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<LoadMoreNowPlayingMoviesEvent>(_onLoadMoreNowPlayingMovies);
    on<LoadMoreTrendingMoviesEvent>(_onLoadMoreTrendingMovies);
    on<LoadBookmarkedMoviesEvent>(_onLoadBookmarkedMovies);
  }
  
  Future<void> _onLoadBookmarkedMovies(
    LoadBookmarkedMoviesEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoadedState) {
      try {
        // Get bookmarked movies
        final result = await _getBookmarkedMoviesUseCase(NoParams());
        
        if (result.isLeft()) {
          final failure = result.fold((l) => l, (r) => null);
          // Just log the error, don't change state to error
          print('Failed to load bookmarked movies: ${failure?.message}');
          return;
        }
        
        // Extract bookmarked movies
        final bookmarkedMovies = result.fold((l) => <Movie>[], (r) => r);
        
        // Update state with bookmarked movies
        emit(currentState.copyWith(bookmarkedMovies: bookmarkedMovies));
      } catch (e) {
        print('An unexpected error occurred while loading bookmarked movies: $e');
      }
    }
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());

    try {
      // Get trending movies with page 1
      final trendingResult = await _getTrendingMoviesUseCase(
        const PageParams(page: 1),
      );

      // Handle failure case for trending movies
      if (trendingResult.isLeft()) {
        final failure = trendingResult.fold((failure) => failure, (r) => null);
        emit(
          HomeErrorState(
            message: 'Failed to load trending movies: ${failure?.message}',
          ),
        );
        return;
      }

      // Extract trending movies data
      final trendingMovies = trendingResult.fold((l) => <Movie>[], (r) => r);

      // Get now playing movies with page 1
      final nowPlayingResult = await _getNowPlayingMoviesUseCase(
        const PageParams(page: 1),
      );

      // Handle failure case for now playing movies
      if (nowPlayingResult.isLeft()) {
        final failure = nowPlayingResult.fold((l) => l, (r) => null);
        emit(
          HomeErrorState(
            message: 'Failed to load now playing movies: ${failure?.message}',
          ),
        );
        return;
      }

      // Extract now playing movies
      final nowPlayingMovies = nowPlayingResult.fold((l) => <Movie>[], (r) => r);

      // Get bookmarked movies
      final bookmarkedResult = await _getBookmarkedMoviesUseCase(NoParams());
      final bookmarkedMovies = bookmarkedResult.fold((l) => <Movie>[], (r) => r);

      // Create loaded state
      emit(
        HomeLoadedState(
          trendingMovies: trendingMovies,
          nowPlayingMovies: nowPlayingMovies,
          bookmarkedMovies: bookmarkedMovies,
          nowPlayingCurrentPage: 1,
          nowPlayingHasReachedEnd: nowPlayingMovies.length < 20,
          trendingCurrentPage: 1,
          trendingHasReachedEnd: trendingMovies.length < 20,
        ),
      );
    } catch (e) {
      emit(HomeErrorState(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Get trending movies with page 1
      final trendingResult = await _getTrendingMoviesUseCase(
        const PageParams(page: 1),
      );

      // Handle failure case for trending movies
      if (trendingResult.isLeft()) {
        final failure = trendingResult.fold(
          (l) => l,
          (r) => null,
        );
        emit(
          HomeErrorState(message: 'Failed to refresh: ${failure?.message}'),
        );
        return;
      }

      // Extract trending movies data
      final trendingMovies = trendingResult.fold((l) => <Movie>[], (r) => r);

      // Get now playing movies with page 1
      final nowPlayingResult = await _getNowPlayingMoviesUseCase(
        const PageParams(page: 1),
      );

      // Handle failure case for now playing movies
      if (nowPlayingResult.isLeft()) {
        final failure = nowPlayingResult.fold(
          (l) => l,
          (r) => null,
        );
        emit(
          HomeErrorState(message: 'Failed to refresh: ${failure?.message}'),
        );
        return;
      }

      // Get bookmarked movies
      final bookmarkedResult = await _getBookmarkedMoviesUseCase(NoParams());
      final bookmarkedMovies = bookmarkedResult.fold((l) => <Movie>[], (r) => r);

      // Extract now playing movies and emit success state
      final nowPlayingMovies = nowPlayingResult.fold(
        (l) => <Movie>[],
        (r) => r,
      );

      // Create loaded state
      emit(
        HomeLoadedState(
          trendingMovies: trendingMovies,
          nowPlayingMovies: nowPlayingMovies,
          bookmarkedMovies: bookmarkedMovies,
          nowPlayingCurrentPage: 1,
          nowPlayingHasReachedEnd: nowPlayingMovies.length < 20,
          trendingCurrentPage: 1,
          trendingHasReachedEnd: trendingMovies.length < 20,
        ),
      );
    } catch (e) {
      emit(
        HomeErrorState(
          message: 'An unexpected error occurred during refresh: $e',
        ),
      );
    }
  }

  Future<void> _onLoadMoreNowPlayingMovies(
    LoadMoreNowPlayingMoviesEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoadedState &&
        !currentState.isLoadingMoreNowPlaying &&
        !currentState.nowPlayingHasReachedEnd) {
      // Update state to show loading more indicator
      emit(currentState.copyWith(isLoadingMoreNowPlaying: true));

      try {
        final nextPage = currentState.nowPlayingCurrentPage + 1;
        final result = await _getNowPlayingMoviesUseCase(
          PageParams(page: nextPage),
        );

        if (result.isLeft()) {
          // Handle error case
          final failure = result.fold((l) => l, (r) => null);
          if (!emit.isDone) {
            emit(
              currentState.copyWith(
                isLoadingMoreNowPlaying: false,
                loadMoreError:
                    'Failed to load more now playing movies: ${failure?.message}',
              ),
            );
          }
          return;
        }

        // Extract movies data
        final newMovies = result.fold((l) => <Movie>[], (r) => r);

        if (newMovies.isEmpty) {
          if (!emit.isDone) {
            emit(
              currentState.copyWith(
                isLoadingMoreNowPlaying: false,
                nowPlayingHasReachedEnd: true,
              ),
            );
          }
        } else {
          if (!emit.isDone) {
            // Check if reached end of data
            final hasReachedEnd = newMovies.length < 20;

            // Append new movies to existing list
            final updatedMovies = List<Movie>.from(currentState.nowPlayingMovies)
              ..addAll(newMovies);

            // Update state with new data
            emit(
              currentState.copyWith(
                nowPlayingMovies: updatedMovies,
                nowPlayingCurrentPage: nextPage,
                isLoadingMoreNowPlaying: false,
                nowPlayingHasReachedEnd: hasReachedEnd,
              ),
            );
          }
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(
            currentState.copyWith(
              isLoadingMoreNowPlaying: false,
              loadMoreError:
                  'An unexpected error occurred while loading now playing movies: $e',
            ),
          );
        }
      }
    }
  }

  Future<void> _onLoadMoreTrendingMovies(
    LoadMoreTrendingMoviesEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoadedState &&
        !currentState.isLoadingMoreTrending &&
        !currentState.trendingHasReachedEnd) {
      // Update state to show loading more indicator
      emit(currentState.copyWith(isLoadingMoreTrending: true));

      try {
        final nextPage = currentState.trendingCurrentPage + 1;
        final result = await _getTrendingMoviesUseCase(
          PageParams(page: nextPage),
        );

        if (result.isLeft()) {
          // Handle error case
          final failure = result.fold((l) => l, (r) => null);
          if (!emit.isDone) {
            emit(
              currentState.copyWith(
                isLoadingMoreTrending: false,
                loadMoreError:
                    'Failed to load more trending movies: ${failure?.message}',
              ),
            );
          }
          return;
        }

        // Extract movies data
        final newMovies = result.fold((l) => <Movie>[], (r) => r);

        if (newMovies.isEmpty) {
          if (!emit.isDone) {
            emit(
              currentState.copyWith(
                isLoadingMoreTrending: false,
                trendingHasReachedEnd: true,
              ),
            );
          }
        } else {
          if (!emit.isDone) {
            // Check if reached end of data
            final hasReachedEnd = newMovies.length < 20;

            // Append new movies to existing list
            final updatedMovies = List<Movie>.from(currentState.trendingMovies)
              ..addAll(newMovies);

            // Update state with new data
            emit(
              currentState.copyWith(
                trendingMovies: updatedMovies,
                trendingCurrentPage: nextPage,
                isLoadingMoreTrending: false,
                trendingHasReachedEnd: hasReachedEnd,
              ),
            );
          }
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(
            currentState.copyWith(
              isLoadingMoreTrending: false,
              loadMoreError:
                  'An unexpected error occurred while loading trending movies: $e',
            ),
          );
        }
      }
    }
  }
}
