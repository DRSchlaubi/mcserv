import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metadata.g.dart';

@JsonSerializable()
class DistributionMetaData extends Equatable {
  final List<DistributionVersion> versions;
  final Map<String, List<String>> flags;

  const DistributionMetaData(this.versions, this.flags);

  factory DistributionMetaData.fromJson(Map<String, dynamic> json) =>
      _$DistributionMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$DistributionMetaDataToJson(this);

  @override
  List<Object?> get props => [versions, flags];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class DistributionVersion extends Equatable {
  final String version;
  @JsonKey(name: 'java')
  final JavaOptions javaOptions;
  @JsonKey(name: 'recommendedFlags')
  final String recommendedFlagKey;

  const DistributionVersion(
      this.version, this.javaOptions, this.recommendedFlagKey);

  factory DistributionVersion.fromJson(Map<String, dynamic> json) =>
      _$DistributionVersionFromJson(json);

  Map<String, dynamic> toJson() => _$DistributionVersionToJson(this);

  @override
  List<Object?> get props => [version, javaOptions, recommendedFlagKey];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class JavaOptions extends Equatable {
  final int min;
  final int max;

  const JavaOptions(this.min, this.max);

  factory JavaOptions.fromJson(Map<String, dynamic> json) =>
      _$JavaOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$JavaOptionsToJson(this);

  @override
  List<Object?> get props => [min, max];

  @override
  bool? get stringify => true;
}
