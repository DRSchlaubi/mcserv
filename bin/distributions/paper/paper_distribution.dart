import 'dart:math';

import 'package:logging/logging.dart';

import '../../utils/dio_util.dart';
import '../distribution.dart';
import '../download.dart';
import '../paperclip_distribution.dart';
import 'paper_api.dart';

final _log = Logger('PaperApi');

abstract class PaperDistribution extends PaperclipDistribution {
  String get project;

  final _paper = PaperApi(makeDio(_log));

  @override
  Future<Download> retrieveLatestBuildFor(String version) async {
    final buildId =
        (await _paper.findVersion(project, version)).builds.reduce(max);
    final build = await _paper.getBuild(project, version, buildId);

    final application = build.downloads.application;
    final download = Uri.parse(
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
