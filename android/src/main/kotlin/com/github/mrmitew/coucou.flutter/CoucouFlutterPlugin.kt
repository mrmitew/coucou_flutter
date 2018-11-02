package com.github.mrmitew.coucou.flutter

import android.content.Context
import com.github.mrmitew.coucou.Coucou
import com.github.mrmitew.coucou.driver.impl.nsd.NsdManagerDriver
import com.github.mrmitew.coucou.flutter.discovery.DiscoveryStreamHandler
import com.github.mrmitew.coucou.flutter.models.createEventChannel
import com.github.mrmitew.coucou.flutter.models.createMethodChannel
import com.github.mrmitew.coucou.models.Disposable
import com.github.mrmitew.coucou.platform.impl.android.AndroidPlatform
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class CoucouFlutterPlugin(private val context: Context,
                                    binaryMessenger: BinaryMessenger) :
        MethodCallHandler, Disposable {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            // no-op
        }

        const val PLUGIN_PACKAGE = "com.github.mrmitew.coucou.flutter"

        const val METHOD_CHANNEL = "$PLUGIN_PACKAGE/method_channel"
        const val DISCOVERY_EVENT_CHANNEL = "$PLUGIN_PACKAGE/discovery_event_channel"

        const val STOP_DISCOVERY = "stopDiscovery"
        const val START_BROADCAST = "startBroadcast"
        const val STOP_BROADCAST = "stopBroadcast"
    }

    private val coucou by lazy {
        Coucou.create {
            platform { AndroidPlatform(context) }
            driver { NsdManagerDriver(context) }
        }
    }

    private val discoveryStreamHandler: DiscoveryStreamHandler = DiscoveryStreamHandler(coucou)

    init {
        binaryMessenger.createMethodChannel(METHOD_CHANNEL, this)
        binaryMessenger.createEventChannel(DISCOVERY_EVENT_CHANNEL, discoveryStreamHandler)
    }

    override fun dispose() = discoveryStreamHandler.dispose()

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" ->
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            STOP_DISCOVERY -> {
                stopDiscovery().run {
                    result.success(true)
                }
            }
            START_BROADCAST -> {
                // TODO
                result.notImplemented()
            }
            STOP_BROADCAST -> {
                // TODO
                result.notImplemented()
            }
            else -> result.notImplemented()
        }
    }

    // TODO: Pass some sort of key identifier to filter for a given discovery
    private fun stopDiscovery() {
        discoveryStreamHandler.dispose()
    }
}