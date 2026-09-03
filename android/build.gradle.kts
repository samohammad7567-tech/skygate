allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// google_mlkit_commons 0.6.1 — pulled in by mrz_scanner_plus 0.0.6, which the
// passport scanner needs and which cannot be upgraded (0.0.7+ wants intl 0.19,
// the Flutter SDK ships 0.20.2) — still declares compileSdk 29. AGP 9 turns the
// resulting androidx dependency mismatch into a build failure, so any plugin
// left below 34 is raised to the app's compile level. Set reflectively: the
// property moved between AGP DSL versions.
fun Project.raiseLegacyPluginCompileSdk() {
    val androidExtension = extensions.findByName("android") ?: return
    val getCompileSdk = androidExtension.javaClass.methods
        .firstOrNull { it.name == "getCompileSdk" && it.parameterCount == 0 } ?: return
    val setCompileSdk = androidExtension.javaClass.methods
        .firstOrNull { it.name == "setCompileSdk" && it.parameterCount == 1 } ?: return
    val current = getCompileSdk.invoke(androidExtension) as? Int
    if (current == null || current < 34) {
        setCompileSdk.invoke(androidExtension, 36)
    }
}

subprojects {
    // :app is already evaluated by the evaluationDependsOn above, and
    // afterEvaluate throws on an evaluated project — apply it directly there.
    if (state.executed) {
        raiseLegacyPluginCompileSdk()
    } else {
        afterEvaluate { raiseLegacyPluginCompileSdk() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
