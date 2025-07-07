import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/typedefs.dart';

import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

@injectable
class SearchMoviesUseCase implements UseCase<List<Movie>, SearchParams> {
  final MovieRepository _repository;

  SearchMoviesUseCase(this._repository);

  @override
  FutureEither<List<Movie>> call(SearchParams params) {
    return _repository.searchMovies(params.query, page: params.page);
  }
}

class SearchParams extends Equatable {
  final String query;
  final int page;

  const SearchParams(this.query, {this.page = 1});

  @override
  List<Object?> get props => [query, page];
}
