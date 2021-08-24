// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adoptium_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdoptiumReleases _$AdoptiumReleasesFromJson(Map<String, dynamic> json) =>
    AdoptiumReleases(
      (json['available_lts_releases'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      (json['available_releases'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      json['most_recent_feature_release'] as int,
      json['most_recent_lts'] as int,
    );

Map<String, dynamic> _$AdoptiumReleasesToJson(AdoptiumReleases instance) =>
    <String, dynamic>{
      'available_lts_releases': instance.availableLtsReleases,
      'available_releases': instance.availableReleases,
      'most_recent_feature_release': instance.mostResentFeatureRelease,
      'most_recent_lts': instance.mostResentLtsRelease,
    };

AdoptiumFeatureRelease _$AdoptiumFeatureReleaseFromJson(
        Map<String, dynamic> json) =>
    AdoptiumFeatureRelease(
      (json['binaries'] as List<dynamic>)
          .map((e) => AdoptiumBinary.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['release_name'] as String,
    );

Map<String, dynamic> _$AdoptiumFeatureReleaseToJson(
        AdoptiumFeatureRelease instance) =>
    <String, dynamic>{
      'binaries': instance.binaries,
      'release_name': instance.releaseName,
    };

AdoptiumBinary _$AdoptiumBinaryFromJson(Map<String, dynamic> json) =>
    AdoptiumBinary(
      json['architecture'] as String,
      json['image_type'] as String,
      json['jvm_impl'] as String,
      json['os'] as String,
      AdoptiumPackage.fromJson(json['package'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdoptiumBinaryToJson(AdoptiumBinary instance) =>
    <String, dynamic>{
      'architecture': instance.architecture,
      'image_type': instance.imageType,
      'jvm_impl': instance.jvmImpl,
      'os': instance.os,
      'package': instance.package,
    };

AdoptiumPackage _$AdoptiumPackageFromJson(Map<String, dynamic> json) =>
    AdoptiumPackage(
      json['checksum'] as String,
      json['link'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$AdoptiumPackageToJson(AdoptiumPackage instance) =>
    <String, dynamic>{
      'checksum': instance.checksum,
      'link': instance.link,
      'name': instance.name,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AdoptiumApi implements AdoptiumApi {
  _AdoptiumApi(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.adoptium.net/v3/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AdoptiumReleases> retrieveReleases() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AdoptiumReleases>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/info/available_releases',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AdoptiumReleases.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<AdoptiumFeatureRelease>> retrieveRelease(
      featureVersion, os, jvmImpl, architecture,
      {imageType = 'jre'}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'os': os,
      r'jvm_impl': jvmImpl,
      r'architecture': architecture,
      r'image_type': imageType
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<AdoptiumFeatureRelease>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(
                    _dio.options, '/assets/feature_releases/$featureVersion/ga',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            AdoptiumFeatureRelease.fromJson(i as Map<String, dynamic>))
        .toList();
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
