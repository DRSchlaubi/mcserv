import 'package:archive/archive.dart';
import 'package:file/file.dart';
import 'package:logging/logging.dart';

var _log = Logger('TarUtil');

Archive _decodeArchive(String name, List<int> bytes) {
  if (name.endsWith('.gz')) {
    // Un-gzip and unpack again without .gz extension
    return _decodeArchive(
        name.substring(0, name.length - 4), _decodeGZip(bytes));
  } else if (name.endsWith('.tar')) {
    return _decodeTar(bytes);
  } else if (name.endsWith('.zip')) {
    return _decodeZip(bytes);
  } else {
    throw UnsupportedError('Could not detect archive format: $name');
  }
}

List<int> _decodeGZip(List<int> bytes) => GZipDecoder().decodeBytes(bytes);

Archive _decodeTar(List<int> bytes) => TarDecoder().decodeBytes(bytes);

Archive _decodeZip(List<int> bytes) => ZipDecoder().decodeBytes(bytes);

Future<void> unarchive(Directory output, File archive) async {
  final bytes = await archive.readAsBytes();

  final decodedArchive = _decodeArchive(archive.basename, bytes);

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
