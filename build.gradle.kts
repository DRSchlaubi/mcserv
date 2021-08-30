plugins {
    base
    id("local-properties")
}

version = "1.0.0"

fun Exec.dart(binary: String, vararg args: String) {
    group = "dart"
    commandLine = listOf("${localProperties.dartSdk}/bin/$binary", *args)
}

tasks {
    val dartGenerate = register<Exec>("dartGenerate") {
        dart("pub", "run", "build_runner", "build", "--delete-conflicting-outputs")
    }

    register<Exec>("dartBuildArb") {
        dart("pub", "run", "intl_translation:extract_to_arb", "--output-dir=i18n", "bin/intl/localizations.dart")
    }

    register<Exec>("dartReadArb") {
            dart(
            "pub",
            "run",
            "intl_translation:generate_from_arb",
            "--output-dir=bin/intl",
            "--no-use-deferred-loading",
            "bin/intl/localizations.dart",
            "i18n/intl_*.arb"
        )
    }

    val dartBuild = register<Exec>("dartBuild") {
        val fileName = if (System.getProperty("os.name").startsWith("Windows")) "mcserv.exe" else "mcserv"
        val destinationDir = project.buildDir.resolve("dart")
        doFirst {
            destinationDir.mkdirs()
        }
        val destinationFile = destinationDir.resolve(fileName)
        group = "dart"
        commandLine = listOf(
            "dart2native",
            project.file("bin/mcserv.dart").absolutePath,
            "-o",
            destinationFile.absolutePath
        )
        dependsOn(dartGenerate)
        outputs.file(destinationFile)
        inputs.files(project.file("lib"), project.file("i18n"), project.file("bin"))
    }

    assemble {
        dependsOn(dartBuild)
    }

    val profiles = listOf("Release", "Debug")

    for (profile in profiles) {
        val lowerCaseProfile = profile.toLowerCase(java.util.Locale.ROOT)
        val packageDir = project.buildDir.resolve("package").resolve(lowerCaseProfile)
        val copyPackage = register<Copy>("copy${profile}Package") {
            val nativeBuild = project.subprojects.first { it.name == "libmcserv" }
                .tasks.getByName("link$profile")
            group = "packaging"
            from(
                dartBuild,
                project.file("libmcserv/build/lib/main/$lowerCaseProfile/liblibmcserv.so"),
                project.file("LICENSE"),
                project.file("README.md")
            )
            into(packageDir)
            dependsOn(assemble, nativeBuild)
        }
        val archiveBuilder: AbstractArchiveTask.() -> Unit = {
            group = "packaging"
            destinationDirectory.set(project.buildDir.resolve("packages/$lowerCaseProfile"))
            from(packageDir.absolutePath)
            dependsOn(copyPackage)
            val customArchiveName = project.findProperty("archiveName")
            if (customArchiveName != null) {
                archiveFileName.set("$customArchiveName.${archiveExtension.get()}")
            }
        }
        val zipPackage = register<Zip>("zip${profile}Package", archiveBuilder)
        val tarPackage = register<Tar>("tar${profile}Package", archiveBuilder)
        register("create${profile}Package") {
            group = "packaging"
            dependsOn(zipPackage, tarPackage)
        }
    }
}
