package com.github.mrmitew.coucou.flutter.models

import com.github.mrmitew.coucou.models.DiscoveryEvent
import com.github.mrmitew.coucou.models.DiscoveryService

fun DiscoveryEvent.asMap(): Map<String, Any?> {
    val service: DiscoveryService? = when {
        this is DiscoveryEvent.ServiceResolved -> this.service
        this is DiscoveryEvent.ServiceResolved -> this.service
        else -> null
    }

    return mapOf(
            Pair("event", when {
                this is DiscoveryEvent.ServiceResolved -> "resolved"
                this is DiscoveryEvent.ServiceLost -> "lost"
                else -> "failure"
            }),
            Pair("service", service?.asMap()))
}
