part of '../home_screen.dart';

class _TrendingMovieSection extends StatelessWidget {
  final List<Movie> trendingMovies;
  final bool isLoadingMore;
  final ScrollController trendingScrollController;

  const _TrendingMovieSection({
    required this.trendingMovies,
    this.isLoadingMore = false,
    required this.trendingScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Text(
            'Trending Movies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            controller: trendingScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingMovies.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the end when loading more
              if (isLoadingMore && index == trendingMovies.length) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: 150,
                    child: Center(child: MovieLoadingIndicator(size: 30)),
                  ),
                );
              }

              final movie = trendingMovies[index];
              return SizedBox(
                width: 150,
                child: MovieGridItem(
                  movie: movie,
                  onTap:
                      // TODO: add arguments
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MovieDetailScreen(movieId: movie.id),
                        ),
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
