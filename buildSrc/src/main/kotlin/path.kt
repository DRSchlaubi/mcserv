import org.gradle.internal.os.OperatingSystem

fun path(vararg parts: String, appendEnding: Boolean = false): String {
    return if(OperatingSystem.current().isWindows) {
        parts.joinToString("""\""") + ".bat"
    } else {
        parts.joinToString("/")
    }
}
