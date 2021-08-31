import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'pl3x_api.g.dart';

@RestApi(baseUrl: 'https://api.pl3x.net/v2/')
abstract class Pl3xApi {
  factory Pl3xApi(Dio dio, {String baseUrl}) = _Pl3xApi;

  @GET('/{project}')
  Future<Pl3xProject> retrieveVersions(@Path('project') String project);

  @GET('/{project}/{version}/latest')
  Future<Pl3xBuild> retrieveLatestBuild(
      @Path('project') String project, @Path('version') String version);
}

@JsonSerializable()
class Pl3xProject extends Equatable {
  final String project;
  final List<String> versions;

  const Pl3xProject(this.project, this.versions);

  factory Pl3xProject.fromJson(Map<String, dynamic> json) =>
      _$Pl3xProjectFromJson(json);

  Map<String, dynamic> toJson() => _$Pl3xProjectToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [project, versions];
}

@JsonSerializable()
class Pl3xBuild extends Equatable {
  final String project;
  final String version;
  final String build;
  final String md5;

  const Pl3xBuild(this.project, this.version, this.build, this.md5);

  int get buildInt => int.parse(build);

  factory Pl3xBuild.fromJson(Map<String, dynamic> json) =>
      _$Pl3xBuildFromJson(json);

  Map<String, dynamic> toJson() => _$Pl3xBuildToJson(this);

  @override
  List<Object?> get props => [project, version, build, md5];

  @override
  bool? get stringify => true;
}
