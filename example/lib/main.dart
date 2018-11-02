import 'dart:async';

import 'package:coucou_flutter/coucou.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const SERVICE_TYPE_HTTP = "_http._tcp";

///
/// TODO: Rework the entire example app
///

void main() => runApp(CoucouDemoApp());

class CoucouDemoApp extends StatefulWidget {
  @override
  _CoucouDemoAppState createState() => new _CoucouDemoAppState();
}

class _CoucouDemoAppState extends State<CoucouDemoApp> {
  String _platformVersion = 'Unknown';
  StreamSubscription _discoveryStream;

  // TODO: Provide as a dependency
  Coucou coucou;
  PlatformRepository platformRepository;

  List<Object> _eventLog = List();

  @override
  void initState() {
    coucou = Coucou();
    platformRepository = coucou;
    super.initState();
    _initPlatformState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startDiscovery();
  }

  void _startDiscovery() {
    void _onEvent(Object event) {
      setState(() {
        _eventLog.add(event);
      });
    }

    void _onError(Object error) {
      setState(() {
        _eventLog.add(error);
      });
    }

    _discoveryStream = coucou
        .startDiscovery(SERVICE_TYPE_HTTP)
        .listen(_onEvent, onError: _onError);
  }

  @override
  void dispose() {
    _discoveryStream.cancel();
    super.dispose();
  }

  Future<void> _initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await platformRepository.platformInformation;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    // TODO: Use a stream builder with a publish subject

    if (_eventLog.length == 0) {
      body = Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        itemBuilder: (context, index) =>
            ListTile(title: Text(_eventLog[index].toString())),
        itemCount: _eventLog.length,
      );
    }

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Coucou ($_platformVersion)"),
          ),
          body: body),
    );
  }
}
