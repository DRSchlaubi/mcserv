import 'package:file/file.dart';

import 'distribution.dart';
import 'download.dart';

abstract class PaperclipDistribution extends Distribution {
  Future<Download> retrieveLatestBuildFor(String version);

  @override
  Future<void> downloadTo(String version, File destination) async {
    final download = await retrieveLatestBuildFor(version);

    await download.download(destination);
  }
}
