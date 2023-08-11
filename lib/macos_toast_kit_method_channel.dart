import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'macos_toast_kit_platform_interface.dart';

/// An implementation of [MacosToastKitPlatform] that uses method channels.
class MethodChannelMacosToastKit extends MacosToastKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('macos_toast_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> show({
    required double width,
    required double height,
    String? systemImageName,
    required String toastContent,
    required int showDuration}) async {
    final ret = await methodChannel.invokeMethod<bool>('show',
        [{"width":width,
          "height":height,
          "systemImageName":systemImageName,
          "toastContent":toastContent,
          "showDuration":showDuration}
        ]);
    return ret;
  }

  @override
  Future<bool?> close() async {
    final ret = await methodChannel.invokeMethod<bool>('close');
    return ret;
  }
}
