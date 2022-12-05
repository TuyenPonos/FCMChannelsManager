package com.ponos.fcm_channels_manager

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FcmChannelsManagerPlugin */
class FcmChannelsManagerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    var TAG: String? = "FCMChannelsManagerPlugin"
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "fcm_channels_manager")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val methodName = call.method
        Log.i(TAG, methodName)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            result.success("Android version code must be at least Oreo")
            return
        }
        if (methodName == "registerChannel") {
            try {
                val id: String? = call.argument("id")
                val name: String? = call.argument("name")
                val description: String? = call.argument("description")
                val importance: Int = call.argument("importance") ?: 3
                val visibility: Int = call.argument("visibility") ?: 1
                val allowBubbles: Boolean = call.argument("bubbles") ?: true
                val enableVibration: Boolean = call.argument("vibration") ?: true
                val enableSound: Boolean = call.argument("sound") ?: true
                val showBadge: Boolean = call.argument("badge") ?: true
                if (id == null || name == null) {
                    result.success("Channel's id and channel's name are required")
                    return
                }
                val notificationChannel = NotificationChannel(id, name, importance)
                notificationChannel.description = description
                notificationChannel.setShowBadge(showBadge)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    notificationChannel.setAllowBubbles(allowBubbles)
                }
                notificationChannel.lockscreenVisibility = visibility
                notificationChannel.enableVibration(enableVibration)
                if (enableSound) {
                    val attributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                        .build()
                    notificationChannel.setSound(
                        Settings.System.DEFAULT_NOTIFICATION_URI,
                        attributes
                    )
                }
                val notificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(notificationChannel)
                result.success(
                    "Channel $id has been registered successfully!"
                )
            } catch (e: Exception) {
                result.success("Could not register channel: " + e?.message);
            }

        } else if (methodName == "unregisterChannel") {
            try {
                val id: String? = call.argument("id")
                if (id == null) {
                    result.success("Channel's id is required")
                    return
                }
                val notificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.deleteNotificationChannel(id)
                result.success(
                    "Channel $id has been unregistered successfully!"
                )
            } catch (e: Exception) {
                result.success("Could not unregister channel: " + e?.message);
            }
        } else if (methodName == "getChannels") {
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channels: HashMap<String, String> = HashMap<String, String>()
            for (channel in notificationManager.notificationChannels) {
                channels[channel.id] = "" +
                        "{\"id\":\"${channel.id}\"," +
                        "\"name\":\"${channel.name}\"," +
                        "\"description\":\"${channel.description}\"," +
                        "\"importance\":\"${channel.importance}\"" +
                        "}"
            }
            result.success(channels);
        } else {
            Log.i(TAG, "Method $methodName is not supported!")
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
