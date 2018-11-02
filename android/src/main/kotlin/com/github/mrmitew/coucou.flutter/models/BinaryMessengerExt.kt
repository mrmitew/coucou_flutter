package com.github.mrmitew.coucou.flutter.models

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

fun BinaryMessenger.createMethodChannel(name: String, handler: MethodChannel.MethodCallHandler) =
        MethodChannel(this, name)
                .setMethodCallHandler(handler)

fun BinaryMessenger.createEventChannel(name: String, handler: EventChannel.StreamHandler) =
        EventChannel(this, name)
                .setStreamHandler(handler)