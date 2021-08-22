import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:console/console.dart';
import 'package:crypto/crypto.dart';
import 'package:file/file.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import '../utils/confirm.dart';

var _log = Logger('Downloader');

class Download {
  final Uri uri;
  final String checksum;

  Download(this.uri, this.checksum);

  Future<void> download(File destination) async {
    _log.fine('Starting download to $uri');

    var client = Client();
    var request = await client.send(Request('GET', uri));
    var contentLength = request.contentLength!;
    var progress =
        ProgressBar(complete: contentLength);

    var chunks = await request.stream.map((s) {
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
          'Received invalid status code: ${request.statusCode} Body: ${utf8.decode(bytes)}');
    }

    _log.fine('Expected SHA-256 checksum: $checksum');
    var digestHex = sha256.convert(bytes).toString();
    _log.fine('Actual SHA-256 checksum: $digestHex');

    if (digestHex != checksum) {
      if (!confirm(
          'Checksum validation failed, do you want to continue anyways?',
          waitForNewLine: true)) {
        exit(1);
      }
    }

    _log.fine('Checksum test passed! Writing bytes to file!');
    print('Download finished, syncing changes to fs!');
    await destination.writeAsBytes(bytes);
  }
}
