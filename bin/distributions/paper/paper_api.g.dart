// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaperVersion _$PaperVersionFromJson(Map<String, dynamic> json) => PaperVersion(
      json['project_id'] as String,
      json['project_name'] as String,
      json['version'] as String,
      (json['builds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PaperVersionToJson(PaperVersion instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'project_name': instance.projectName,
      'version': instance.version,
      'builds': instance.builds,
    };

PaperProject _$PaperProjectFromJson(Map<String, dynamic> json) => PaperProject(
      json['project_id'] as String,
      json['project_name'] as String,
      (json['version_groups'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['versions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaperProjectToJson(PaperProject instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'project_name': instance.projectName,
      'version_groups': instance.versionGroups,
      'versions': instance.versions,
    };

PaperBuild _$PaperBuildFromJson(Map<String, dynamic> json) => PaperBuild(
      json['project_id'] as String,
      json['project_name'] as String,
      json['build'] as int,
      PaperDownloads.fromJson(json['downloads'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaperBuildToJson(PaperBuild instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'project_name': instance.projectName,
      'build': instance.build,
      'downloads': instance.downloads,
    };

PaperDownloads _$PaperDownloadsFromJson(Map<String, dynamic> json) =>
    PaperDownloads(
      PaperDownload.fromJson(json['application'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaperDownloadsToJson(PaperDownloads instance) =>
    <String, dynamic>{
      'application': instance.application,
    };

PaperDownload _$PaperDownloadFromJson(Map<String, dynamic> json) =>
    PaperDownload(
      json['name'] as String,
      json['sha256'] as String,
    );

Map<String, dynamic> _$PaperDownloadToJson(PaperDownload instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sha256': instance.sha256,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _PaperApi implements PaperApi {
  _PaperApi(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://papermc.io/api/v2/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<PaperProject> findPaper() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PaperProject>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/projects/paper/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PaperProject.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PaperVersion> findVersion(version) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PaperVersion>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/projects/paper/versions/$version/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PaperVersion.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PaperBuild> getBuild(version, build) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PaperBuild>(Options(
                method: 'GET', headers: <String, dynamic>{}, extra: _extra)
            .compose(
                _dio.options, '/projects/paper/versions/$version/builds/$build',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PaperBuild.fromJson(_result.data!);
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
