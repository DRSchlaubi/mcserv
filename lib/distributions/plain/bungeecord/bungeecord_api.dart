import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/utils/dio_util.dart';

final _log = Logger('BungeeCordApi');

class BungeeCordApi {
  final _dio = makeDio(_log);

  Future<List<Fingerprint>> retrieveBuildHashes() async {
    final json = await _dio.get<Map<String, dynamic>>(
        'https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/api/json?pretty=true&depth=2&tree=actions[moduleRecords[mainArtifact[fileName,md5sum]]]');

    final actions = json.data!['actions'] as List<dynamic>;
    final action = actions.firstWhere((element) =>
        element['_class'] ==
        'hudson.maven.reporters.MavenAggregatedArtifactRecord');

    return (action['moduleRecords'] as List<dynamic>).map((e) {
      final artifact = e['mainArtifact'];

      return Fingerprint(artifact['fileName'], artifact['md5sum']);
    }).toList(growable: false);
  }
}

class Fingerprint extends Equatable {
  @JsonKey(name: 'fileName')
  final String name;
  final String hash;

  Fingerprint(this.name, this.hash);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [name, hash];
}
