class AppConstants {
  // TMDB API related constants
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String tmdbPosterSize = 'w500';
  static const String tmdbBackdropSize = 'w1280';
  
  // Full URLs for different image types
  static String getPosterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$tmdbImageBaseUrl$tmdbPosterSize$path';
  }
  
  static String getBackdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$tmdbImageBaseUrl$tmdbBackdropSize$path';
  }
}
