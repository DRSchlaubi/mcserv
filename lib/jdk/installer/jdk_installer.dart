abstract class JDKInstaller {
  static const String cacheFolder = 'jdk_download_cache';

  List<String> get supportedVariants;

  Future<List<int>> retrieveVersions();

  Future<void> installVersion(int version, String variant);
}
