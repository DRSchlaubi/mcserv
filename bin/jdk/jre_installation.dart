class JreInstallation {
  final JreVersion version;
  final String path;

  String get binary => path + '/bin/java';

  JreInstallation(this.version, this.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JreInstallation &&
          runtimeType == other.runtimeType &&
          version == other.version &&
          path == other.path;

  @override
  int get hashCode => version.hashCode ^ path.hashCode;

  @override
  String toString() {
    return 'JreInstallation{version: $version, path: $path}';
  }
}

class JreVersion extends Comparable<JreVersion> {
  final int languageVersion;
  final int update;

  JreVersion(this.languageVersion, this.update);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JreVersion &&
          runtimeType == other.runtimeType &&
          languageVersion == other.languageVersion &&
          update == other.update;

  @override
  int get hashCode => languageVersion.hashCode ^ update.hashCode;

  @override
  String toString() {
    return 'JreVersion{languageVersion: $languageVersion, update: $update}';
  }

  @override
  int compareTo(JreVersion other) {
    if (languageVersion != other.languageVersion) {
      return languageVersion - other.languageVersion;
    }

    return update - other.update;
  }
}
