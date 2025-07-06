import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../di/get_it.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../blocs/movie_detail/movie_detail_bloc.dart';
import '../../widgets/movie_loading_indicator.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    // TODO: refactor bloc provider
    return BlocProvider(
      create:
          (_) =>
              getIt<MovieDetailBloc>()
                ..add(LoadMovieDetailEvent(movieId: movieId)),
      child: Scaffold(
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoadingState) {
              return const Center(child: MovieLoadingIndicator());
            } else if (state is MovieDetailLoadedState) {
              return _buildMovieDetail(
                context,
                state.movieDetail,
                state.isBookmarked,
              );
            } else if (state is MovieDetailErrorState) {
              return _buildErrorView(context, state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetail(
    BuildContext context,
    MovieDetail movie,
    bool isBookmarked,
  ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300.0,
          floating: false,
          pinned: true,
          leading: IconButton(
            iconSize: 24,
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: AppConstants.getPosterUrl(movie.posterPath),
                  fit: BoxFit.fill,
                  errorWidget:
                      (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 300.0, // Same as expandedHeight
                        color: Colors.grey[800],
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.white70,
                        ),
                      ),
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) => Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                ),
                // Gradient overlay for better text visibility
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              iconSize: 24,
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.amber : Colors.black,
              ),
              onPressed: () {
                context.read<MovieDetailBloc>().add(
                  ToggleBookmarkEvent(movieId: movie.id),
                );
              },
            ),
            SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage?.toStringAsFixed(1) ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children:
                      movie.genres
                          .map(
                            (genre) => Chip(
                              label: Text(
                                genre.name ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.blueGrey[800],
                              labelStyle: const TextStyle(color: Colors.white),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.all(0),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                if (movie.originalTitle.isNotEmpty)
                  _buildInfoRow('Original Title', movie.originalTitle),
                _buildInfoRow('Release Date', movie.releaseDate ?? ''),
                _buildInfoRow('Runtime', '${movie.runtime} min'),
                _buildInfoRow('Status', movie.status),
                _buildInfoRow('Adult', movie.adult ? 'Yes' : 'No'),
                _buildInfoRow('Tagline', movie.tagline),
                _buildInfoRow(
                  'Vote Average',
                  movie.voteAverage?.toStringAsFixed(2) ?? '',
                ),
                _buildInfoRow('Vote Count', movie.voteCount.toString()),
                _buildInfoRow(
                  'Budget',
                  movie.budget != 0
                      ? '\$${_formatCurrency(movie.budget)}'
                      : 'N/A',
                ),
                _buildInfoRow(
                  'Revenue',
                  movie.revenue != 0
                      ? '\$${_formatCurrency(movie.revenue)}'
                      : 'N/A',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty && value != '0' ? value : 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
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
              context.read<MovieDetailBloc>().add(
                LoadMovieDetailEvent(movieId: movieId),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String? _formatCurrency(int amount) {
    if (amount == 0) return null;

    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toString();
    }
  }
}
