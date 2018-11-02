package com.github.mrmitew.coucou.flutter.discovery

import com.github.mrmitew.coucou.Coucou
import com.github.mrmitew.coucou.flutter.models.asMap
import com.github.mrmitew.coucou.models.DiscoveryEvent
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.experimental.CoroutineScope
import kotlinx.coroutines.experimental.Dispatchers
import kotlinx.coroutines.experimental.Job
import kotlinx.coroutines.experimental.launch
import kotlin.coroutines.experimental.CoroutineContext


// TODO(stefan): Add one more layer to provide multiple network service discoveries to run in parallel
// and also to be canceled individually.

internal class DiscoveryStreamHandler(private val coucou: Coucou)
    : EventChannel.StreamHandler, CoroutineScope {

    companion object {
        private const val DEFAULT_SERVICE_TYPE = "_http._tcp"
    }

    private val job = Job()
    override val coroutineContext: CoroutineContext get() = Dispatchers.Main + job

    private var currentEventChannel: EventChannel.EventSink? = null

    /**
     * Handles a request to set up an event stream.
     * Any uncaught exception thrown by this method will be caught by the channel implementation and logged.
     * An error result message will be sent back to Flutter.
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        currentEventChannel = events

        var type = DEFAULT_SERVICE_TYPE

        if (arguments != null) {
            if (arguments is Map<*, *>) {
                if(arguments.containsKey("type")){
                    type = arguments["type"] as? String ?: DEFAULT_SERVICE_TYPE
                }
            }
        }

        try {
            launch {
                // Init a new discovery
                coucou.startDiscovery(type) { event ->
                    when (event) {
                        is DiscoveryEvent.Failure -> {
                            events?.error("500", event.cause.message, event.cause)
                            cancel(0)
                        }
                        is DiscoveryEvent.ServiceResolved ->
                            events?.success(event.asMap())
                        is DiscoveryEvent.ServiceLost -> {
                            events?.success(event.asMap())
                        }
                    }
                }
            }
        } catch (e: Exception) {
            events?.error("500", e.message, e)
            cancel(0)
        }
    }

    /**
     * Closes the event stream and also stops discovery
     * TODO: Call when appropriate
     */
    private fun closeEventStream(eventSink: EventChannel.EventSink?) {
        eventSink?.endOfStream()
        dispose()
    }

    /**
     * Handles a request to tear down the most recently created event stream.
     * Any uncaught exception thrown by this method will be caught by the channel implementation and logged.
     * An error result message will be sent back to Flutter.
     *
     * The channel implementation may call this method with null arguments to separate a pair of two
     * consecutive set up requests. Such request pairs may occur during Flutter hot restart.
     * Any uncaught exception thrown in this situation will be logged without notifying Flutter.
     */
    override fun onCancel(arguments: Any?) {
        dispose()
    }

    fun dispose() {
        if (!job.isCancelled) {
            // Stops all discovery requests
            job.cancel()
        }

        currentEventChannel?.endOfStream()
    }

    // TODO: Stop a concrete discovery request
    fun cancel(id: Int) {
        if (!job.isCancelled) {
            job.cancel()
        }
    }
}