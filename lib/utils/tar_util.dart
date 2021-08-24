
import 'package:archive/archive.dart';
import 'package:file/file.dart';
import 'package:logging/logging.dart';

var _log = Logger('TarUtil');

Future<void> untargz(Directory output, File archive) async {
  final bytes = await archive.readAsBytes();

  final tarBytes = GZipDecoder().decodeBytes(bytes);
  final decodedArchive = TarDecoder().decodeBytes(tarBytes);

  for (final file in decodedArchive) {
    final filename = file.name;
    _log.finest('Unpacking $filename');
    if (file.isFile) {
      final data = file.content as List<int>;
      var outputFile = output.childFile(filename);
      await outputFile.create();
      await outputFile.writeAsBytes(data);
    } else {
      await output.childDirectory(filename).create();
    }
  }
}
