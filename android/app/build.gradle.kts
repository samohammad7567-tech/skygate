plugins {
    id("com.android.application")
    // Reads android/app/google-services.json — the tourism module's FCM setup.
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Matches the package_name in google-services.json; changing it breaks FCM.
    namespace = "com.eliasdahi.skygate"
    compileSdk = flutter.compileSdkVersion
    // Pinned by the tourism module's native dependencies (maps, mrz scanner).
    ndkVersion = "27.0.12077973"

    compileOptions {
        // flutter_local_notifications needs the desugared java.time APIs.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.eliasdahi.skygate"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // The merged app carries both feature sets — past the 64k method limit.
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
