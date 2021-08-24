import 'package:equatable/equatable.dart';
import 'package:file/file.dart';

import 'distribution.dart';
import 'download.dart';

abstract class PaperclipDistribution extends Distribution {
  Future<PaperDownloadItem> retrieveLatestPaperBuildFor(String version);

  @override
  Future<int> retrieveLatestBuildFor(String version) =>
      retrieveLatestPaperBuildFor(version).then((value) => value.build);

  @override
  Future<int> downloadTo(String version, File destination) async {
    final download = await retrieveLatestPaperBuildFor(version);

    await download.download.download(destination);

    return download.build;
  }
}

class PaperDownloadItem extends Equatable {
  final Download download;
  final int build;

  PaperDownloadItem(this.download, this.build);

  @override
  List<Object?> get props => [download, build];
}
