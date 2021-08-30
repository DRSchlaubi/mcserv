import 'package:file/file.dart';
import 'package:mcserv/utils/platform_utils/platform_utils.dart';

import 'adoptium_jdk_installer.dart';

class LinuxAdoptiumJDKInstaller extends AdoptiumJDKInstaller {
  @override
  Future<void> processUnpackedJDK(Directory jdk) =>
      recursiveChmod(jdk.childDirectory('bin'), 0x755);
}
