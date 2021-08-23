import 'dart:math';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../distribution.dart';
import '../download.dart';
import '../paperclip_distribution.dart';
import 'paper_api.dart';

var _log = Logger('PaperApi');

abstract class PaperDistribution extends PaperclipDistribution {
  String get project;

  final _paper = PaperApi(_makeDio());

  @override
  Future<Download> retrieveLatestBuildFor(String version) async {
    var buildId =
        (await _paper.findVersion(project, version)).builds.reduce(max);
    var build = await _paper.getBuild(project, version, buildId);

    var application = build.downloads.application;
    var download = Uri.parse(
        'https://papermc.io/api/v2/projects/$project/versions/$version/builds/$buildId/downloads/${application.name}');

    return Download(download, application.sha256);
  }

  @override
  Future<VersionGroup> retrieveVersions(String version) => _paper
      .getVersionGroup(project, version)
      .then((value) => value.toVersionGroup());

  @override
  Future<List<String>> retrieveVersionGroups() =>
      _paper.findProject(project).then((value) => value.versionGroups);
}

Dio _makeDio() {
  var dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
    _log.fine('${request.method} => ${request.uri.toString()}');

    handler.next(request);
  }));

  return dio;
}
