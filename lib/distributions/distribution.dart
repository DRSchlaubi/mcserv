import 'package:file/file.dart';
import 'package:mcserv/distributions/pl3x/purpur_distribution.dart';
import 'package:mcserv/distributions/plain/bungeecord_distribution.dart';
import 'package:meta/meta.dart';

import 'paper/paper_mc_distribution.dart';
import 'paper/travertine_distribution.dart';
import 'paper/waterfall_distribution.dart';
import 'paper/velocity_distribution.dart';

abstract class Distribution {
  static final List<Distribution> all = [
    PaperMCDistribution(),
    WaterfallDistribution(),
    TravertineDistribution(),
    PurPurDistribution(),
    VelocityDistribution(),
    BungeeCordDistribution()
  ];

  static final List<String> names =
      all.map((e) => e.name).toList(growable: false);

  @protected
  Distribution();

  factory Distribution.forName(String name) =>
      all.firstWhere((element) => element.name == name);

  bool get hasMetadata => false;

  bool get requiresEula => true;

  bool get supportsVersionGroups => true;

  bool get recommended => false;

  String get displayName;

  String get name;

  String get metadataKey;

  Future<VersionGroup> retrieveVersions(String version);

  Future<int> retrieveLatestBuildFor(String version);

  Future<List<String>> retrieveVersionGroups();

  Future<int> downloadTo(String version, File destination, bool ignoreChecksum);
}

class VersionGroup {
  final String name;
  final List<String> versions;

  const VersionGroup(this.name, this.versions);
}
