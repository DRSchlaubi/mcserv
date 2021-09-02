import 'dart:io';

String getInstallationDirectory() {
  final scriptLocation = Platform.resolvedExecutable.replaceAll('\\', '/');
  return scriptLocation.substring(0, scriptLocation.lastIndexOf('/'));
}

bool isDevelopmentEnvironment() =>
    Platform.resolvedExecutable.endsWith("dart") ||
    Platform.resolvedExecutable.endsWith("dart.exe");
