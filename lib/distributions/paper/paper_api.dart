import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../distribution.dart';

part 'paper_api.g.dart';

@RestApi(baseUrl: 'https://papermc.io/api/v2/')
abstract class PaperApi {
  factory PaperApi(Dio dio, {String baseUrl}) = _PaperApi;

  @GET('/projects/{project}/')
  Future<PaperProject> findProject(@Path('project') String project);

  @GET('/projects/{project}/versions/{version}/')
  Future<PaperVersion> findVersion(
      @Path('project') String project, @Path('version') String version);

  @GET('/projects/{project}/versions/{version}/builds/{build}')
  Future<PaperBuild> getBuild(@Path('project') String project,
      @Path('version') String version, @Path('build') int build);

  @GET('/projects/{project}/version_group/{versionGroup}')
  Future<PaperVersionGroup> getVersionGroup(@Path('project') String project,
      @Path('versionGroup') String versionGroup);
}

@JsonSerializable()
class PaperVersion extends Equatable {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'project_name')
  final String projectName;
  final String version;
  final List<int> builds;

  const PaperVersion(
      this.projectId, this.projectName, this.version, this.builds);

  factory PaperVersion.fromJson(Map<String, dynamic> json) =>
      _$PaperVersionFromJson(json);

  Map<String, dynamic> toJson() => _$PaperVersionToJson(this);

  @override
  List<Object?> get props => [projectId, projectName, version, builds];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class PaperProject extends Equatable {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'project_name')
  final String projectName;
  @JsonKey(name: 'version_groups')
  final List<String> versionGroups;
  final List<String> versions;

  const PaperProject(
      this.projectId, this.projectName, this.versionGroups, this.versions);

  factory PaperProject.fromJson(Map<String, dynamic> json) =>
      _$PaperProjectFromJson(json);

  Map<String, dynamic> toJson() => _$PaperProjectToJson(this);

  @override
  List<Object?> get props => [projectId, projectName, versionGroups, versions];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class PaperBuild extends Equatable {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'project_name')
  final String projectName;
  final int build;
  final PaperDownloads downloads;

  const PaperBuild(
      this.projectId, this.projectName, this.build, this.downloads);

  factory PaperBuild.fromJson(Map<String, dynamic> json) =>
      _$PaperBuildFromJson(json);

  Map<String, dynamic> toJson() => _$PaperBuildToJson(this);

  @override
  List<Object?> get props => [projectId, projectName, build, downloads];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class PaperDownloads extends Equatable{
  final PaperDownload application;

  const PaperDownloads(this.application);

  factory PaperDownloads.fromJson(Map<String, dynamic> json) =>
      _$PaperDownloadsFromJson(json);

  Map<String, dynamic> toJson() => _$PaperDownloadsToJson(this);

  @override
  List<Object?> get props => [application];
}

@JsonSerializable()
class PaperDownload extends Equatable {
  final String name;
  final String sha256;

  const PaperDownload(this.name, this.sha256);

  factory PaperDownload.fromJson(Map<String, dynamic> json) =>
      _$PaperDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$PaperDownloadToJson(this);

  @override
  List<Object?> get props => [name, sha256];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class PaperVersionGroup extends Equatable {
  @JsonKey(name: 'version_group')
  final String versionGroup;

  @JsonKey(name: 'versions')
  final List<String> versions;

  const PaperVersionGroup(this.versionGroup, this.versions);

  factory PaperVersionGroup.fromJson(Map<String, dynamic> json) =>
      _$PaperVersionGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PaperVersionGroupToJson(this);

  VersionGroup toVersionGroup() => VersionGroup(versionGroup, versions);

  @override
  List<Object?> get props => [versionGroup, versions];

  @override
  bool? get stringify => true;
}
