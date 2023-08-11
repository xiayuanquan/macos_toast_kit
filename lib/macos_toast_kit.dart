
import 'macos_toast_kit_platform_interface.dart';

class MacosToastKit {
  Future<String?> getPlatformVersion() {
    return MacosToastKitPlatform.instance.getPlatformVersion();
  }

  /*
  *  显示吐司，默认自动关闭
  *  @parma width: 宽，默认180
  *  @parma height: 高，默认180
  *  @parma systemImageName：Mac系统的SF符号，图标名称
  *  @parma toastContent: 吐司的内容, 默认"Success"
  *  @parma showDuration: 显示多久自动关闭，单位：秒，默认1秒
  * */
  Future<bool?> show({
    double width = 180,
    double height = 180,
    String? systemImageName,
    String toastContent = "Success",
    int showDuration = 1,}) {
    return MacosToastKitPlatform.instance.show(
      width: width,
      height: height,
      systemImageName: systemImageName,
      toastContent: toastContent,
      showDuration: showDuration,
    );
  }

  /*
  *  手动关闭吐司
  * */
  Future<bool?> close() {
    return MacosToastKitPlatform.instance.close();
  }
}
