import 'package:mcserv/distributions/paper/paper_api.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../distribution.dart';

part 'nyper_api.g.dart';

@RestApi(baseUrl: 'https://zeitung.nycode.dev')
abstract class NyperApi {
  factory NyperApi(Dio dio, {String baseUrl}) = _NyperApi;

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
