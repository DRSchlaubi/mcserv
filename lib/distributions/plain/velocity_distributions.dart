import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/plain/plain_distribution.dart';

class VelocityDistribution extends PlainDistribution {
  @override
  String get displayName => 'Velocity';

  @override
  String get name => 'velocity';

  @override
  bool get supportsVersionGroups => false;

  @override
  bool get requiresEula => false;

  @override
  Uri getDownloadForVersion(String version) =>
      Uri.parse('https://versions.velocitypowered.com/download/$version.jar');

  @override
  Future<List<String>> retrieveVersionGroups() {
    throw UnsupportedError('This distribution does not support version groups');
  }

  @override
  Future<VersionGroup> retrieveVersions(String version) async {
    return VersionGroup(
        'no_version_groups', ['3.0.0', '3.0.x', '1.1.9', '1.0.10']);
  }
}
