import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

//language=RegExp
final _javaVersionRegex = RegExp('version "([0-9_.]*)"');

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

final _log = Logger('JreVersionParser');

class JreVersion extends Comparable<JreVersion> with EquatableMixin {
  final int languageVersion;
  final int update;

  JreVersion(this.languageVersion, this.update);

  static JreVersion? tryParse(String input) {
    try {
      final match = _javaVersionRegex.firstMatch(input);
      if (match == null) {
        throw FormatException('Could not parse java version $input');
      }
      final version = match.group(1)!;
      return JreVersion.parse(version);
    } on FormatException catch (e) {
      _log.severe('Could not parse version', e);
      return null;
    }
  }

  factory JreVersion.parse(String version) {
    if (version.startsWith('1.')) {
      // pre java 10 versioning
      final languageVersion = int.parse(version[2]); // 1.<version>
      final updateSeparator = version.indexOf('_');
      final update = int.parse(version.substring(updateSeparator + 1));

      return JreVersion(languageVersion, update);
    } else {
      // java 10+ versioning
      final languageVersion =
          int.parse(version.substring(0, 2)); // first 2 chars
      final lastVersionSeparator = version.lastIndexOf('.');
      final update = int.parse(version.substring(lastVersionSeparator + 1));

      return JreVersion(languageVersion, update);
    }
  }

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
