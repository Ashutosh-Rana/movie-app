part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchQueryChangedEvent extends SearchEvent {
  final String query;

  const SearchQueryChangedEvent({required this.query});

  @override
  List<Object> get props => [query];
}

final class LoadMoreSearchResultsEvent extends SearchEvent {
  const LoadMoreSearchResultsEvent();
}

final class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}
