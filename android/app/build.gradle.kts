plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.smartcitty"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Tentukan versi NDK yang diperlukan oleh plugin

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.smartcitty"  // ID aplikasi yang unik
        minSdk = flutter.minSdkVersion  // Min SDK yang digunakan oleh aplikasi
        targetSdk = flutter.targetSdkVersion  // Target SDK yang digunakan oleh aplikasi
        versionCode = flutter.versionCode  // Kode versi aplikasi
        versionName = flutter.versionName  // Nama versi aplikasi
    }

    buildTypes {
        release {
            // Gunakan kunci signing yang sesuai untuk build rilis.
            signingConfig = signingConfigs.getByName("debug")  // Sementara menggunakan kunci debug
        }
    }
}

flutter {
    source = "../.."  // Menentukan lokasi Flutter SDK
}
