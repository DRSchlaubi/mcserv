import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

Dio makeDio(Logger log) {
  final dio = Dio();

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
