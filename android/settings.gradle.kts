pluginManagement {
    // Nécessite FLUTTER_HOME défini (voir plus bas)
    val flutterSdk = System.getenv("FLUTTER_HOME")
        ?: throw GradleException(
            "FLUTTER_HOME is not set. Set it to your Flutter SDK path.\n" +
                    "Example (Linux/macOS): export FLUTTER_HOME=\$(dirname \$(dirname \$(which flutter)))"
        )

    // Donne accès au plugin Flutter
    includeBuild("$flutterSdk/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

include(":app")
