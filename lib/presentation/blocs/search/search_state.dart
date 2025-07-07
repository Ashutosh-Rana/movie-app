part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitialState extends SearchState {
  const SearchInitialState();
}

final class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

final class SearchLoadedState extends SearchState {
  final List<Movie> movies;
  final String query;
  final int currentPage;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final String? loadMoreError;

  const SearchLoadedState({
    required this.movies,
    required this.query,
    required this.currentPage,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  SearchLoadedState copyWith({
    List<Movie>? movies,
    String? query,
    int? currentPage,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    String? loadMoreError,
  }) {
    return SearchLoadedState(
      movies: movies ?? this.movies,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError ?? this.loadMoreError,
    );
  }

  @override
  List<Object> get props => [
    movies,
    query,
    currentPage,
    hasReachedEnd,
    isLoadingMore,
  ];

  // Note: loadMoreError is intentionally not included in props because it's nullable
  // and can't be added to a List<Object>. We could use List<Object?> but that would
  // require changing the Equatable interface across all states.
}

final class SearchErrorState extends SearchState {
  final AppError error;

  const SearchErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

final class SearchEmptyState extends SearchState {
  final String query;

  const SearchEmptyState({required this.query});

  @override
  List<Object> get props => [query];
}
