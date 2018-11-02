[![pub package](https://img.shields.io/pub/v/coucou_flutter.svg)](https://pub.dartlang.org/packages/coucou_flutter)

# Coucou (Flutter)

Coucou is a network service discovery and broadcast library for Flutter that supports both Android and iOS.
The platform-specific implementations are utilizing [coucou_android](https://github.com/mrmitew/coucou_android) (v0.1.1) and [coucou_ios](https://github.com/mrmitew/coucou_ios) (v0.0.6).

*Note*: This plugin is still in very early stage of development and there are many things that are yet to be done. For more information, take a look at the todo list down below.

## Coucou API

The API is very similar to the ones on Android and iOS.
```dart
Stream<dynamic> startDiscovery(String type, {String domain = "local."});
Future<dynamic> stopDiscovery({String type});
Future<Disposable> startBroadcast(BroadcastConfig config);
Future<dynamic> stopBroadcast({BroadcastConfig config});
```

*Note*: The API will be slightly changed in a way that it will provide streams/futures of concrete types. For more information about future works, take a look at the todo section at the end of the readme.

### Creation
```dart
final coucou = Coucou();
```

### Network Service Discovery

```dart
final discovery = coucou.startDiscovery("_http._tcp").listen((event) {
  // TODO: Something with the current event
}, onError: (error) {
  // TODO: Something with the error
});

// .. when not needed, dispose

discovery.cancel();
coucou.stopDiscovery("_http._tcp");
```

### Network Service Broadcast
```dart
final broadcast = await coucou.startBroadcast(BroadcastConfig(
  type: "_http._tcp",
  name: "My service",
  port: 12345,
));

// when not needed, dispose
broadcast.dispose();
```

*Note*: Broadcast requests currently are not supported, but the API is there.

## Requirements
* Min sdk for Android is API level 16.
* Min iOS version is 8.0.

## TODO
- Support for network service broadcasts
- Acknowledge the domain parameter on the Android side for service discovery. This has to be implemented in the [coucou_android](https://github.com/mrmitew/coucou_android) project first.
- Provide a handier way to cancel a discovery, similar to how the iOS and Android implementations work.
- Support for multiple broadcasts running in parallel
- Support for multiple service discoveries running in parallel
- Better sample app that demonstrates the usage of this library
- Improve documentation
- Write tests

## Communication
* Author: Stefan Mitev
* E-mail: mr.mitew [at] gmail . com
* [Github issues](https://github.com/mrmitew/coucou_flutter/issues)

## Contribution
All development (both new features and bug fixes) is performed in develop branch. However, fixes to documentation in markdown files can be directly done in master. Please send PRs with bug fixes to develop branch. The develop branch is pushed to master during release.