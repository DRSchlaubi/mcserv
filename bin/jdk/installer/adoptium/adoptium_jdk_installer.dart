import 'dart:io' show Platform;

import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../../../distributions/download.dart';
import '../../../mcserve.dart';
import '../../../utils/confirm.dart';
import '../../../utils/dio_util.dart';
import '../../../utils/mcserv_home.dart';
import '../../../utils/plattform_utils/system_info/system_info.dart';
import '../../../utils/tar_util.dart';
import '../jdk_installer.dart';
import 'adoptium_api.dart';
import 'linux_adoptium_jdk_installer.dart';

final _log = Logger('AdoptiumJDKInstaller');

abstract class AdoptiumJDKInstaller extends JDKInstaller {
  final _adoptium = AdoptiumApi(makeDio(_log));

  @protected
  AdoptiumJDKInstaller();

  factory AdoptiumJDKInstaller.forPlatform() {
    if (Platform.isLinux) {
      return LinuxAdoptiumJDKInstaller();
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  @override
  Future<void> installVersion(int version, String variant) async {
    print(version <= 8 ? 'jre' : 'jdk');
    final release = (await _adoptium.retrieveRelease(
            version, Platform.operatingSystem, variant, architecture,
            imageType: version <= 8 ? 'jre' : 'jdk'))
        .first;

    final binary = release.binaries.first;
    final package = binary.package;
    final download = Download(Uri.parse(package.link), package.checksum);

    final home = await getMCServHome();
    final jreCache = home.childDirectory(JDKInstaller.cacheFolder);
    if (!await jreCache.exists()) {
      await jreCache.create();
    }
    final jre = jreCache.childFile(package.name);
    if (!await jre.exists()) {
      await jre.create();
    }

    await installJre(download, release, jre);
  }

  @protected
  Future<void> installJre(
      Download download, AdoptiumFeatureRelease release, File jre) async {
    var destination = await getJDKFolder();
    var jdkFolder = destination.childDirectory(release.releaseName);
    if (await jdkFolder.exists()) {
      if (confirm(localizations.overwriteExistingJava, defaultValue: false)) {
        await jdkFolder.delete(recursive: true);
      } else {
        return; // Just skip installation process
      }
    }

    await download.download(jre);

    _log.fine('Unpacking ${jre.path} to ${destination.path}');

    await untargz(destination, jre);

    await processUnpackedJDK(jdkFolder);

    await jre.delete();
  }

  @override
  Future<List<int>> retrieveVersions() async {
    final versions = await _adoptium.retrieveReleases();

    return [
      ...versions.availableLtsReleases,
      versions.mostResentFeatureRelease
    ];
  }

  @override
  List<String> get supportedVariants => ['hotspot', /*'openj9'*/];

  @protected
  Future<void> processUnpackedJDK(Directory jdk) async {}
}
