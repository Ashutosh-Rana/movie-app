import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../presentation/routes/route_arguments.dart';
import '../presentation/routes/routes.dart';

/// A service to handle deep links in the app
@lazySingleton
class DeepLinkHandler {
  static const String uriScheme = 'moviesapp';
  static const String moviePath = 'movie';

  bool _isInitialized = false;
  StreamSubscription? _linkSubscription;

  /// Initialize the deep link handler
  /// This should be called in the main.dart file
  Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;

    // Handle links that open the app
    try {
      final initialLink = await AppLinks().getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString(), context);
      }
    } on PlatformException {
      // Handle exception
      debugPrint('Failed to get initial deep link');
    }

    // Handle links when app is already running
    _linkSubscription = AppLinks().stringLinkStream.listen(
      (String? link) {
        if (link != null) {
          _handleDeepLink(link, context);
        }
      },
      onError: (error) {
        debugPrint('Deep link stream error: $error');
      },
    );

    _isInitialized = true;
  }

  /// Disposes the deep link handler
  void dispose() {
    _linkSubscription?.cancel();
  }

  /// Create a deep link for sharing a movie
  static String createMovieDeepLink(int movieId) {
    return '$uriScheme://$moviePath/$movieId';
  }

  /// Handle the deep link
  void _handleDeepLink(String link, BuildContext context) {
    debugPrint('Handling deep link: $link');
    final uri = Uri.parse(link);

    // Check if the scheme matches
    if (uri.scheme != uriScheme) return;

    // Handle movie deep links
    if (uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == moviePath &&
        uri.pathSegments.length > 1) {
      final movieIdStr = uri.pathSegments[1];
      try {
        final movieId = int.parse(movieIdStr);
        _navigateToMovie(context, movieId);
      } catch (e) {
        debugPrint('Invalid movie ID in deep link: $movieIdStr');
      }
    }
  }

  /// Navigate to a movie detail screen
  void _navigateToMovie(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed(
      Routes.movieDetail,
      arguments: MovieDetailScreenArgs(movieId: movieId),
    );
  }
}
