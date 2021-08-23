import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

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
}

@JsonSerializable()
class PaperVersion {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'project_name')
  final String projectName;
  final String version;
  final List<int> builds;

  PaperVersion(this.projectId, this.projectName, this.version, this.builds);

  factory PaperVersion.fromJson(Map<String, dynamic> json) =>
      _$PaperVersionFromJson(json);

  Map<String, dynamic> toJson() => _$PaperVersionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperVersion &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          projectName == other.projectName &&
          version == other.version &&
          builds == other.builds;

  @override
  int get hashCode =>
      projectId.hashCode ^
      projectName.hashCode ^
      version.hashCode ^
      builds.hashCode;

  @override
  String toString() {
    return 'PaperVersion{projectId: $projectId, projectName: $projectName, version: $version, builds: $builds}';
  }
}

@JsonSerializable()
class PaperProject {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'project_name')
  final String projectName;
  @JsonKey(name: 'version_groups')
  final List<String> versionGroups;
  final List<String> versions;

  factory PaperProject.fromJson(Map<String, dynamic> json) =>
      _$PaperProjectFromJson(json);

  PaperProject(
      this.projectId, this.projectName, this.versionGroups, this.versions);

  Map<String, dynamic> toJson() => _$PaperProjectToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperProject &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          projectName == other.projectName &&
          versionGroups == other.versionGroups &&
          versions == other.versions;

  @override
  int get hashCode =>
      projectId.hashCode ^
      projectName.hashCode ^
      versionGroups.hashCode ^
      versions.hashCode;

  @override
  String toString() {
    return 'PaperProject{projectId: $projectId, projectName: $projectName, versionGroups: $versionGroups, versions: $versions}';
  }
}

@JsonSerializable()
class PaperBuild {
  @JsonKey(name: 'project_id')
  final String projectId;
  @JsonKey(name: 'project_name')
  final String projectName;
  final int build;
  final PaperDownloads downloads;

  PaperBuild(this.projectId, this.projectName, this.build, this.downloads);

  factory PaperBuild.fromJson(Map<String, dynamic> json) =>
      _$PaperBuildFromJson(json);

  Map<String, dynamic> toJson() => _$PaperBuildToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperBuild &&
          runtimeType == other.runtimeType &&
          projectId == other.projectId &&
          projectName == other.projectName &&
          build == other.build &&
          downloads == other.downloads;

  @override
  int get hashCode =>
      projectId.hashCode ^
      projectName.hashCode ^
      build.hashCode ^
      downloads.hashCode;

  @override
  String toString() {
    return 'PaperBuild{projectId: $projectId, projectName: $projectName, build: $build, downloads: $downloads}';
  }
}

@JsonSerializable()
class PaperDownloads {
  final PaperDownload application;

  PaperDownloads(this.application);

  factory PaperDownloads.fromJson(Map<String, dynamic> json) =>
      _$PaperDownloadsFromJson(json);

  Map<String, dynamic> toJson() => _$PaperDownloadsToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperDownloads &&
          runtimeType == other.runtimeType &&
          application == other.application;

  @override
  int get hashCode => application.hashCode;

  @override
  String toString() {
    return 'PaperDownloads{application: $application}';
  }
}

@JsonSerializable()
class PaperDownload {
  final String name;
  final String sha256;

  PaperDownload(this.name, this.sha256);

  factory PaperDownload.fromJson(Map<String, dynamic> json) =>
      _$PaperDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$PaperDownloadToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperDownload &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          sha256 == other.sha256;

  @override
  int get hashCode => name.hashCode ^ sha256.hashCode;

  @override
  String toString() {
    return 'PaperDownloads{name: $name, sha256: $sha256}';
  }
}
