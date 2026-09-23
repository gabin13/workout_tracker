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

// Workaround for abandoned plugins (isar_flutter_libs) that don't declare a
// namespace, which is required by Android Gradle Plugin 8+.
// See TODO.md — remove this once Isar is fully migrated away.
// NOTE: must be registered before evaluationDependsOn(":app") below, which
// triggers immediate evaluation of subprojects.
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension is com.android.build.gradle.LibraryExtension) {
            if (androidExtension.namespace == null) {
                androidExtension.namespace = group.toString()
            }
            // Legacy plugins may pin an old compileSdk that lacks newer
            // android attrs (e.g. lStar requires API 31+).
            if (androidExtension.compileSdk == null || androidExtension.compileSdk!! < 34) {
                androidExtension.compileSdk = 36
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
