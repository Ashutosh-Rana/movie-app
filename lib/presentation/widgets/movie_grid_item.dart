import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/movie.dart';

class MovieGridItem extends StatelessWidget {
  final Movie? movie;
  final VoidCallback? onTap;
  final bool isLoading;

  const MovieGridItem({super.key, required this.movie, this.onTap})
    : isLoading = false;

  const MovieGridItem.loading({super.key})
    : movie = null,
      onTap = null,
      isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingShimmer();
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: _buildPosterImage()),
            // Reduced padding and increased content area
            SizedBox(
              height: 50, // Fixed height instead of Expanded
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Use minimum space needed
                  children: [
                    Text(
                      movie!.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // Reduced font size
                      ),
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 12,
                        ), // Smaller icon
                        const SizedBox(width: 2),
                        Text(
                          movie?.voteAverage != null
                              ? movie!.voteAverage!.toStringAsFixed(1)
                              : '0.0',
                          style: const TextStyle(
                            fontSize: 10, // Smaller text
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    final posterPath = movie?.posterPath;
    if (posterPath == null || posterPath.isEmpty) {
      return Container(
        color: Colors.grey[850],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.white54,
            size: 32,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: AppConstants.getPosterUrl(posterPath),
      fit: BoxFit.cover,
      errorWidget:
          (context, error, stackTrace) => Container(
            color: Colors.grey[850],
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.white54, size: 32),
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
    );
  }

  Widget _buildLoadingShimmer() {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 4, child: Container(color: Colors.white)),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(height: 12, width: 80, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
