import dev.schlaubi.mcserv.gradle.LocalProperties
import org.gradle.api.tasks.Exec
import org.gradle.kotlin.dsl.getByName

fun Exec.dart(binary: String, vararg args: String, fileEnding: String = "bat") {
    group = "dart"
    commandLine =
        listOf(path(fileEnding, project.extensions.getByName<LocalProperties>("localProperties").dartSdk, "bin", binary), *args)
}
