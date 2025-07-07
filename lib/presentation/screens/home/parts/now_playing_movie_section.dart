part of '../home_screen.dart';

class _NowPlayingMovieSection extends StatelessWidget {
  final List<Movie> nowPlayingMovies;
  final bool isLoadingMore;

  const _NowPlayingMovieSection({
    required this.nowPlayingMovies,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
          child: Text(
            'Now Playing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          // Remove controller from GridView as we're using it on the parent ListView
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              isLoadingMore
                  ? nowPlayingMovies.length + 2
                  : nowPlayingMovies.length,
          itemBuilder: (context, index) {
            if (index >= nowPlayingMovies.length) {
              // Show shimmer loading placeholders
              return const MovieGridItem.loading();
            }

            final movie = nowPlayingMovies[index];
            return MovieGridItem(
              movie: movie,
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    Routes.movieDetail,
                    arguments: MovieDetailScreenArgs(movieId: movie.id),
                  ),
            );
          },
        ),
      ],
    );
  }
}
