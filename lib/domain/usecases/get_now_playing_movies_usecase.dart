import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../entities/movie.dart';
import '../local_storage_exception.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

@injectable
class GetNowPlayingMoviesUseCase implements UseCase<List<Movie>, PageParams> {
  final MovieRepository _repository;

  GetNowPlayingMoviesUseCase(this._repository);

  @override
  Future<Either<LocalStorageException, List<Movie>>> call(PageParams params) {
    return _repository.getNowPlayingMovies(page: params.page);
  }
}

class PageParams extends Equatable {
  final int page;

  const PageParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}
