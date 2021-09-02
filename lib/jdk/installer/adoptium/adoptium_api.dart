import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

part 'adoptium_api.g.dart';

@RestApi(baseUrl: 'https://api.adoptium.net/v3/')
abstract class AdoptiumApi {
  factory AdoptiumApi(Dio dio, {String baseUrl}) = _AdoptiumApi;

  @GET('/info/available_releases')
  Future<AdoptiumReleases> retrieveReleases();

  @GET('/assets/feature_releases/{feature_version}/ga')
  Future<List<AdoptiumFeatureRelease>> retrieveRelease(
      @Path('feature_version') int featureVersion,
      @Query('os') String os,
      @Query('jvm_impl') String jvmImpl,
      @Query('architecture') String architecture,
      {@Query('image_type') String imageType = 'jre'});
}

@JsonSerializable()
class AdoptiumReleases extends Equatable {
  @JsonKey(name: 'available_lts_releases')
  final List<int> availableLtsReleases;
  @JsonKey(name: 'available_releases')
  final List<int> availableReleases;

  @JsonKey(name: 'most_recent_feature_release')
  final int mostResentFeatureRelease;
  @JsonKey(name: 'most_recent_lts')
  final int mostResentLtsRelease;

  const AdoptiumReleases(this.availableLtsReleases, this.availableReleases,
      this.mostResentFeatureRelease, this.mostResentLtsRelease);

  factory AdoptiumReleases.fromJson(Map<String, dynamic> json) =>
      _$AdoptiumReleasesFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptiumReleasesToJson(this);

  @override
  List<Object?> get props => [
        availableLtsReleases,
        availableReleases,
        mostResentFeatureRelease,
        mostResentLtsRelease
      ];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class AdoptiumFeatureRelease extends Equatable {
  final List<AdoptiumBinary> binaries;
  @JsonKey(name: 'release_name')
  final String releaseName;

  const AdoptiumFeatureRelease(this.binaries, this.releaseName);

  factory AdoptiumFeatureRelease.fromJson(Map<String, dynamic> json) =>
      _$AdoptiumFeatureReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptiumFeatureReleaseToJson(this);

  @override
  List<Object?> get props => [binaries, releaseName];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class AdoptiumBinary extends Equatable {
  final String architecture;
  @JsonKey(name: 'image_type')
  final String imageType;
  @JsonKey(name: 'jvm_impl')
  final String jvmImpl;
  final String os;
  final AdoptiumPackage package;

  const AdoptiumBinary(
      this.architecture, this.imageType, this.jvmImpl, this.os, this.package);

  factory AdoptiumBinary.fromJson(Map<String, dynamic> json) =>
      _$AdoptiumBinaryFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptiumBinaryToJson(this);

  @override
  List<Object?> get props => [architecture, imageType, jvmImpl, os, package];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class AdoptiumPackage extends Equatable {
  final String checksum;
  final String link;
  final String name;

  const AdoptiumPackage(this.checksum, this.link, this.name);

  factory AdoptiumPackage.fromJson(Map<String, dynamic> json) =>
      _$AdoptiumPackageFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptiumPackageToJson(this);

  @override
  List<Object?> get props => [checksum, link, name];

  @override
  bool? get stringify => true;
}
