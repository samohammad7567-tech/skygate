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
    if (state.executed) {
        raiseLegacyPluginCompileSdk()
    } else {
        afterEvaluate { raiseLegacyPluginCompileSdk() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
