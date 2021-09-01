import 'dart:io';

import 'package:file/src/interface/file.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/download.dart';
import 'package:mcserv/utils/utils.dart';

abstract class PlainDistribution extends Distribution {
  static const plainVersionBuild = -1;

  Uri getDownloadForVersion(String version);

  @override
  Future<int> downloadTo(String version, File destination) async {
    final build = getDownloadForVersion(version);

    await Download(build).download(destination);

    return -1;
  }

  @override
  Future<int> retrieveLatestBuildFor(String version) async {
    if(confirm("This distribution doesn't have an API to check for builds. Do you want to re-download the distribution?", defaultValue: true)) {
      return -1;
    } else {
      exit(0);
    }
  }
}
