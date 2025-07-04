import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../logger.dart';

@lazySingleton
class MoviesBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logInfo('Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logInfo(
      '${bloc.runtimeType} Bloc changed from ${change.currentState.runtimeType} to ${change.nextState.runtimeType}',
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logInfo('Bloc closed: ${bloc.runtimeType}');
  }
}
