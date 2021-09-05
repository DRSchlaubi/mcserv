import 'package:mcserv/jdk/jre_installation.dart';

abstract class JDKInstaller {
  static const String cacheFolder = 'jdk_download_cache';

  List<String> get supportedVariants;

  Future<List<int>> retrieveVersions();

  Future<JreInstallation> installVersion(int version, String variant,
      bool ignoreChecksum, bool overrideExistingJdk);
}
