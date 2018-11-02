package com.github.mrmitew.coucou.flutter.models

import com.github.mrmitew.coucou.models.DiscoveryService

fun DiscoveryService.asMap(): Map<String, Any> = mapOf(
        Pair("type", type),
        Pair("name", name),
        Pair("v4Host", v4Host?.hostAddress ?: ""),
        Pair("v6Host", v6Host?.hostAddress ?: ""),
        Pair("port", port),
        Pair("txtRecords", txtRecords)
)