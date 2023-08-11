import Cocoa
import FlutterMacOS

public class MacosToastKitPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "macos_toast_kit", binaryMessenger: registrar.messenger)
        let instance = MacosToastKitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "show":
            let arguments = call.arguments as? Array<Dictionary<String, Any>>
            show(arguments)
            result(true)
        case "close":
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func show(_ arguments: Array<Dictionary<String, Any>>?) {
        if(arguments == nil || arguments!.isEmpty) {
            return
        }
        if let dic = arguments!.first {
            
            /// 判断
            if(isShowing()) {
                return
            }
            
            /// 参数
            let toastWidth = dic["width"] as! Double
            let toastHeight = dic["height"] as! Double
            let toastSFImageName = dic["systemImageName"] as? String
            let toastContent = dic["toastContent"] as! String
            let toastShowDuration = dic["showDuration"] as! Int
            
            /// 模式
            var bgColor: NSColor = NSColor(red: 236/255.0, green: 237/255.0, blue: 238/255.0, alpha: 1.0)
            var textColor: NSColor = NSColor(red: 109/255.0, green: 110/255.0, blue: 111/255.0, alpha: 1.0)
            if NSApp.effectiveAppearance.name == .darkAqua {
                bgColor = NSColor.darkGray
                textColor = NSColor.lightGray
            } else {
                bgColor = NSColor(red: 236/255.0, green: 237/255.0, blue: 238/255.0, alpha: 1.0)
                textColor = NSColor(red: 109/255.0, green: 110/255.0, blue: 111/255.0, alpha: 1.0)
            }
            
            /// 容器
            let toastView = NSView()
            toastView.identifier = NSUserInterfaceItemIdentifier("toast__macos")
            toastView.alphaValue = 0.0
            toastView.translatesAutoresizingMaskIntoConstraints = false
            toastView.wantsLayer = true
            toastView.layer?.backgroundColor = bgColor.cgColor
            toastView.layer?.cornerRadius = 10
            NSApplication.shared.mainWindow?.contentView?.addSubview(toastView)
            NSLayoutConstraint.activate([
                toastView.centerXAnchor.constraint(equalTo: toastView.superview!.centerXAnchor),
                toastView.centerYAnchor.constraint(equalTo: toastView.superview!.centerYAnchor),
                toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                toastView.heightAnchor.constraint(equalToConstant: toastHeight)
            ])


            /// 图标
            var hasIcon: Bool = false
            if #available(macOS 11.0, *) {
                if let SF = toastSFImageName {
                    if let systemImage = NSImage(systemSymbolName: SF, accessibilityDescription: nil) {
                        hasIcon = true
                        let iconHeight = 60.0
                        let imageView = NSImageView()
                        let config = NSImage.SymbolConfiguration(pointSize: iconHeight, weight: .regular)
                        imageView.image = systemImage.withSymbolConfiguration(config)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        toastView.addSubview(imageView)
                        NSLayoutConstraint.activate([
                            imageView.centerXAnchor.constraint(equalTo: toastView.centerXAnchor),
                            imageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor, constant: -iconHeight/3),
                            imageView.widthAnchor.constraint(equalToConstant: iconHeight),
                            imageView.heightAnchor.constraint(equalToConstant: iconHeight)
                        ])
                    }
                }
            }


            /// 文案
            let labeHeight = 28.0
            let label = NSTextField()
            label.backgroundColor = NSColor.clear
            label.translatesAutoresizingMaskIntoConstraints = false
            label.stringValue = toastContent
            label.alignment = NSTextAlignment.center
            label.font = NSFont.systemFont(ofSize: 22)
            label.isEditable = false
            label.isBordered = false
            label.alignment = .center
            label.textColor = textColor
            toastView.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: toastView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: toastView.centerYAnchor, constant: hasIcon ? 1.3*labeHeight : 0),
                label.widthAnchor.constraint(equalToConstant: toastWidth),
                label.heightAnchor.constraint(equalToConstant: labeHeight)
            ])
            
            
            /// 显示
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                context.allowsImplicitAnimation = true
                toastView.alphaValue = 1.0
            }, completionHandler: {
                /// 隐藏
                let dispatchAfter = DispatchTimeInterval.seconds(toastShowDuration)
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
                    NSAnimationContext.runAnimationGroup({ context in
                        context.duration = 0.5
                        context.allowsImplicitAnimation = true
                        toastView.alphaValue = 0.0
                    }, completionHandler: {
                        self.close()
                    })
                }
            })
        }
    }
    
    private func isShowing() -> Bool {
        if let _ = NSApplication.shared.mainWindow?.contentView?.subviews.first(where: { $0.identifier?.rawValue == "toast__macos" }) {
            return true
        }
        return false
    }
    
    private func close() {
        if let toastView = NSApplication.shared.mainWindow?.contentView?.subviews.first(where: { $0.identifier?.rawValue == "toast__macos" }) {
            toastView.removeFromSuperview()
        }
    }
}

