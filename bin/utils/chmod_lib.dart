import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

var _log = Logger('NativeCaller');

class NativeLib {
  static int runChmod(File file, int mode) {
    var path = file.absolute.path;
    _log.fine('Calling native chmod lib for file $path -> $mode');
    final chmod = _dylib.lookupFunction<_ChmodNative, _Chmod>('run_chmod');
    var pathUtf8 = path.toNativeUtf8();

    var exitCode = chmod(pathUtf8, mode);
    _log.fine('chmod exited with code: $exitCode');

    calloc.free(pathUtf8);

    return exitCode;
  }
}

final _dylib = _load();

// C Function: int run_chmod(char *path, int mode)
typedef _ChmodNative = Int32 Function(Pointer<Utf8> path, Int32 mode);
typedef _Chmod = int Function(Pointer<Utf8> path, int mode);

DynamicLibrary _load() {
  // Open the dynamic library
  var libraryPath = path.join(
      Directory.current.path, 'chmod_lib', 'libmcserv_chmod.so');
  if (Platform.isMacOS) {
    libraryPath = path.join(
        Directory.current.path, 'chmod_lib', 'libmcserv_chmod.dylib');
  }
  if (Platform.isWindows) {
    libraryPath = path.join(Directory.current.path, 'chmod_lib',
        'Debug', 'libmcserv_chmod.dll');
  }

  return DynamicLibrary.open(libraryPath);
}
