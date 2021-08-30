// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      (json['installations'] as List<dynamic>)
          .map((e) => Installation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'installations': instance.installations,
    };

Installation _$InstallationFromJson(Map<String, dynamic> json) => Installation(
      json['distribution'] as String,
      json['version'] as String,
      json['location'] as String,
      json['build'] as int,
      json['javaVersion'] as int,
      json['javaPath'] as String,
      json['useFlags'] as bool,
    );

Map<String, dynamic> _$InstallationToJson(Installation instance) =>
    <String, dynamic>{
      'distribution': instance.distribution,
      'version': instance.version,
      'location': instance.location,
      'build': instance.build,
      'javaVersion': instance.javaVersion,
      'javaPath': instance.javaPath,
      'useFlags': instance.useFlags,
    };
