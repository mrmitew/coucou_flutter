import 'dart:async';

import 'package:coucou_flutter/models/broadcast_config.dart';
import 'package:coucou_flutter/models/disposable.dart';
import 'package:flutter/services.dart';

const PLUGIN_PACKAGE = "com.github.mrmitew.coucou.flutter";

///
/// Only used for debugging and it will be removed soon.
///
abstract class PlatformRepository {
  Future<String> get platformInformation;
}

class Coucou implements PlatformRepository {
  static const _METHOD_CHANNEL = "$PLUGIN_PACKAGE/method_channel";
  static const _DISCOVERY_EVENT_CHANNEL =
      "$PLUGIN_PACKAGE/discovery_event_channel";

  static const _STOP_DISCOVERY = "stopDiscovery";
  static const _START_BROADCAST = "startBroadcast";
  static const _STOP_BROADCAST = "stopBroadcast";

  static const _GET_PLATFORM_INFORMATION = "getPlatformVersion";

  static const MethodChannel _methodChannel =
      const MethodChannel(_METHOD_CHANNEL);

  static const EventChannel _discoveryEventChannel =
      const EventChannel(_DISCOVERY_EVENT_CHANNEL);

  ///
  /// Experimental API to retrieve information about the host's platform where
  /// the plugin is currently working on
  ///
  @override
  Future<String> get platformInformation async =>
      await _methodChannel.invokeMethod(_GET_PLATFORM_INFORMATION);

  ///
  /// Starts a new network service discovery for a given service type.
  /// Optionally, you can specify a domain as well. By default, it will be
  /// "local."
  ///
  /// Returns a [Stream] with a [Map<String, String>] that represents the
  /// current discovery event.
  /// In order to stop the discovery, you should call [stopDiscovery] and also
  /// make sure to close the stream subscription.
  ///
  /// Note that  un future, stopping of discovery will be triggered automatically
  /// on closing of the stream.
  ///
  Stream<dynamic> startDiscovery(String type, {String domain = "local."}) =>
      _discoveryEventChannel
          .receiveBroadcastStream({"type": type, "domain": domain});

  ///
  /// Stops the network service discovery for the requested service type.
  /// If no type is specified, then it will stop any currently running service
  /// discoveries.
  ///
  Future<dynamic> stopDiscovery({String type}) async =>
      await _methodChannel.invokeMethod(_STOP_DISCOVERY, type);

  ///
  /// Starts a new broadcast with a given [BroadcastConfig].
  ///
  /// In order to stop a broadcast, execute the [dispose] method on the [Disposable],
  /// or execute [stopBroadcast], instead.
  ///
  Future<Disposable> startBroadcast(BroadcastConfig config) async {
    await _methodChannel.invokeMethod(_START_BROADCAST, config.toMap());

    // TODO: Throw an error if the operation failed, instead of returning a
    // disposable

    return Disposable(() {
      stopBroadcast(config: config);
    });
  }

  ///
  /// Stops any service broadcast that matches the provided [BroadcastConfig].
  /// If no config was specified, then it will cancel any existing service
  /// broadcasts.
  ///
  Future<dynamic> stopBroadcast({BroadcastConfig config}) async =>
      await _methodChannel.invokeMethod(_STOP_BROADCAST, config?.toMap());
}
