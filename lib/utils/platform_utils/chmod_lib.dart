import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/utils/utils.dart';
import 'package:path/path.dart' as path;

final _log = Logger('NativeCaller');

Future<void> recursiveChmod(Directory directory, int mode) async {
  var files = directory.list();

  await files.forEach((element) => NativeLib.runChmod(element, mode));
}

class NativeLib {
  static int runChmod(FileSystemEntity file, int mode) {
    if (Platform.isWindows) {
      throw Exception('chmod library is not available on windows.');
    }

    if (_dylib == null) {
      throw Exception('chmod native library is not loaded');
    }

    final path = file.absolute.path;
    _log.fine('Calling native chmod lib for file $path -> $mode');
    final chmod = _dylib!.lookupFunction<_ChmodNative, _Chmod>('run_chmod');
    final pathUtf8 = path.toNativeUtf8();

    final exitCode = chmod(pathUtf8, mode);
    _log.fine('chmod exited with code: $exitCode');

    calloc.free(pathUtf8);

    return exitCode;
  }
}

final _dylib = _load();

// C Function: int run_chmod(char *path, int mode)
typedef _ChmodNative = Int32 Function(Pointer<Utf8> path, Int32 mode);
typedef _Chmod = int Function(Pointer<Utf8> path, int mode);

DynamicLibrary? _load() {
  if (Platform.isWindows) {
    return null;
  }

  String programDirectory;
  // Check if we are in a development environment
  if (!isDevelopmentEnvironment()) {
    programDirectory = path.joinAll(getInstallationDirectory());
  } else {
    programDirectory = path.join(
        Directory.current.path, 'libmcserv', 'build', 'lib', 'main', 'debug');
  }
  // Open the dynamic library
  var libraryPath = path.join(programDirectory, 'liblibmcserv.so');

  if (Platform.isMacOS) {
    libraryPath = path.join(programDirectory, 'liblibmcserv.dylib');
  }

  return DynamicLibrary.open(libraryPath);
}
