
import 'package:file/file.dart';

import 'paper/paper_distribution.dart';

abstract class Distribution {
  static List<Distribution> all = [PaperDistribution()];

  String get displayName;

  Future<List<String>> retrieveVersions();

  Future<void> downloadTo(String version, File destination);
}
