import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

Dio makeDio(Logger log) {
  var dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
    log.fine('${request.method} => ${request.uri.toString()}');

    handler.next(request);
  }));

  return dio;
}
