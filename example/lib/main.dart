import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:macos_toast_kit/macos_toast_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _macosToastKitPlugin = MacosToastKit();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _macosToastKitPlugin.getPlatformVersion() ?? 'Unknown platform version';
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              // MacosToastKit().show();
              // MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝");
              // MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝", applicationMode: 1);
              MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝", applicationMode: 0, position: 0);
              // MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝", applicationMode: 0, position: 1);
              // MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝", applicationMode: 2, position: 2);
              // MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝", applicationMode: 2, position: 3);
              // MacosToastKit().show(systemImageName: "hammer.circle.fill", toastContent: "已拷贝", applicationMode: 2, position: 4);
            },
            child: Text('Running on: $_platformVersion\n'),
          ),
        ),
      ),
    );
  }
}
