package io.document.managementdoc

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.managementdoc/anr_recovery"
    private var anrWatchdog: ANRWatchdog? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "configureANRDetection" -> {
                    val arguments = call.arguments as? Map<String, Any>
                    val timeout = (arguments?.get("watchdogTimeout") as? Int)?.toLong() ?: 5000L
                    val enableWatchdog = arguments?.get("enableNativeWatchdog") as? Boolean ?: true

                    if (enableWatchdog) {
                        configureANRDetection(methodChannel, timeout)
                        result.success("ANR detection configured")
                    } else {
                        result.success("ANR detection disabled")
                    }
                }
                "getMemoryPressure" -> {
                    val pressure = anrWatchdog?.getMemoryPressureLevel() ?: "unknown"
                    result.success(pressure)
                }
                "heartbeat" -> {
                    anrWatchdog?.heartbeat()
                    result.success("heartbeat")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun configureANRDetection(methodChannel: MethodChannel, timeoutMs: Long) {
        try {
            anrWatchdog?.stop()
            anrWatchdog = ANRWatchdog(this, methodChannel, timeoutMs)
            anrWatchdog?.start()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Failed to configure ANR detection", e)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        anrWatchdog?.stop()
    }

    override fun onPause() {
        super.onPause()
        anrWatchdog?.stop()
    }

    override fun onResume() {
        super.onResume()
        anrWatchdog?.start()
    }
}
