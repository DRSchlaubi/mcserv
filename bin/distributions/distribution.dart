import 'package:file/file.dart';

import 'paper/paper_mc_distribution.dart';
import 'paper/waterfall_distribution.dart';
import 'paper/traventine_distribution.dart';

abstract class Distribution {
  static List<Distribution> all = [
    PaperMCDistribution(),
    WaterfallDistribution(),
    TraventineDistribution()
  ];

  bool get requiresEula => true;

  String get displayName;

  Future<VersionGroup> retrieveVersions(String version);

  Future<List<String>> retrieveVersionGroups();

  Future<void> downloadTo(String version, File destination);
}

class VersionGroup {
  final String name;
  final List<String> versions;

  const VersionGroup(this.name, this.versions);
}
