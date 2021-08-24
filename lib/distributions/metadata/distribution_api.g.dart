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
  Future<DistributionMetaData> getDistributionMetaData(type) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DistributionMetaData>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/$type.json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DistributionMetaData.fromJson(_result.data!);
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
