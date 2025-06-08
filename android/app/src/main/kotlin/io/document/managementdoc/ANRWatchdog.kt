package io.document.managementdoc

import android.app.ActivityManager
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.atomic.AtomicBoolean

class ANRWatchdog(
    private val context: Context,
    private val methodChannel: MethodChannel,
    private val timeoutMs: Long = 5000L
) {
    private val TAG = "ANRWatchdog"
    private val isRunning = AtomicBoolean(false)
    private val mainHandler = Handler(Looper.getMainLooper())
    private var watchdogThread: Thread? = null
    private var lastHeartbeat = System.currentTimeMillis()

    fun start() {
        if (isRunning.get()) {
            Log.w(TAG, "ANR Watchdog already running")
            return
        }

        isRunning.set(true)
        lastHeartbeat = System.currentTimeMillis()

        // Start heartbeat on main thread
        startHeartbeat()

        // Start watchdog thread
        watchdogThread = Thread {
            watchdogLoop()
        }.apply {
            name = "ANRWatchdog"
            isDaemon = true
            start()
        }

        Log.i(TAG, "ANR Watchdog started with timeout: ${timeoutMs}ms")
    }

    fun stop() {
        if (!isRunning.get()) {
            return
        }

        isRunning.set(false)
        watchdogThread?.interrupt()
        watchdogThread = null

        Log.i(TAG, "ANR Watchdog stopped")
    }

    private fun startHeartbeat() {
        val heartbeatRunnable = object : Runnable {
            override fun run() {
                if (isRunning.get()) {
                    lastHeartbeat = System.currentTimeMillis()
                    mainHandler.postDelayed(this, 1000) // Heartbeat every second
                }
            }
        }
        mainHandler.post(heartbeatRunnable)
    }

    private fun watchdogLoop() {
        while (isRunning.get() && !Thread.currentThread().isInterrupted) {
            try {
                Thread.sleep(2000) // Check every 2 seconds

                val currentTime = System.currentTimeMillis()
                val timeSinceLastHeartbeat = currentTime - lastHeartbeat

                if (timeSinceLastHeartbeat > timeoutMs) {
                    handleANRDetected(timeSinceLastHeartbeat)
                }

                // Check memory pressure
                checkMemoryPressure()

            } catch (e: InterruptedException) {
                Log.i(TAG, "ANR Watchdog interrupted")
                break
            } catch (e: Exception) {
                Log.e(TAG, "Error in ANR watchdog loop", e)
            }
        }
    }

    private fun handleANRDetected(duration: Long) {
        Log.w(TAG, "ANR detected! Main thread unresponsive for ${duration}ms")

        try {
            // Get stack trace of main thread
            val stackTrace = getMainThreadStackTrace()

            // Notify Flutter side
            mainHandler.post {
                methodChannel.invokeMethod("onANRDetected", mapOf(
                    "duration" to duration,
                    "stackTrace" to stackTrace,
                    "timestamp" to System.currentTimeMillis()
                ))
            }

            // Reset heartbeat to avoid repeated ANR detection
            lastHeartbeat = System.currentTimeMillis()

        } catch (e: Exception) {
            Log.e(TAG, "Error handling ANR detection", e)
        }
    }

    private fun getMainThreadStackTrace(): String {
        return try {
            val mainThread = Looper.getMainLooper().thread
            val stackTrace = mainThread.stackTrace
            stackTrace.joinToString("\n") { it.toString() }
        } catch (e: Exception) {
            "Unable to get stack trace: ${e.message}"
        }
    }

    private fun checkMemoryPressure() {
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memoryInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memoryInfo)

            val availableMemoryMB = memoryInfo.availMem / (1024 * 1024)
            val totalMemoryMB = memoryInfo.totalMem / (1024 * 1024)
            val usedMemoryPercent = ((totalMemoryMB - availableMemoryMB) * 100) / totalMemoryMB

            // If memory usage is above 85%, notify Flutter
            if (usedMemoryPercent > 85) {
                mainHandler.post {
                    methodChannel.invokeMethod("onLowMemory", mapOf(
                        "availableMemoryMB" to availableMemoryMB,
                        "totalMemoryMB" to totalMemoryMB,
                        "usedPercent" to usedMemoryPercent,
                        "lowMemory" to memoryInfo.lowMemory
                    ))
                }
            }

        } catch (e: Exception) {
            Log.e(TAG, "Error checking memory pressure", e)
        }
    }

    fun getMemoryPressureLevel(): String {
        return try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memoryInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memoryInfo)

            val availableMemoryMB = memoryInfo.availMem / (1024 * 1024)
            val totalMemoryMB = memoryInfo.totalMem / (1024 * 1024)
            val usedMemoryPercent = ((totalMemoryMB - availableMemoryMB) * 100) / totalMemoryMB

            when {
                usedMemoryPercent > 90 -> "critical"
                usedMemoryPercent > 80 -> "high"
                usedMemoryPercent > 60 -> "medium"
                else -> "low"
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error getting memory pressure level", e)
            "unknown"
        }
    }

    fun heartbeat() {
        lastHeartbeat = System.currentTimeMillis()
    }
}
