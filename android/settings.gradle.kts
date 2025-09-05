pluginManagement {
    // Try FLUTTER_HOME first, then fallback to FLUTTER_ROOT (used in CI/CD)
    val flutterSdk = System.getenv("FLUTTER_HOME")
        ?: System.getenv("FLUTTER_ROOT")
        ?: throw GradleException(
            """
            Neither FLUTTER_HOME nor FLUTTER_ROOT are set.
            Please configure your Flutter SDK path.

            Example (Linux/macOS):
              export FLUTTER_HOME=$(dirname $(dirname $(which flutter)))
            """.trimIndent()
        )

    // Give access to Flutter Gradle tools
    includeBuild("$flutterSdk/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    plugins {
        id("dev.flutter.flutter-plugin-loader") version "1.0.0"
        // ✅ Monter AGP & Kotlin
        id("com.android.application") version "8.6.1"
        id("org.jetbrains.kotlin.android") version "2.1.0"
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader")
    // on n’applique pas AGP/Kotlin ici (apply false), ils sont appliqués dans :app
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
}

include(":app")
