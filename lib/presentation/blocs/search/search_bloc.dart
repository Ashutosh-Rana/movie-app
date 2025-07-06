import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/search_movies_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMoviesUseCase _searchMoviesUseCase;

  // Debounce timer to prevent excessive API calls
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  SearchBloc(this._searchMoviesUseCase) : super(const SearchInitialState()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreSearchResults);
    on<ClearSearchEvent>(_onClearSearch);
  }

  // Completer to handle debounced search properly with Bloc
  Completer<void>? _searchCompleter;

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Cancel any pending completer
    if (_searchCompleter != null && !_searchCompleter!.isCompleted) {
      _searchCompleter!.complete();
    }
    _searchCompleter = Completer<void>();

    if (query.isEmpty) {
      emit(const SearchInitialState());
      return;
    }

    // Start loading state immediately to show progress
    emit(const SearchLoadingState());

    // Create a completer for this specific search operation
    final currentCompleter = _searchCompleter;

    // Use a completer to properly await the debounced operation
    try {
      // Set up the debounce timer
      _debounceTimer = Timer(_debounceDuration, () async {
        try {
          if (currentCompleter?.isCompleted == true) return;

          // Execute search
          final result = await _searchMoviesUseCase(SearchParams(query));

          // Check if this search operation is still valid
          if (currentCompleter?.isCompleted == true || emit.isDone) return;

          // Handle the result
          if (result.isLeft()) {
            final failure = result.fold((l) => l, (r) => null);
            emit(
              SearchErrorState(
                message: failure?.message ?? 'Something went wrong',
              ),
            );
          } else {
            final movies = result.fold((l) => <Movie>[], (r) => r);

            if (movies.isEmpty) {
              emit(SearchEmptyState(query: query));
            } else {
              emit(
                SearchLoadedState(
                  movies: movies,
                  query: query,
                  currentPage: 1,
                  hasReachedEnd:
                      movies.length < 20, // Assuming 20 is the page size
                ),
              );
            }
          }

          if (!currentCompleter!.isCompleted) {
            currentCompleter.complete();
          }
        } catch (e) {
          if (!emit.isDone && !currentCompleter!.isCompleted) {
            emit(SearchErrorState(message: 'Search error: $e'));
            currentCompleter.complete();
          }
        }
      });

      // Wait for the debounced operation to complete
      await currentCompleter!.future;
    } catch (e) {
      if (!emit.isDone) {
        emit(SearchErrorState(message: 'Unexpected error: $e'));
      }
    }
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResultsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is SearchLoadedState &&
        !currentState.isLoadingMore &&
        !currentState.hasReachedEnd) {
      // Update current state to show loading indicator
      emit(currentState.copyWith(isLoadingMore: true, loadMoreError: null));

      try {
        final nextPage = currentState.currentPage + 1;
        final result = await _searchMoviesUseCase(
          SearchParams(currentState.query, page: nextPage),
        );

        // Safety check to ensure we can still emit
        if (emit.isDone) return;

        if (result.isLeft()) {
          // Handle error case
          final failure = result.fold((l) => l, (r) => null);
          emit(
            currentState.copyWith(
              isLoadingMore: false,
              loadMoreError: failure?.message,
            ),
          );
          return;
        }

        // Extract movies data
        final newMovies = result.fold((l) => <Movie>[], (r) => r);

        if (newMovies.isEmpty) {
          emit(
            currentState.copyWith(isLoadingMore: false, hasReachedEnd: true),
          );
        } else {
          emit(
            currentState.copyWith(
              movies: [...currentState.movies, ...newMovies],
              currentPage: nextPage,
              isLoadingMore: false,
              hasReachedEnd:
                  newMovies.length < 20, // Assuming 20 is the page size
              loadMoreError: null,
            ),
          );
        }
      } catch (e) {
        // Only emit if the handler hasn't completed
        if (!emit.isDone) {
          emit(
            currentState.copyWith(
              isLoadingMore: false,
              loadMoreError: 'An unexpected error occurred: $e',
            ),
          );
        }
      }
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(const SearchInitialState());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
