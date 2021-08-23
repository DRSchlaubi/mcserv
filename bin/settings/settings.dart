import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {

  final List<Installation> installations;

  Settings(this.installations);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

@JsonSerializable()
class Installation {

  final String distribution;
  final String version;
  final String location;
  final String build;

  Installation(this.distribution, this.version, this.location, this.build);

  factory Installation.fromJson(Map<String, dynamic> json) =>
      _$InstallationFromJson(json);

  Map<String, dynamic> toJson() => _$InstallationToJson(this);
}
