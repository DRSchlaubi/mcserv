// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistributionMetaData _$DistributionMetaDataFromJson(
        Map<String, dynamic> json) =>
    DistributionMetaData(
      (json['versions'] as List<dynamic>)
          .map((e) => DistributionVersion.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['flags'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$DistributionMetaDataToJson(
        DistributionMetaData instance) =>
    <String, dynamic>{
      'versions': instance.versions,
      'flags': instance.flags,
    };

DistributionVersion _$DistributionVersionFromJson(Map<String, dynamic> json) =>
    DistributionVersion(
      json['version'] as String,
      JavaOptions.fromJson(json['java'] as Map<String, dynamic>),
      json['recommendedFlags'] as String,
    );

Map<String, dynamic> _$DistributionVersionToJson(
        DistributionVersion instance) =>
    <String, dynamic>{
      'version': instance.version,
      'java': instance.javaOptions,
      'recommendedFlags': instance.recommendedFlagKey,
    };

JavaOptions _$JavaOptionsFromJson(Map<String, dynamic> json) => JavaOptions(
      json['min'] as int,
      json['max'] as int,
    );

Map<String, dynamic> _$JavaOptionsToJson(JavaOptions instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };
