import org.gradle.internal.os.OperatingSystem

fun path(fileEnding: String = "bat", vararg parts: String): String {
    return if(OperatingSystem.current().isWindows) {
        parts.joinToString("""\""") + "." + fileEnding
    } else {
        parts.joinToString("/")
    }
}
