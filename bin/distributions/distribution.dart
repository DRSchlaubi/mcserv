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

  Future<List<String>> retrieveVersions();

  Future<void> downloadTo(String version, File destination);
}
