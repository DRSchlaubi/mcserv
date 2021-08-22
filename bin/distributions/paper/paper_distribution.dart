import 'dart:math';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../download.dart';
import '../paperclip_distribution.dart';
import 'paper_api.dart';

var _log = Logger('PaperApi');

class PaperDistribution extends PaperclipDistribution {
  final _paper = PaperApi(_makeDio());

  @override
  Future<Download> retrieveLatestBuildFor(String version) async {
    var buildId = (await _paper.findVersion(version)).builds.reduce(max);
    var build = await _paper.getBuild(version, buildId);

    var application = build.downloads.application;
    var download = Uri.parse(
        'https://papermc.io/api/v2/projects/paper/versions/$version/builds/$buildId/downloads/${application.name}');

    return Download(download, application.sha256);
  }

  @override
  Future<List<String>> retrieveVersions() =>
      _paper.findPaper().then((value) {
        var versions = value.versions;
        versions.sort((a, b) => a.compareTo(b));
        return versions;
      });
}

Dio _makeDio() {
  var dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        _log.fine('${request.method} => ${request.uri.toString()}');

        handler.next(request);
      }));

  return dio;
}
