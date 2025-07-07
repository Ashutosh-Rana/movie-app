import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/presentation/routes/route_arguments.dart';
import 'package:movies_app/presentation/routes/routes.dart';

import '../../../domain/entities/movie.dart';
import '../../blocs/search/search_bloc.dart';
import '../../widgets/movie_grid_item.dart';
import '../../widgets/movie_loading_indicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isCurrentlyVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're returning to this screen with existing search text
    if (_isCurrentlyVisible && _searchController.text.isNotEmpty) {
      // Re-trigger the search to restore results
      context.read<SearchBloc>().add(
        SearchQueryChangedEvent(query: _searchController.text),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isCurrentlyVisible = state == AppLifecycleState.resumed;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final searchState = context.read<SearchBloc>().state;
      if (searchState is SearchLoadedState &&
          !searchState.isLoadingMore &&
          !searchState.hasReachedEnd) {
        context.read<SearchBloc>().add(LoadMoreSearchResultsEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.done,
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Search for movies...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchBloc>().add(ClearSearchEvent());
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (query) {
                  context.read<SearchBloc>().add(
                    SearchQueryChangedEvent(query: query),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return _buildSearchResults(state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    if (state is SearchInitialState) {
      return const Center(
        child: Text(
          'Search for your favorite movies',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    } else if (state is SearchLoadingState) {
      return const Center(child: MovieLoadingIndicator());
    } else if (state is SearchEmptyState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No results found for "${state.query}"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    } else if (state is SearchErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error.error}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  context.read<SearchBloc>().add(
                    SearchQueryChangedEvent(query: _searchController.text),
                  );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is SearchLoadedState) {
      return _buildMovieGrid(state.movies, state.isLoadingMore);
    }
    return const SizedBox.shrink();
  }

  Widget _buildMovieGrid(List<Movie> movies, bool isLoadingMore) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: isLoadingMore ? movies.length + 4 : movies.length,
      itemBuilder: (context, index) {
        if (index >= movies.length) {
          // Show shimmer loading placeholders
          return const MovieGridItem.loading();
        }

        final movie = movies[index];
        return MovieGridItem(
          movie: movie,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.movieDetail,
              arguments: MovieDetailScreenArgs(movieId: movie.id),
            );
          },
        );
      },
    );
  }
}
