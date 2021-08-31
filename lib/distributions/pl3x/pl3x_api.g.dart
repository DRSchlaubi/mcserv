// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pl3x_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pl3xProject _$Pl3xProjectFromJson(Map<String, dynamic> json) => Pl3xProject(
      json['project'] as String,
      (json['versions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$Pl3xProjectToJson(Pl3xProject instance) =>
    <String, dynamic>{
      'project': instance.project,
      'versions': instance.versions,
    };

Pl3xBuild _$Pl3xBuildFromJson(Map<String, dynamic> json) => Pl3xBuild(
      json['project'] as String,
      json['version'] as String,
      json['build'] as String,
      json['md5'] as String,
    );

Map<String, dynamic> _$Pl3xBuildToJson(Pl3xBuild instance) => <String, dynamic>{
      'project': instance.project,
      'version': instance.version,
      'build': instance.build,
      'md5': instance.md5,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _Pl3xApi implements Pl3xApi {
  _Pl3xApi(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.pl3x.net/v2/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Pl3xProject> retrieveVersions(project) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Pl3xProject>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/$project',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Pl3xProject.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Pl3xBuild> retrieveLatestBuild(project, version) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Pl3xBuild>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/$project/$version/latest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Pl3xBuild.fromJson(_result.data!);
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
