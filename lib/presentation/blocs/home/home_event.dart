part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
  
  @override
  List<Object> get props => [];
}

final class LoadHomeDataEvent extends HomeEvent {}

final class RefreshHomeDataEvent extends HomeEvent {}

final class LoadMoreNowPlayingMoviesEvent extends HomeEvent {}

final class LoadMoreTrendingMoviesEvent extends HomeEvent {}

final class LoadBookmarkedMoviesEvent extends HomeEvent {}

