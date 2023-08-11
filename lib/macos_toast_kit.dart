
import 'macos_toast_kit_platform_interface.dart';

class MacosToastKit {
  Future<String?> getPlatformVersion() {
    return MacosToastKitPlatform.instance.getPlatformVersion();
  }

  /*
  *  显示吐司，默认自动关闭
  *  @parma width: 宽，默认180
  *  @parma height: 高，默认180
  *  @parma systemImageName：Mac系统的SF符号，图标名称，可选值，如果不传入，默认只显示文字
  *  @parma toastContent: 吐司的内容, 默认"Success"
  *  @parma showDuration: 显示多久自动关闭，单位：秒，默认1秒
  *  @parma applicationMode: 应用的模式，整型， 0-亮色模式，1-暗黑模式， 2-跟随系统
  *  @parma position: 位置，整型， 0-居中显示，1-居左显示， 2-居上显示，3-居右显示， 4-居下显示
  * */
  Future<bool?> show({
    double width = 180,
    double height = 180,
    String? systemImageName,
    String toastContent = "Success",
    int showDuration = 1,
    int applicationMode = 2,
    int position = 0,
    }) {
    return MacosToastKitPlatform.instance.show(
      width: width,
      height: height,
      systemImageName: systemImageName,
      toastContent: toastContent,
      showDuration: showDuration,
      applicationMode: applicationMode,
      position: position,
    );
  }

  /*
  *  手动关闭吐司
  * */
  Future<bool?> close() {
    return MacosToastKitPlatform.instance.close();
  }
}
