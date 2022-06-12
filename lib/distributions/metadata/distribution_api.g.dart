// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _DistributionMetaDataApi implements DistributionMetaDataApi {
  _DistributionMetaDataApi(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://github.com/DRSchlaubi/mcserv/raw/main/distributions/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<String?> _getDistributionMetaData(type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/${type}.json',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
