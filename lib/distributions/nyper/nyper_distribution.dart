import 'dart:math';

import 'package:logging/logging.dart';
import 'package:mcserv/distributions/nyper/nyper_api.dart';
import 'package:mcserv/distributions/paperclip_distribution.dart';
import 'package:mcserv/utils/dio_util.dart';

import '../distribution.dart';
import '../download.dart';
import 'nyper_api.dart';

final _log = Logger('NyperApi');

class NyperDistribution extends PaperclipDistribution {
  @override
  String get name => project;

  @override
  bool get hasMetadata => true;

  // Use paper's metadata since this is a paper fork
  @override
  String get metadataKey => "paper";

  @override
  String get displayName => 'Nyper';

  String get project => 'nyper';

  final _nyper = NyperApi(makeDio(_log));

  @override
  Future<PaperDownloadItem> retrieveLatestPaperBuildFor(String version) async {
    final buildId =
        (await _nyper.findVersion(project, version)).builds.reduce(max);
    final build = await _nyper.getBuild(project, version, buildId);

    final application = build.downloads.application;
    final downloadUrl = Uri.parse(
        'https://zeitung.nycode.dev/projects/$project/versions/$version/builds/$buildId/downloads/${application.name}');

    var download = Download(downloadUrl, checksum: application.sha256);
    return PaperDownloadItem(download, build.build);
  }

  @override
  Future<VersionGroup> retrieveVersions(String version) => _nyper
      .getVersionGroup(project, version)
      .then((value) => value.toVersionGroup());

  @override
  Future<List<String>> retrieveVersionGroups() =>
      _nyper.findProject(project).then((value) => value.versionGroups);
}
