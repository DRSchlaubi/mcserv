import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

final _dioCache = <Dio>[];

void closeDio() {
  for (var dio in _dioCache) {
    dio.close();
  }
}

Dio makeDio(Logger log) {
  final dio = Dio();
  _dioCache.add(dio);

  dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
    log.fine('${request.method} => ${request.uri.toString()}');

    handler.next(request);
  }, onError: (error, handler) {
    final request = error.requestOptions;
    log.severe(
        'Could not fulfill http request to ${request.method} => ${request.uri}: ${error.response?.data}');

    handler.next(error);
  }));

  return dio;
}
