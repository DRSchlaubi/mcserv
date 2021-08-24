import 'settings.dart';
import 'settings_loader.dart';

Future<void> addServer(Installation installation) async {
  var settings = await loadSettings();

  var newSettings = Settings([...settings.installations, installation]);

  await saveSettings(newSettings);
}

Future<void> updateServer(Installation installation) async {
  var settings = await loadSettings();

  settings.installations
      .removeWhere((element) => element.location == installation.location);
  var newSettings = Settings([...settings.installations, installation]);

  await saveSettings(newSettings);
}

Future<void> removeServer(String path) async {
  var settings = await loadSettings();
  settings.installations.removeWhere((element) => element.location == path);

  await saveSettings(settings);
}
