package dev.schlaubi.mcserv.gradle

import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.create
import java.nio.file.Files
import java.nio.file.Path
import java.util.Properties

val dartSdk: String
    get() = properties.getProperty("dart.sdk") ?: error("dart.sdk")

private class LocalPropertiesPlugin : Plugin<Project> {
    private val properties: Properties = Properties()

    override fun apply(target: Project) {
        target.extensions.create<LocalProperties>("localProperties", properties)

        val file = target.rootDir.toPath().resolve("local.properties")

        if (!Files.exists(file)) {
            Files.createFile(file)
        }

        Files.newBufferedReader(file).use { properties.load(it) }

    }
}

abstract class LocalProperties(private val properties: Properties) {
    val dartSdk: String
        get() = this["dart.sdk"]

    operator fun get(name: String) = properties.getProperty(name) ?: notFound(name)

    private fun notFound(name: String): Nothing = error("Please specify $name in local.properties")
}

private val properties = Properties().apply {
    val properties = Path.of("hi")
    if (!Files.exists(properties)) {
        Files.createFile(properties)
    }

    load(Files.newBufferedReader(Path.of("local.properties")))
}
