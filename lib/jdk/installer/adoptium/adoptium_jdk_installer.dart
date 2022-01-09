import 'dart:io' show Platform;

import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/distributions/download.dart';
import 'package:mcserv/jdk/installer/adoptium/windows_adoptium_jdk_installer.dart';
import 'package:mcserv/jdk/installer/jdk_installer.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/utils/platform_utils/platform_utils.dart';
import 'package:mcserv/utils/utils.dart';
import 'package:meta/meta.dart';

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
    } else if (Platform.isWindows) {
      return WindowsAdoptiumJdkInstaller();
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  @override
  Future<JreInstallation> installVersion(int version, String variant,
      bool ignoreChecksum, bool overrideExistingJdk) async {
    final release = (await _adoptium.retrieveRelease(
            version, Platform.operatingSystem, variant, architecture,
            imageType: version <= 8 ? 'jre' : 'jdk'))
        .first;

    final binary = release.binaries.first;
    final package = binary.package;
    final download =
        Download(Uri.parse(package.link), checksum: package.checksum);

    final home = await getMCServHome();
    final jreCache = home.childDirectory(JDKInstaller.cacheFolder);
    if (!await jreCache.exists()) {
      await jreCache.create();
    }
    final jre = jreCache.childFile(package.name);
    if (!await jre.exists()) {
      await jre.create();
    }

    return await installJre(JreVersion(version, -1), download, release, jre,
        ignoreChecksum, overrideExistingJdk);
  }

  @protected
  Future<JreInstallation> installJre(
      JreVersion version,
      Download download,
      AdoptiumFeatureRelease release,
      File jre,
      bool ignoreChecksum,
      bool overrideExistingJdk) async {
    final destination = await getJDKFolder();
    final jdkFolder = destination.childDirectory(release.releaseName);
    final installation = JreInstallation(version, jdkFolder.absolute.path);
    if (await jdkFolder.exists()) {
      if (confirm(localizations.overwriteExistingJava,
          defaultValue: false, predefined: overrideExistingJdk)) {
        await jdkFolder.delete(recursive: true);
      } else {
        return installation; // Just skip installation process
      }
    }

    print(localizations.downloadingJava);
    await download.download(jre, ignoreChecksum);

    _log.fine('Unpacking ${jre.path} to ${destination.path}');

    await doInProgress((status) async {
      await unarchive(destination, jre);

      status.prompt = 'Cleaning up';
      await processUnpackedJDK(jdkFolder);
      await jre.delete();
    },
        initialPrompt: 'Installing JRE',
        donePrompt: 'JRE Installation complete');

    return installation;
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
  List<String> get supportedVariants => [
        'hotspot', /*'openj9'*/
      ];

  @protected
  Future<void> processUnpackedJDK(Directory jdk) async {}
}
