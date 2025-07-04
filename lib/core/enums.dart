enum AppErrorType {
  api(sentryCategory: 'api.error'),
  network(sentryCategory: 'network.error'),
  timeout(sentryCategory: 'timeout.error'),
  unknown(sentryCategory: 'unknown.error'),
  localStorage(sentryCategory: 'localStorage.error'),
  networkCommand(sentryCategory: 'networkCommand.error');

  final String sentryCategory;

  const AppErrorType({required this.sentryCategory});
}

enum ApiMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  final String value;

  const ApiMethod(this.value);
}
