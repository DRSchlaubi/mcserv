import org.gradle.api.tasks.Exec

fun Exec.wix(binary: String, vararg args: String) {
    onlyIf {
        System.getProperty("os.name").startsWith("Windows")
    }
    if (!System.getProperty("os.name").startsWith("Windows"))
        return
    val wixHome = System.getenv("WIX") ?: error("Please install the WIX toolset")
    commandLine = listOf(
        "$wixHome/bin/$binary", *args
    )
}
