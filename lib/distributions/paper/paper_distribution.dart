import 'dart:math';

import 'package:logging/logging.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/download.dart';
import 'package:mcserv/distributions/paperclip_distribution.dart';
import 'package:mcserv/utils/dio_util.dart';

import 'paper_api.dart';

final _log = Logger('PaperApi');

abstract class PaperDistribution extends PaperclipDistribution {
  String get project;

  @override
  String get name => project;

  final _paper = PaperApi(makeDio(_log));

  @override
  Future<PaperDownloadItem> retrieveLatestPaperBuildFor(String version) async {
    final buildId =
        (await _paper.findVersion(project, version)).builds.reduce(max);
    final build = await _paper.getBuild(project, version, buildId);

    final application = build.downloads.application;
    final downloadUrl = Uri.parse(
        'https://papermc.io/api/v2/projects/$project/versions/$version/builds/$buildId/downloads/${application.name}');

    var download = Download(downloadUrl, application.sha256);
    return PaperDownloadItem(download, build.build);
  }

  @override
  Future<VersionGroup> retrieveVersions(String version) => _paper
      .getVersionGroup(project, version)
      .then((value) => value.toVersionGroup());

  @override
  Future<List<String>> retrieveVersionGroups() =>
      _paper.findProject(project).then((value) => value.versionGroups);
}
