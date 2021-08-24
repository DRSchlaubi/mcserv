      
// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  static m0(eula) => "Do you accept the MC Eula? (${eula})";

  static m1(languageVersion, update, path) => "Java ${languageVersion} (${update}) at ${path}";

  static m2(distributionName, version, build, location) => "${distributionName} ${version} (${build}) at ${location}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
    "acceptEula" : m0,
    "alreadyOnLatestBuild" : MessageLookupByLibrary.simpleMessage("You already have the latest build"),
    "chooseServer" : MessageLookupByLibrary.simpleMessage("Choose a server"),
    "chooseServerDistro" : MessageLookupByLibrary.simpleMessage("Chose Server Distribution"),
    "chooseServerSubVersion" : MessageLookupByLibrary.simpleMessage("Choose Subversion"),
    "chooseServerVersion" : MessageLookupByLibrary.simpleMessage("Choose Server Version"),
    "confirmDelete" : MessageLookupByLibrary.simpleMessage("Do you really want to delete this server?"),
    "createDestinationDirectory" : MessageLookupByLibrary.simpleMessage("The specified directory is not empty, do you want to proceed?"),
    "deleteCommand" : MessageLookupByLibrary.simpleMessage("Delete a server"),
    "destinationDirectory" : MessageLookupByLibrary.simpleMessage("Destination Directory"),
    "detectCommand" : MessageLookupByLibrary.simpleMessage("Add an existing server"),
    "downloadDone" : MessageLookupByLibrary.simpleMessage("Download finished, syncing changes to fs!"),
    "downloadingDistro" : MessageLookupByLibrary.simpleMessage("Downloading Distribution"),
    "helpFlagHelp" : MessageLookupByLibrary.simpleMessage("Prints this help message"),
    "javaInstallation" : m1,
    "logLevelHelp" : MessageLookupByLibrary.simpleMessage("Sets the log level"),
    "newCommand" : MessageLookupByLibrary.simpleMessage("Create a new server"),
    "noServersYet" : MessageLookupByLibrary.simpleMessage("You don\'t have any servers yet"),
    "overwriteDestinationDirectory" : MessageLookupByLibrary.simpleMessage("Specified directory does not exist, do you want to create it?"),
    "overwriteExistingJava" : MessageLookupByLibrary.simpleMessage("Selected JDK is already installed, do you want to overwrite it?"),
    "pickCommand" : MessageLookupByLibrary.simpleMessage("What do you want to do?"),
    "pickJavaInstallation" : MessageLookupByLibrary.simpleMessage("Which Java installation do you want to use?"),
    "pickLanguageVersion" : MessageLookupByLibrary.simpleMessage("Which version do you want to install?"),
    "serverInstallation" : m2,
    "updateCommand" : MessageLookupByLibrary.simpleMessage("Update an existing Server"),
    "upgradeVersion" : MessageLookupByLibrary.simpleMessage("Do you want to upgrade the version instead?"),
    "useAikarFlags" : MessageLookupByLibrary.simpleMessage("Do you want to use Aikar\'s JVM flags?"),
    "verboseLoggingHelp" : MessageLookupByLibrary.simpleMessage("Enables verbose logging")
  };
}
