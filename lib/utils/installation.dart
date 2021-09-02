import 'dart:io';

List<String> getInstallationDirectory() {
  final scriptLocation = Platform.resolvedExecutable.replaceAll('\\', '/');
  return scriptLocation
      .substring(0, scriptLocation.lastIndexOf('/'))
      .split(RegExp("(?<!^)\/"));
}

bool isDevelopmentEnvironment() =>
    Platform.resolvedExecutable.endsWith("dart") ||
    Platform.resolvedExecutable.endsWith("dart.exe");
