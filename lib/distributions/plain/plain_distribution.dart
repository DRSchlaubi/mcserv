import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file/file.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/download.dart';
import 'package:mcserv/utils/utils.dart';

class ChecksumInfo extends Equatable {
  final String checksum;
  final HashingAlgorithm hashingAlgorithm;

  const ChecksumInfo(this.checksum, this.hashingAlgorithm);

  @override
  List<Object?> get props => [checksum, hashingAlgorithm];

  @override
  bool? get stringify => true;
}

abstract class PlainDistribution extends Distribution {
  static const plainVersionBuild = -1;

  Uri getDownloadForVersion(String version);

  Future<ChecksumInfo?> getChecksumInfoForVersion(String version) async => null;

  @override
  String get metadataKey => name;

  @override
  Future<int> downloadTo(
      String version, File destination, bool ignoreChecksum) async {
    final build = getDownloadForVersion(version);
    final checksum = await getChecksumInfoForVersion(version);

    await Download(build,
            checksum: checksum?.checksum,
            hashingAlgorithm: checksum?.hashingAlgorithm)
        .download(destination, ignoreChecksum);

    return -1;
  }

  @override
  Future<int> retrieveLatestBuildFor(String version) async {
    if (confirm(
        "This distribution doesn't have an API to check for builds. Do you want to re-download the distribution?",
        defaultValue: true)) {
      return -1;
    } else {
      exit(0);
    }
  }
}
