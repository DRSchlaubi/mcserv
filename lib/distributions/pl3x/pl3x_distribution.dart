import 'dart:async';

import 'package:logging/logging.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/download.dart';
import 'package:mcserv/distributions/paperclip_distribution.dart';
import 'package:mcserv/distributions/pl3x/pl3x_api.dart';
import 'package:mcserv/utils/collection_utils.dart';
import 'package:mcserv/utils/dio_util.dart';
import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';

final _log = Logger('Pl3xDistribution');

abstract class Pl3xDistribution extends PaperclipDistribution {
  final _pl3x = Pl3xApi(makeDio(_log));

  @protected
  String get project;

  late _Pl3xGroupedVersionCache _versionCache;

  Pl3xDistribution() {
    _versionCache = _Pl3xGroupedVersionCache(_pl3x, project);
  }

  @override
  Future<PaperDownloadItem> retrieveLatestPaperBuildFor(String version) async {
    final build = await _pl3x.retrieveLatestBuild(project, version);
    final download = Download(
        Uri.parse('https://api.pl3x.net/v2/$project/$version/latest/download'),
        build.md5,
        hashingAlgorithm: HashingAlgorithm.MD5);

    return PaperDownloadItem(download, build.buildInt);
  }

  @override
  Future<List<String>> retrieveVersionGroups() =>
      _versionCache.getVersionGroups();

  @override
  Future<VersionGroup> retrieveVersions(String version) =>
      _versionCache.getVersions(version);
}

class _Pl3xGroupedVersionCache {
  final Pl3xApi _pl3x;
  final String project;
  DateTime? _lastUpdate;
  late Map<Version, List<Version>> _map;

  _Pl3xGroupedVersionCache(this._pl3x, this.project);

  Future<List<String>> getVersionGroups() async {
    final versions = await _updateOrGet();

    return versions.keys
        .map((e) => '${e.major}.${e.minor}')
        .toList(growable: false);
  }

  Future<VersionGroup> getVersions(String version) async {
    final semVersion = Version.parse(version + '.0');
    final versions = await _updateOrGet();

    final subVersions = versions[semVersion]!.map((e) {
      final v = e.toString();
      if (v.endsWith('.0')) {
        return v.substring(0, v.length - 2);
      }
      return v;
    }).toList();

    return VersionGroup(version, subVersions);
  }

  FutureOr<Map<Version, List<Version>>> _updateOrGet() async {
    if (_lastUpdate == null ||
        ((_lastUpdate?.difference(DateTime.now())) ?? Duration(seconds: 0)) >
            Duration(minutes: 1)) {
      return await _update();
    }

    return _map;
  }

  Future<Map<Version, List<Version>>> _update() async {
    final versions = await _pl3x.retrieveVersions(project);
    final semVersions = versions.versions.map((e) {
      if (e.split('.').length > 2) {
        return Version.parse(e);
      } else {
        return Version.parse(e + '.0');
      }
    });

    _lastUpdate = DateTime.now();
    _map = groupBy(semVersions, (e) => Version(e.major, e.minor, 0));

    return _map;
  }
}
