part of '../home_screen.dart';

class _BookmarkedMovieSection extends StatelessWidget {
  final List<Movie> bookmarkedMovies;

  const _BookmarkedMovieSection({required this.bookmarkedMovies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
          child: Text(
            'Bookmarked Movies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bookmarkedMovies.length,
            itemBuilder: (context, index) {
              final movie = bookmarkedMovies[index];
              return SizedBox(
                width: 150,
                child: MovieGridItem(
                  movie: movie,
                  // TODO: add arguments
                  onTap:
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
