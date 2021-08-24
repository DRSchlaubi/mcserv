import 'package:equatable/equatable.dart';

class JreInstallation extends Equatable {
  final JreVersion version;
  final String path;

  String get binary => path + '/bin/java';

  JreInstallation(this.version, this.path);

  @override
  List<Object?> get props => [version, path];

  @override
  bool? get stringify => true;
}

class JreVersion extends Comparable<JreVersion> with EquatableMixin {
  final int languageVersion;
  final int update;

  JreVersion(this.languageVersion, this.update);

  @override
  int compareTo(JreVersion other) {
    if (languageVersion != other.languageVersion) {
      return languageVersion - other.languageVersion;
    }

    return update - other.update;
  }

  @override
  List<Object?> get props => [languageVersion, update];

  @override
  bool? get stringify => true;
}
