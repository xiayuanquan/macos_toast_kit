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
            close()
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
            guard let containerView = NSApplication.shared.mainWindow?.contentView else { return }
            guard !isShowing() else { return }
            
            /// 参数
            let toastWidth = dic["width"] as! Double
            let toastHeight = dic["height"] as! Double
            let toastSFImageName = dic["systemImageName"] as? String
            let toastContent = dic["toastContent"] as! String
            let toastShowDuration = dic["showDuration"] as! Int
            let applicationMode = dic["applicationMode"] as! Int
            let position = dic["position"] as! Int
            
            /// 模式(0-亮色模式，1-暗黑模式， 2-跟随系统)
            let _bgColor: NSColor = NSColor(red: 236/255.0, green: 237/255.0, blue: 238/255.0, alpha: 1.0)
            let _textColor: NSColor =  NSColor(red: 109/255.0, green: 110/255.0, blue: 111/255.0, alpha: 1.0)
            var bgColor: NSColor = _bgColor
            var textColor: NSColor = _textColor
            switch applicationMode {
            case 0:
                bgColor = _bgColor
                textColor = _textColor
                break
            case 1:
                bgColor = NSColor.darkGray
                textColor = NSColor.lightGray
                break
            case 2:
                if NSApp.effectiveAppearance.name == .darkAqua {
                    bgColor = NSColor.darkGray
                    textColor = NSColor.lightGray
                } else {
                    bgColor = _bgColor
                    textColor = _textColor
                }
                break
            default:
                if NSApp.effectiveAppearance.name == .darkAqua {
                    bgColor = NSColor.darkGray
                    textColor = NSColor.lightGray
                } else {
                    bgColor = _bgColor
                    textColor = _textColor
                }
                break
            }
            
            
            /// 容器
            let toastView = NSView()
            toastView.identifier = NSUserInterfaceItemIdentifier("toast__macos")
            toastView.alphaValue = 0.0
            toastView.translatesAutoresizingMaskIntoConstraints = false
            toastView.wantsLayer = true
            toastView.layer?.backgroundColor = bgColor.cgColor
            toastView.layer?.cornerRadius = 10
            containerView.addSubview(toastView)
            
            
            /// 位置(0-居中显示，1-居左显示， 2-居上显示，3-居右显示，4-居下显示)
            var constraints: [NSLayoutConstraint] = []
            switch position {
            case 0:
                constraints = [
                    toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                    toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                    toastView.heightAnchor.constraint(equalToConstant: toastHeight)
                ]
                break
             case 1:
                let width = containerView.frame.size.width
                let constant = (width/2 > toastWidth) ? (width/2 - toastWidth) : (toastWidth/2)
                constraints = [
                     toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -constant),
                     toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                     toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                     toastView.heightAnchor.constraint(equalToConstant: toastHeight)
                 ]
                break
             case 2:
                let height = containerView.frame.size.height
                let constant = (height/2 > toastHeight) ? (height/2 - toastHeight) : (toastHeight/2)
                constraints = [
                     toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                     toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -constant),
                     toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                     toastView.heightAnchor.constraint(equalToConstant: toastHeight)
                 ]
                break
             case 3:
                let width = containerView.frame.size.width
                let constant = (width/2 > toastWidth) ? (width/2 - toastWidth) : (toastWidth/2)
                constraints = [
                     toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: constant),
                     toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                     toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                     toastView.heightAnchor.constraint(equalToConstant: toastHeight)
                 ]
                break
             case 4:
                let height = containerView.frame.size.height
                let constant = (height/2 > toastHeight) ? (height/2 - toastHeight) : (toastHeight/2)
                constraints = [
                     toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                     toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: constant),
                     toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                     toastView.heightAnchor.constraint(equalToConstant: toastHeight)
                 ]
                break
            default:
                constraints = [
                    toastView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    toastView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                    toastView.widthAnchor.constraint(equalToConstant: toastWidth),
                    toastView.heightAnchor.constraint(equalToConstant: toastHeight)
                ]
                break
            }
            NSLayoutConstraint.activate(constraints)


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
                            imageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor, constant: -iconHeight/2.5),
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

