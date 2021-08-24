
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings extends Equatable {
  final List<Installation> installations;

  Settings(this.installations);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  @override
  List<Object?> get props => [installations];

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

@JsonSerializable()
class Installation extends Equatable {
  final String distribution;
  final String version;
  final String location;
  final int build;

  Installation(this.distribution, this.version, this.location, this.build);

  factory Installation.fromJson(Map<String, dynamic> json) =>
      _$InstallationFromJson(json);

  @override
  List<Object?> get props => [distribution, version, location, build];

  Map<String, dynamic> toJson() => _$InstallationToJson(this);
}
