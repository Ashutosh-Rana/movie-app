import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/movie.dart';
import '../../blocs/home/home_bloc.dart';
import '../../navigation/route_observer.dart';
import '../../widgets/movie_grid_item.dart';
import '../../widgets/movie_loading_indicator.dart';
import '../movie_detail/movie_detail_screen.dart';

part 'parts/bookmarked_movie_section.dart';
part 'parts/now_playing_movie_section.dart';
part 'parts/trending_movie_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, RouteAware {
  final ScrollController _nowPlayingScrollController = ScrollController();
  final ScrollController _trendingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nowPlayingScrollController.addListener(_onNowPlayingScroll);
    _trendingScrollController.addListener(_onTrendingScroll);
    WidgetsBinding.instance.addObserver(this);

    // Load home data if not already loaded
    Future.microtask(() {
      context.read<HomeBloc>().add(LoadHomeDataEvent());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Register with the RouteObserver
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh bookmarked movies when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      context.read<HomeBloc>().add(LoadBookmarkedMoviesEvent());
    }
  }

  @override
  void dispose() {
    _nowPlayingScrollController.removeListener(_onNowPlayingScroll);
    _nowPlayingScrollController.dispose();
    _trendingScrollController.removeListener(_onTrendingScroll);
    _trendingScrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when the top route has been popped off, and the current route shows up
  @override
  void didPopNext() {
    // Update bookmarks when returning to this screen
    context.read<HomeBloc>().add(LoadBookmarkedMoviesEvent());

    // Dismiss keyboard when returning to home screen
    FocusScope.of(context).unfocus();
  }

  void _onNowPlayingScroll() {
    if (_nowPlayingScrollController.position.pixels >=
        _nowPlayingScrollController.position.maxScrollExtent - 200) {
      final homeState = context.read<HomeBloc>().state;
      if (homeState is HomeLoadedState &&
          !homeState.isLoadingMoreNowPlaying &&
          !homeState.nowPlayingHasReachedEnd) {
        context.read<HomeBloc>().add(LoadMoreNowPlayingMoviesEvent());
      }
    }
  }

  void _onTrendingScroll() {
    if (_trendingScrollController.position.pixels >=
        _trendingScrollController.position.maxScrollExtent - 200) {
      final homeState = context.read<HomeBloc>().state;
      if (homeState is HomeLoadedState &&
          !homeState.isLoadingMoreTrending &&
          !homeState.trendingHasReachedEnd) {
        context.read<HomeBloc>().add(LoadMoreTrendingMoviesEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(RefreshHomeDataEvent());
          // Wait for the refresh to complete
          await Future.delayed(const Duration(milliseconds: 1000));
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitialState || state is HomeLoadingState) {
              return const Center(child: MovieLoadingIndicator());
            } else if (state is HomeLoadedState) {
              return _buildHomeContent(state);
            } else if (state is HomeErrorState) {
              return _buildErrorView(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHomeContent(HomeLoadedState state) {
    return ListView(
      controller: _nowPlayingScrollController,
      // Dismiss keyboard when user scrolls
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      // Add padding at the bottom to ensure we can scroll past the last item
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _TrendingMovieSection(
          trendingMovies: state.trendingMovies,
          isLoadingMore: state.isLoadingMoreTrending,
          trendingScrollController: _trendingScrollController,
        ),
        // Display bookmarked movies section if there are any
        if (state.bookmarkedMovies.isNotEmpty)
          _BookmarkedMovieSection(bookmarkedMovies: state.bookmarkedMovies),
        _NowPlayingMovieSection(
          nowPlayingMovies: state.nowPlayingMovies,
          isLoadingMore: state.isLoadingMoreNowPlaying,
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(LoadHomeDataEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
