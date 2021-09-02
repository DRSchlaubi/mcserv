import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/download.dart';
import 'package:mcserv/distributions/plain/bungeecord/bungeecord_api.dart';
import 'package:mcserv/distributions/plain/plain_distribution.dart';

class BungeeCordDistribution extends PlainDistribution {
  final _jenkins = BungeeCordApi();

  @override
  String get displayName => 'BungeeCord';

  @override
  String get name => 'bungeecord';

  @override
  bool get supportsVersionGroups => false;

  @override
  bool get requiresEula => false;

  @override
  Uri getDownloadForVersion(String version) => Uri.parse(
      'https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar');

  @override
  Future<ChecksumInfo?> getChecksumInfoForVersion(String version) async {
    final fingerprints = await _jenkins.retrieveBuildHashes();
    final bungee =
        fingerprints.firstWhere((element) => element.name == 'BungeeCord.jar');

    return ChecksumInfo(bungee.hash, HashingAlgorithm.md5);
  }

  @override
  Future<List<String>> retrieveVersionGroups() {
    throw UnsupportedError('This distribution does not support version groups');
  }

  @override
  Future<VersionGroup> retrieveVersions(String version) async {
    return VersionGroup('no_version_groups', ['Latest']);
  }
}
