part of system_info;

String get architecture => _getKernelArchitecture();

String _getKernelArchitecture() {
  var arch = _getKernelArchitectureRaw();

  if (arch.contains('x')) {
    if (arch.contains('64')) {
      return 'x64';
    } else if (arch.contains('86')) {
      return 'x86';
    }
  } else if (arch.contains('arm')) {
    return 'arm';
  }
  return arch;
}

String _getKernelArchitectureRaw() {
  switch (Platform.operatingSystem) {
    case 'linux':
    case 'macos':
      return _fluent(_exec('uname', ['-m'])).trim().stringValue;
    case 'windows':
      final wow64 =
          _fluent(Platform.environment['PROCESSOR_ARCHITEW6432']).stringValue;
      if (wow64.isNotEmpty) {
        return wow64;
      }
      return _fluent(Platform.environment['PROCESSOR_ARCHITECTURE'])
          .stringValue;
    default:
      throw UnsupportedError('Unsupported os: ${Platform.operatingSystem}');
  }
}
