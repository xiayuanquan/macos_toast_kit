import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'macos_toast_kit_method_channel.dart';

abstract class MacosToastKitPlatform extends PlatformInterface {
  /// Constructs a MacosToastKitPlatform.
  MacosToastKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static MacosToastKitPlatform _instance = MethodChannelMacosToastKit();

  /// The default instance of [MacosToastKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelMacosToastKit].
  static MacosToastKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MacosToastKitPlatform] when
  /// they register themselves.
  static set instance(MacosToastKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> show({
    required double width,
    required double height,
    String? systemImageName,
    required String toastContent,
    required int showDuration}) {
    throw UnimplementedError('show() has not been implemented.');
  }

  Future<bool?> close() {
    throw UnimplementedError('close() has not been implemented.');
  }
}
