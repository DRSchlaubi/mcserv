import 'dart:io';

import 'package:file/local.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../../../distributions/download.dart';
import '../../../utils/dio_util.dart';
import '../../../utils/mcserv_home.dart';
import '../../../utils/plattform_utils/system_info/system_info.dart';
import '../jdk_installer.dart';
import 'adoptium_api.dart';
import 'linux_adoptium_jdk_installer.dart';

var _log = Logger('AdoptiumJDKInstaller');

abstract class AdoptiumJDKInstaller extends JDKInstaller {
  final _adoptium = AdoptiumApi(makeDio(_log));
  @protected
  final fs = LocalFileSystem();

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
    var release = (await _adoptium.retrieveRelease(
            version, Platform.operatingSystem, variant, architecture,
            imageType: version <= 8 ? 'jre' : 'jdk'))
        .first;

    var binary = release.binaries.first;
    var package = binary.package;
    var download = Download(Uri.parse(package.link), package.checksum);

    var home = await getMCServHome();
    var jreCache = home.childDirectory(JDKInstaller.cacheFolder);
    if (!await jreCache.exists()) {
      await jreCache.create();
    }
    var jre = jreCache.childFile(package.name);
    if (!await jre.exists()) {
      await jre.create();
    }
    await download.download(jre);

    await installJre(binary, jre);
  }

  @protected
  Future<void> installJre(AdoptiumBinary binary, File jre);

  @override
  Future<List<int>> retrieveVersions() async {
    var versions = await _adoptium.retrieveReleases();

    return [
      ...versions.availableLtsReleases,
      versions.mostResentFeatureRelease
    ];
  }

  @override
  List<String> get supportedVariants => ['hotspot', 'openj9'];
}
