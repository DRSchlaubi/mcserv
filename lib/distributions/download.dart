import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:console/console.dart';
import 'package:crypto/crypto.dart';
import 'package:file/file.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/utils/localizations_util.dart';

import '../utils/confirm.dart';

final _log = Logger('Downloader');

class Download {
  final Uri uri;
  final String? checksum;
  final HashingAlgorithm? hashingAlgorithm;

  Download(this.uri, {this.checksum,
      this.hashingAlgorithm = HashingAlgorithm.sha256});

  Future<void> download(File destination) async {
    _log.fine('Starting download to $uri');

    final client = Client();
    final request = await client.send(Request('GET', uri));
    final contentLength = request.contentLength!;
    final progress = ProgressBar(complete: contentLength);

    final chunks = await request.stream.map((s) {
      progress.update(progress.current + s.length);
      return s;
    }).toList();

    final bytes = Uint8List(contentLength);
    var offset = 0;
    for (var chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    if (request.statusCode > 299) {
      throw Exception(
          'Received invalid status code: ${request.statusCode} Body: ${utf8
              .decode(bytes)}');
    }

    if (checksum != null) {
      final alg = hashingAlgorithm!;
      _log.fine('Expected ${alg.name} checksum: $checksum');
      final digestHex = alg.hash(bytes);
      _log.fine('Actual ${alg.name} checksum: $digestHex');

      if (digestHex != checksum) {
        if (!confirm(
            'Checksum validation failed, do you want to continue anyways?',
            waitForNewLine: true)) {
          exit(1);
        }
      }

      _log.fine('Checksum test passed! Writing bytes to file!');
    } else {
      _log.warning(
          'No checksum was provided on this Download, therefore integrity of the file cannot be ensured');
    }

    print(localizations.downloadDone);
    await destination.writeAsBytes(bytes);
  }
}

enum HashingAlgorithm { sha256, md5 }

extension ByteHasher on HashingAlgorithm {
  String hash(List<int> bytes) {
    Hash hash;

    switch (this) {
      case HashingAlgorithm.sha256:
        hash = sha256;
        break;
      case HashingAlgorithm.md5:
        hash = md5;
        break;
    }

    return hash.convert(bytes).toString();
  }

  String get name => toString().substring('$HashingAlgorithm.'.length);
}
