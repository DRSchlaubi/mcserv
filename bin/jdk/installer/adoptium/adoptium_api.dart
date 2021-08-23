import 'package:dio/dio.dart';
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
class AdoptiumReleases {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdoptiumReleases &&
          runtimeType == other.runtimeType &&
          availableLtsReleases == other.availableLtsReleases &&
          availableReleases == other.availableReleases &&
          mostResentFeatureRelease == other.mostResentFeatureRelease &&
          mostResentLtsRelease == other.mostResentLtsRelease;

  @override
  int get hashCode =>
      availableLtsReleases.hashCode ^
      availableReleases.hashCode ^
      mostResentFeatureRelease.hashCode ^
      mostResentLtsRelease.hashCode;

  @override
  String toString() {
    return 'AdoptiumReleases{availableLtsReleases: $availableLtsReleases, availableReleases: $availableReleases, mostResentFeatureRelease: $mostResentFeatureRelease, mostResentLtsRelease: $mostResentLtsRelease}';
  }
}

@JsonSerializable()
class AdoptiumFeatureRelease {
  final List<AdoptiumBinary> binaries;

  const AdoptiumFeatureRelease(this.binaries);

  factory AdoptiumFeatureRelease.fromJson(Map<String, dynamic> json) =>
      _$AdoptiumFeatureReleaseFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptiumFeatureReleaseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdoptiumFeatureRelease &&
          runtimeType == other.runtimeType &&
          binaries == other.binaries;

  @override
  int get hashCode => binaries.hashCode;

  @override
  String toString() {
    return 'AdoptiumFeatureRelease{binaries: $binaries}';
  }
}

@JsonSerializable()
class AdoptiumBinary {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdoptiumBinary &&
          runtimeType == other.runtimeType &&
          architecture == other.architecture &&
          imageType == other.imageType &&
          jvmImpl == other.jvmImpl &&
          os == other.os &&
          package == other.package;

  @override
  int get hashCode =>
      architecture.hashCode ^
      imageType.hashCode ^
      jvmImpl.hashCode ^
      os.hashCode ^
      package.hashCode;

  @override
  String toString() {
    return 'AdoptiumBinary{architecture: $architecture, imageType: $imageType, jvmImpl: $jvmImpl, os: $os, package: $package}';
  }
}

@JsonSerializable()
class AdoptiumPackage {
  final String checksum;
  final String link;
  final String name;

  const AdoptiumPackage(this.checksum, this.link, this.name);

  factory AdoptiumPackage.fromJson(Map<String, dynamic> json) =>
      _$AdoptiumPackageFromJson(json);

  Map<String, dynamic> toJson() => _$AdoptiumPackageToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdoptiumPackage &&
          runtimeType == other.runtimeType &&
          checksum == other.checksum &&
          link == other.link;

  @override
  int get hashCode => checksum.hashCode ^ link.hashCode;

  @override
  String toString() {
    return 'AdoptiumPackage{checksum: $checksum, link: $link}';
  }
}
