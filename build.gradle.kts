tasks {
    register<Exec>("dartGenerate") {
        group = "dart"
        commandLine = listOf("dart", "run", "build_runner", "build")
    }

    register<Exec>("dartBuildArb") {
        group = "dart"
        commandLine = listOf("pub", "run", "intl_translation:extract_to_arb", "--output-dir=i18n", "bin/intl/localizations.dart")
    }

    register<Exec>("dartReadArb") {
        group = "dart"
        commandLine = listOf("pub", "run", "intl_translation:generate_from_arb", "--output-dir=bin/intl", "--no-use-deferred-loading", "bin/intl/localizations.dart", "i18n/intl_*.arb")
    }
}
