# Flutter: keep engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.Log { *; }

# Nearby Connections
-keep class com.google.android.gms.nearby.** { *; }
-keep class com.google.android.gms.common.** { *; }

# FlutterBluePlus
-keep class com.lib.flutter_blue_plus.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

# Kotlin
-keep class kotlin.** { *; }

# Keep Gson/JSON serialization models (SignalPacket, etc.)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep class * implements com.google.gson.annotations.SerializedName { *; }
-keepclassmembers,allowobfuscation class * {
    <fields>;
}

# Play Core (needed by Flutter's PlayStoreDeferredComponentManager)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Platform channel method arguments
-keepclassmembers class * {
    @android.annotation.SuppressLint <fields>;
}
