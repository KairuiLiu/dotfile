import Cocoa
import Metal
import MetalKit
import QuartzCore
import ScreenCaptureKit

// MARK: - 路径解析
func resolveExecutablePath() -> String {
    let arg0 = CommandLine.arguments[0]
    if arg0.hasPrefix("/") { return arg0 }
    if arg0.contains("/") {
        return FileManager.default.currentDirectoryPath + "/" + arg0
    }
    var size: UInt32 = 1024
    var buf = [CChar](repeating: 0, count: Int(size))
    _NSGetExecutablePath(&buf, &size)
    return String(cString: buf)
}

// MARK: - 保存位置（支持 INBOX_PATH 环境变量覆盖）
func resolveInboxURL() -> URL {
    if let envPath = ProcessInfo.processInfo.environment["INBOX_PATH"],
       !envPath.trimmingCharacters(in: .whitespaces).isEmpty {
        let expanded = NSString(string: envPath).expandingTildeInPath
        return URL(fileURLWithPath: expanded)
    }
    let scriptDir = URL(fileURLWithPath: resolveExecutablePath())
        .resolvingSymlinksInPath()
        .deletingLastPathComponent()
    return scriptDir.appendingPathComponent("inbox.md")
}

let mdURL = resolveInboxURL()

func save(_ text: String) {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }

    // 自动创建父目录
    let parent = mdURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)

    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm"
    let ts = df.string(from: Date())
    let body = trimmed.split(separator: "\n", omittingEmptySubsequences: false)
        .enumerated()
        .map { i, line in i == 0 ? String(line) : "  " + line }
        .joined(separator: "\n")
    let entry = "- `\(ts)` \(body)\n"
    guard let data = entry.data(using: .utf8) else { return }
    if FileManager.default.fileExists(atPath: mdURL.path),
       let h = try? FileHandle(forWritingTo: mdURL) {
        h.seekToEndOfFile(); h.write(data); try? h.close()
    } else {
        try? data.write(to: mdURL)
    }
}

// MARK: - 截屏
@available(macOS 14.0, *)
func captureScreen(_ screen: NSScreen) async -> CGImage? {
    let displayID = (screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value ?? CGMainDisplayID()
    do {
        let content = try await SCShareableContent.excludingDesktopWindows(
            false, onScreenWindowsOnly: true)
        guard let display = content.displays.first(where: { $0.displayID == displayID })
            ?? content.displays.first else { return nil }
        let filter = SCContentFilter(display: display, excludingWindows: [])
        let cfg = SCStreamConfiguration()
        cfg.width = Int(CGFloat(display.width) * screen.backingScaleFactor)
        cfg.height = Int(CGFloat(display.height) * screen.backingScaleFactor)
        cfg.showsCursor = false
        cfg.capturesAudio = false
        return try await SCScreenshotManager.captureImage(
            contentFilter: filter, configuration: cfg)
    } catch {
        FileHandle.standardError.write("capture failed: \(error)\n".data(using: .utf8)!)
        return nil
    }
}

// MARK: - 水波纹 Shader
let shaderSource = """
#include <metal_stdlib>
using namespace metal;
struct VOut { float4 pos [[position]]; float2 uv; };
vertex VOut vs(uint vid [[vertex_id]]) {
    float2 p[4] = { float2(-1,-1), float2(1,-1), float2(-1,1), float2(1,1) };
    VOut o; o.pos = float4(p[vid], 0, 1);
    o.uv = (p[vid] * 0.5) + 0.5; o.uv.y = 1.0 - o.uv.y;
    return o;
}
struct Uniforms { float2 center; float time; float aspect; };
fragment float4 fs(VOut in [[stage_in]],
                   texture2d<float> tex [[texture(0)]],
                   constant Uniforms& u [[buffer(0)]]) {
    constexpr sampler s(mag_filter::linear, min_filter::linear, address::clamp_to_edge);
    float2 uv = in.uv;
    float2 d = uv - u.center; d.x *= u.aspect;
    float dist = length(d);
    float wave = 0.0;
    wave += sin(dist * 60.0 - u.time * 6.0) * exp(-dist * 4.0) * max(0.0, 1.0 - u.time * 0.5);
    wave += sin(dist * 35.0 - u.time * 4.0) * exp(-dist * 3.0) * max(0.0, 1.0 - u.time * 0.4);
    wave += sin(dist * 90.0 - u.time * 9.0) * exp(-dist * 6.0) * max(0.0, 1.0 - u.time * 0.7);
    float2 dir = normalize(d + 1e-5);
    float2 offset = dir * wave * 0.012;
    float4 color = tex.sample(s, uv + offset);
    float hl = smoothstep(0.3, 1.0, wave) * 0.15 * max(0.0, 1.0 - u.time * 0.5);
    color.rgb += hl;
    return color;
}
"""

struct RippleUniforms { var center: SIMD2<Float>; var time: Float; var aspect: Float }

class RippleView: MTKView {
    var pipeline: MTLRenderPipelineState!
    var cmdQueue: MTLCommandQueue!
    var backgroundTex: MTLTexture?
    var startTime: CFTimeInterval = CACurrentMediaTime()

    init(frame: CGRect, device: MTLDevice, bgImage: CGImage) {
        super.init(frame: frame, device: device)
        framebufferOnly = true
        enableSetNeedsDisplay = false
        isPaused = false
        preferredFramesPerSecond = 60
        layer?.isOpaque = false
        colorPixelFormat = .bgra8Unorm
        cmdQueue = device.makeCommandQueue()
        let lib = try! device.makeLibrary(source: shaderSource, options: nil)
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction = lib.makeFunction(name: "vs")
        desc.fragmentFunction = lib.makeFunction(name: "fs")
        desc.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipeline = try! device.makeRenderPipelineState(descriptor: desc)
        let loader = MTKTextureLoader(device: device)
        backgroundTex = try? loader.newTexture(cgImage: bgImage, options: [
            .SRGB: false,
            .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
        ])
    }
    required init(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        guard let drawable = currentDrawable,
              let rpd = currentRenderPassDescriptor,
              let tex = backgroundTex,
              let cb = cmdQueue.makeCommandBuffer(),
              let enc = cb.makeRenderCommandEncoder(descriptor: rpd) else { return }
        let t = Float(CACurrentMediaTime() - startTime)
        var u = RippleUniforms(
            center: SIMD2<Float>(0.5, 0.5), time: t,
            aspect: Float(bounds.width / max(1, bounds.height)))
        enc.setRenderPipelineState(pipeline)
        enc.setFragmentTexture(tex, index: 0)
        enc.setFragmentBytes(&u, length: MemoryLayout<RippleUniforms>.size, index: 0)
        enc.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        enc.endEncoding()
        cb.present(drawable); cb.commit()
    }
}

// MARK: - 液态玻璃视图构建
func buildLiquidGlass(size: CGSize, cornerRadius: CGFloat) -> (root: NSView, content: NSView) {
    // root 只管阴影，完全透明背景
    let root = NSView(frame: NSRect(origin: .zero, size: size))
    root.wantsLayer = true
    root.layer?.backgroundColor = NSColor.clear.cgColor
    root.layer?.masksToBounds = false

    // 阴影层：一个独立的 CALayer，画圆角形状的阴影
    let shadowLayer = CALayer()
    shadowLayer.frame = root.bounds
    shadowLayer.shadowColor = NSColor.black.cgColor
    shadowLayer.shadowOpacity = 0.4
    shadowLayer.shadowRadius = 40
    shadowLayer.shadowOffset = CGSize(width: 0, height: -12)
    shadowLayer.shadowPath = CGPath(
        roundedRect: root.bounds,
        cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    // 关键：给 shadowLayer 一个不透明的 backgroundColor + 圆角，
    // 这样阴影有"形状"可以投射；但我们要让这个形状本身不可见。
    // 做法：用一个和 shadowPath 一样的 mask 把本体挖空，只留阴影。
    shadowLayer.backgroundColor = NSColor.black.cgColor
    shadowLayer.cornerRadius = cornerRadius

    // 用 mask 挖掉本体，只保留外面的阴影
    let shadowMask = CAShapeLayer()
    let outerPath = CGMutablePath()
    // 外框（向外扩一大圈，覆盖阴影范围）
    outerPath.addRect(root.bounds.insetBy(dx: -120, dy: -120))
    // 内框（圆角矩形，挖掉）
    outerPath.addPath(CGPath(
        roundedRect: root.bounds,
        cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil))
    shadowMask.path = outerPath
    shadowMask.fillRule = .evenOdd
    shadowMask.fillColor = NSColor.black.cgColor
    shadowLayer.mask = shadowMask
    root.layer?.addSublayer(shadowLayer)

    // 玻璃主体容器：用 mask 剪圆角
    let glassContainer = NSView(frame: root.bounds)
    glassContainer.wantsLayer = true
    glassContainer.autoresizingMask = [.width, .height]

    let glassMask = CAShapeLayer()
    glassMask.path = CGPath(
        roundedRect: glassContainer.bounds,
        cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
    glassMask.fillColor = NSColor.black.cgColor
    glassContainer.layer?.mask = glassMask

    // 毛玻璃
    let blur = NSVisualEffectView(frame: glassContainer.bounds)
    blur.material = .hudWindow
    blur.blendingMode = .behindWindow
    blur.state = .active
    blur.autoresizingMask = [.width, .height]
    glassContainer.addSubview(blur)

    // 顶部轻微高光
    let topGlow = CAGradientLayer()
    topGlow.frame = CGRect(
        x: 0, y: glassContainer.bounds.height - 40,
        width: glassContainer.bounds.width, height: 40)
    topGlow.colors = [
        NSColor.white.withAlphaComponent(0.18).cgColor,
        NSColor.clear.cgColor,
    ]
    topGlow.startPoint = CGPoint(x: 0.5, y: 1.0)
    topGlow.endPoint = CGPoint(x: 0.5, y: 0.0)
    glassContainer.layer?.addSublayer(topGlow)

    root.addSubview(glassContainer)

    // 内描边
    let borderLayer = CAShapeLayer()
    borderLayer.path = CGPath(
        roundedRect: root.bounds.insetBy(dx: 0.5, dy: 0.5),
        cornerWidth: cornerRadius - 0.5, cornerHeight: cornerRadius - 0.5,
        transform: nil)
    borderLayer.fillColor = NSColor.clear.cgColor
    borderLayer.strokeColor = NSColor.white.withAlphaComponent(0.25).cgColor
    borderLayer.lineWidth = 1
    root.layer?.addSublayer(borderLayer)

    // 内容层
    let content = NSView(frame: root.bounds)
    content.autoresizingMask = [.width, .height]
    root.addSubview(content)

    return (root, content)
}

// MARK: - 窗口与输入
class InputWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

class InputTextView: NSTextView {
    var onSubmit: (() -> Void)?
    var onCancel: (() -> Void)?
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { onCancel?(); return }
        if event.keyCode == 36 {
            if event.modifierFlags.contains(.shift) { super.keyDown(with: event) }
            else { onSubmit?() }
            return
        }
        super.keyDown(with: event)
    }
}

// MARK: - App
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var rippleWindow: NSWindow!
    var dialogWindow: InputWindow!
    var textView: InputTextView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screen = NSScreen.main ?? NSScreen.screens.first!
        Task { @MainActor in
            guard let device = MTLCreateSystemDefaultDevice(),
                  let shot = await captureScreen(screen) else {
                NSApp.terminate(nil); return
            }
            self.startRipple(on: screen, device: device, shot: shot)
        }
    }

    @MainActor
    func startRipple(on screen: NSScreen, device: MTLDevice, shot: CGImage) {
        let sf = screen.frame
        rippleWindow = NSWindow(
            contentRect: sf, styleMask: .borderless,
            backing: .buffered, defer: false, screen: screen)
        rippleWindow.setFrame(sf, display: true)
        rippleWindow.level = .floating   // 降到 floating，让 dialog 能盖在上面
        rippleWindow.isOpaque = false
        rippleWindow.backgroundColor = .clear
        rippleWindow.hasShadow = false
        rippleWindow.ignoresMouseEvents = true
        rippleWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

        let ripple = RippleView(frame: NSRect(origin: .zero, size: sf.size),
                                device: device, bgImage: shot)
        rippleWindow.contentView = ripple
        rippleWindow.orderFrontRegardless()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { [weak self] in
            self?.presentDialog(on: screen)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
            guard let self = self else { return }
            NSAnimationContext.runAnimationGroup({ c in
                c.duration = 0.4
                self.rippleWindow.animator().alphaValue = 0
            }, completionHandler: { self.rippleWindow.orderOut(nil) })
        }
    }

    func presentDialog(on screen: NSScreen) {
        let sf = screen.frame
        let w: CGFloat = 680
        let h: CGFloat = 160
        let rect = NSRect(x: sf.midX - w/2, y: sf.midY - h/2 + 80, width: w, height: h)

        dialogWindow = InputWindow(
            contentRect: rect, styleMask: [.borderless],
            backing: .buffered, defer: false)
        dialogWindow.level = .popUpMenu  // 比 ripple 的 .floating 高
        dialogWindow.isOpaque = false
        dialogWindow.backgroundColor = .clear
        dialogWindow.hasShadow = false
        dialogWindow.isMovableByWindowBackground = true
        dialogWindow.delegate = self

        let (root, content) = buildLiquidGlass(size: rect.size, cornerRadius: 22)

        // 提示条
        let hint = NSTextField(labelWithString: "💡 灵光一现  ·  ⏎ 保存  ·  ⇧⏎ 换行  ·  esc 取消")
        hint.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        hint.textColor = NSColor.secondaryLabelColor
        hint.frame = NSRect(x: 24, y: 14, width: rect.width - 48, height: 16)
        hint.autoresizingMask = [.width]
        content.addSubview(hint)

        // 输入框
        let scroll = NSScrollView(frame: NSRect(
            x: 20, y: 40, width: rect.width - 40, height: rect.height - 58))
        scroll.hasVerticalScroller = false
        scroll.drawsBackground = false
        scroll.borderType = .noBorder
        scroll.autoresizingMask = [.width, .height]

        textView = InputTextView(frame: scroll.bounds)
        textView.font = NSFont.systemFont(ofSize: 20, weight: .regular)
        textView.textColor = NSColor.labelColor
        textView.insertionPointColor = NSColor.labelColor
        textView.drawsBackground = false
        textView.isRichText = false
        textView.allowsUndo = true
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.autoresizingMask = [.width]
        textView.textContainerInset = NSSize(width: 4, height: 6)
        textView.onSubmit = { [weak self] in self?.submit() }
        textView.onCancel = { [weak self] in self?.cancel() }

        scroll.documentView = textView
        content.addSubview(scroll)

        dialogWindow.contentView = root

        // 浮出动画
        root.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        root.layer?.position = CGPoint(x: root.bounds.midX, y: root.bounds.midY)
        root.layer?.transform = CATransform3DMakeScale(0.85, 0.85, 1)
        root.alphaValue = 0

        dialogWindow.makeKeyAndOrderFront(nil)
        dialogWindow.makeFirstResponder(textView)
        NSApp.activate(ignoringOtherApps: true)

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.55)
        CATransaction.setAnimationTimingFunction(
            CAMediaTimingFunction(controlPoints: 0.16, 1.0, 0.3, 1.0))
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = CATransform3DMakeScale(0.85, 0.85, 1)
        scale.toValue = CATransform3DIdentity
        root.layer?.add(scale, forKey: "pop")
        root.layer?.transform = CATransform3DIdentity
        CATransaction.commit()

        NSAnimationContext.runAnimationGroup { c in
            c.duration = 0.35
            root.animator().alphaValue = 1
        }
    }

    func submit() { save(textView.string); fadeOutAndQuit() }
    func cancel() { fadeOutAndQuit() }

    func fadeOutAndQuit() {
        NSAnimationContext.runAnimationGroup({ c in
            c.duration = 0.2
            dialogWindow?.animator().alphaValue = 0
            rippleWindow?.animator().alphaValue = 0
        }, completionHandler: { NSApp.terminate(nil) })
    }

    func windowDidResignKey(_ notification: Notification) { fadeOutAndQuit() }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
