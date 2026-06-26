plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must be applied after Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    namespace = "com.example.eztrack_rental"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {

        applicationId = "com.tarrance.eztrackrental"

        // Flutter supported SDKs
        minSdk = 29
        targetSdk = 36

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Manifest placeholder
        manifestPlaceholders["removeMediaPermissions"] = "true"
    }

    signingConfigs {
        create("release") {
            keyAlias = "vaccine"
            keyPassword = "123456"
            storeFile = file("/Users/sky/Dev/Narkhi/eztrack_rental/android/app/vaccine.jks")
            storePassword = "123456"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

/**
 * Android 15 / 16KB page-size compatibility fix
 * Forces MLKit barcode version that supports 16KB pages
 */
configurations.all {
    resolutionStrategy {
        force("com.google.mlkit:barcode-scanning:17.3.0")
    }
}

//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//android {
//    namespace = "com.example.eztrack_rental"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_17
//        targetCompatibility = JavaVersion.VERSION_17
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_17.toString()
//    }
//
//    defaultConfig {
//        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.tarrance.eztrackrental"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = 29 //flutter.minSdkVersion
//        targetSdk = 36 //flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//        manifestPlaceholders["removeMediaPermissions"] = "true"
//    }
//
//    signingConfigs {
//        create("release") {
//            // debug open ssl key
//            // keytool -exportcert -alias androiddebugkey -keystore debug.keystore | openssl sha1 -binary | openssl base64
//
//            // debug SHA key
//            // keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
//
//            // create jks
//            // keytool -genkey -v -keystore /Users/apple/Devlopment/Github/airport_service.jks -keyalg RSA -keysize 2048 -validity 10000 -alias airport_service -keypass Devloper123
//
//            // get SHA
//            // keytool -list -v -keystore /Users/apple/development/GitHub/LTS-Flutter/android/app/airport_service.jks -alias airport_service -storepass Devloper123 -keypass Devloper123
//
//            keyAlias = "vaccine"
//            keyPassword = "123456"
//            storeFile = file("/Users/sky/Dev/Narkhi/eztrack_rental/android/app/vaccine.jks")
//            storePassword = "123456"
//        }
//    }
//    buildTypes {
//        getByName("release") {
//            // TODO: Replace with your secure signing config
//            signingConfig = signingConfigs.getByName("release")
//            isMinifyEnabled = false
//            isShrinkResources = false
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}
//
//// Android 15 / 16KB page-size compatibility:
//// Our current dependency graph pulls `com.google.mlkit:barcode-scanning:17.2.0`,
//// which bundles `libbarhopper_v3.so` built for 4KB pages. Force a version that
//// includes 16KB page-size support.
//configurations.all {
//    resolutionStrategy {
//        force("com.google.mlkit:barcode-scanning:17.3.0")
//    }
//}
