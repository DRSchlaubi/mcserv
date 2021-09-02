import org.jetbrains.changelog.date
import java.nio.file.Files
import java.io.BufferedReader
import java.io.InputStreamReader

plugins {
    base
    id("local-properties")
    id("org.jetbrains.changelog") version "1.2.1"
}

version = "0.0.1"

changelog {
    version.set(project.version.toString())
    path.set("${project.projectDir}/CHANGELOG.md")
    header.set(provider { "[${version.get()}] - ${date()}" })
    itemPrefix.set("-")
    keepUnreleasedSection.set(true)
    unreleasedTerm.set("[Unreleased]")
    groups.set(listOf("Added", "Changed", "Deprecated", "Removed", "Fixed", "Security"))
}

tasks {
    register<Exec>("dartPubGet") {
        dart("pub", "get")
    }

    val dartGenerate = register<Exec>("dartGenerate") {
        dart("pub", "run", "build_runner", "build", "--delete-conflicting-outputs")

        inputs.dir(project.file("bin"))
        inputs.dir(project.file("lib"))
        outputs.dirs(inputs.files)
    }

    register<Exec>("dartBuildArb") {
        dart("pub", "run", "intl_translation:extract_to_arb", "--output-dir=i18n", "lib/intl/localizations.dart")

        inputs.file("lib/intl/localizations.dart")
        outputs.dirs("i18n")
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

        inputs.dir("i18n")
        outputs.files("lib/localizations/*.dart")
    }

    fun gitCommitHash(): String {
        val process = Runtime.getRuntime().exec("git rev-parse --short HEAD")
        return BufferedReader(InputStreamReader(process.inputStream)).use {
            it.readLines().first()
        }
    }

    val versionFile = task("versionFile") {
        val outFile = project.buildDir.resolve("reports").resolve("version.txt").toPath()
        val parent = outFile.parent
        if(!Files.isDirectory(parent)) {
            Files.createDirectories(parent)
        }

        val version = project.version
        val buildId = System.getenv("GITHUB_RUN_ID") ?: "<local build>"
        val commitHash = System.getenv("GITHUB_SHA") ?: gitCommitHash()

        val string = "$version (Build: $buildId) (Commit: $commitHash)"

        Files.writeString(outFile, string)
        outputs.file(outFile.toFile())
    }

    val dartBuild = register<Exec>("dartBuild") {
        val fileName = if (System.getProperty("os.name").startsWith("Windows")) "mcserv.exe" else "mcserv"
        val destinationDir = project.buildDir.resolve("dart")
        doFirst {
            destinationDir.mkdirs()
        }
        val destinationFile = destinationDir.resolve(fileName)
        group = "dart"
        dart(
            "dart2native",
            project.file("bin/mcserv.dart").absolutePath,
            "-o",
            destinationFile.absolutePath
        )
        dependsOn(dartGenerate, versionFile)
        outputs.file(destinationFile)
        inputs.files(project.file("lib"), project.file("i18n"), project.file("bin"))
    }

    val wixCompile = task<Exec>("wixCompile") {
        dependsOn(dartBuild)
        val outDir = rootProject.buildDir.resolve("wix")
        inputs.dir(project.rootDir.resolve("packages").resolve("windows").resolve("msi"))
        outputs.dir(outDir)
        wix(
            "candle",
            rootProject.file("packages/windows/msi/McServInstaller/Product.wxs").absolutePath,
            "-o",
            outDir.absolutePath + '/' // withou the '/' WIX will create a file instead
        )
    }

    val wixLink = task<Exec>("wixLink") {
        dependsOn(wixCompile)

        val outFile = project.buildDir.resolve("distributions/mcserv.msi")
        outputs.file(outFile)

        wix(
            "light",
            project.buildDir.resolve("wix/Product.wixobj").absolutePath,
            "-o",
            outFile.absolutePath
        )
    }

    register("assembleMsi") {
        onlyIf {
            System.getProperty("os.name").startsWith("Windows")
        }
        dependsOn(wixLink)
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
                project.file("README.md"),
                versionFile
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
        val tarPackage = register<Tar>("tar${profile}Package") {
            compression = Compression.GZIP
            archiveExtension.set("tar.gz")
            archiveBuilder()
        }

        register("create${profile}Package") {
            group = "packaging"
            dependsOn(zipPackage, tarPackage)
        }
    }
}
