part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitialState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {
  final List<Movie> trendingMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> bookmarkedMovies;

  // Now playing pagination
  final int nowPlayingCurrentPage;
  final bool nowPlayingHasReachedEnd;
  final bool isLoadingMoreNowPlaying;

  // Trending pagination
  final int trendingCurrentPage;
  final bool trendingHasReachedEnd;
  final bool isLoadingMoreTrending;

  final String? loadMoreError;

  const HomeLoadedState({
    required this.trendingMovies,
    required this.nowPlayingMovies,
    this.bookmarkedMovies = const [],
    this.nowPlayingCurrentPage = 1,
    this.nowPlayingHasReachedEnd = false,
    this.isLoadingMoreNowPlaying = false,
    this.trendingCurrentPage = 1,
    this.trendingHasReachedEnd = false,
    this.isLoadingMoreTrending = false,
    this.loadMoreError,
  });

  HomeLoadedState copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? bookmarkedMovies,
    int? nowPlayingCurrentPage,
    bool? nowPlayingHasReachedEnd,
    bool? isLoadingMoreNowPlaying,
    int? trendingCurrentPage,
    bool? trendingHasReachedEnd,
    bool? isLoadingMoreTrending,
    String? loadMoreError,
  }) {
    return HomeLoadedState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      bookmarkedMovies: bookmarkedMovies ?? this.bookmarkedMovies,
      nowPlayingCurrentPage:
          nowPlayingCurrentPage ?? this.nowPlayingCurrentPage,
      nowPlayingHasReachedEnd:
          nowPlayingHasReachedEnd ?? this.nowPlayingHasReachedEnd,
      isLoadingMoreNowPlaying:
          isLoadingMoreNowPlaying ?? this.isLoadingMoreNowPlaying,
      trendingCurrentPage: trendingCurrentPage ?? this.trendingCurrentPage,
      trendingHasReachedEnd:
          trendingHasReachedEnd ?? this.trendingHasReachedEnd,
      isLoadingMoreTrending:
          isLoadingMoreTrending ?? this.isLoadingMoreTrending,
      loadMoreError: loadMoreError ?? this.loadMoreError,
    );
  }

  @override
  List<Object> get props => [
    trendingMovies,
    nowPlayingMovies,
    bookmarkedMovies,
    nowPlayingCurrentPage,
    nowPlayingHasReachedEnd,
    isLoadingMoreNowPlaying,
    trendingCurrentPage,
    trendingHasReachedEnd,
    isLoadingMoreTrending,
  ];

  // Note: loadMoreError is intentionally not included in props because it's nullable
  // and can't be added to a List<Object>. We could use List<Object?> but that would
  // require changing the Equatable interface across all states.
}

final class HomeErrorState extends HomeState {
  final AppError error;

  const HomeErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
