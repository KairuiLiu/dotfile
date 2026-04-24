import Cocoa
import AVFoundation
import CoreImage

// MARK: - 绿幕抠图
func chromaKeyFilter(fromHue: CGFloat, toHue: CGFloat,
                     minSaturation: CGFloat = 0.35) -> CIFilter {
    let size = 64
    var cube = [Float]()
    for z in 0..<size {
        let b = CGFloat(z) / CGFloat(size - 1)
        for y in 0..<size {
            let g = CGFloat(y) / CGFloat(size - 1)
            for x in 0..<size {
                let r = CGFloat(x) / CGFloat(size - 1)
                var hue: CGFloat = 0
                var sat: CGFloat = 0
                NSColor(red: r, green: g, blue: b, alpha: 1)
                    .getHue(&hue, saturation: &sat, brightness: nil, alpha: nil)
                let inHue = (hue >= fromHue && hue <= toHue)
                let a: CGFloat = (inHue && sat >= minSaturation) ? 0 : 1
                cube.append(Float(r * a))
                cube.append(Float(g * a))
                cube.append(Float(b * a))
                cube.append(Float(a))
            }
        }
    }
    let data = Data(bytes: cube, count: cube.count * MemoryLayout<Float>.size)
    return CIFilter(name: "CIColorCube", parameters: [
        "inputCubeDimension": size,
        "inputCubeData": data
    ])!
}

// MARK: - 定位视频文件（和可执行文件同目录下的 video.mp4）
func resolveExecutablePath() -> String {
    let arg0 = CommandLine.arguments[0]
    if arg0.hasPrefix("/") {
        return arg0
    } else if arg0.contains("/") {
        return FileManager.default.currentDirectoryPath + "/" + arg0
    } else {
        var size: UInt32 = 1024
        var buf = [CChar](repeating: 0, count: Int(size))
        _NSGetExecutablePath(&buf, &size)
        return String(cString: buf)
    }
}

let scriptDir = URL(fileURLWithPath: resolveExecutablePath())
    .resolvingSymlinksInPath()
    .deletingLastPathComponent()
let videoURL = scriptDir.appendingPathComponent("video.mp4")

guard FileManager.default.fileExists(atPath: videoURL.path) else {
    FileHandle.standardError.write(
        "video.mp4 not found at: \(videoURL.path)\n".data(using: .utf8)!)
    exit(1)
}

// MARK: - 应用初始化
let app = NSApplication.shared
app.setActivationPolicy(.accessory)

var windows: [NSWindow] = []
var players: [AVPlayer] = []
var finishedCount = 0
let totalScreens = NSScreen.screens.count

// MARK: - 每块屏幕一个窗口
for (index, screen) in NSScreen.screens.enumerated() {
    let frame = screen.frame

    let window = NSWindow(
        contentRect: frame,
        styleMask: .borderless,
        backing: .buffered,
        defer: false,
        screen: screen)
    window.setFrame(frame, display: true)
    window.level = .screenSaver
    window.isOpaque = false
    window.backgroundColor = .clear
    window.hasShadow = false
    window.ignoresMouseEvents = true
    window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

    let asset = AVURLAsset(url: videoURL)
    let item = AVPlayerItem(asset: asset)

    let comp = AVMutableVideoComposition(asset: asset) { request in
        let filter = chromaKeyFilter(fromHue: 0.30, toHue: 0.40, minSaturation: 0.35)
        filter.setValue(request.sourceImage, forKey: kCIInputImageKey)
        let out = (filter.outputImage ?? request.sourceImage)
            .cropped(to: request.sourceImage.extent)
        request.finish(with: out, context: nil)
    }
    item.videoComposition = comp

    let player = AVPlayer(playerItem: item)
    // 只让第一块屏出声，避免多屏叠音
    player.volume = (index == 0) ? 1.0 : 0.0

    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = CGRect(origin: .zero, size: frame.size)
    playerLayer.videoGravity = .resizeAspectFill
    playerLayer.backgroundColor = NSColor.clear.cgColor
    playerLayer.isOpaque = false

    let container = NSView(frame: CGRect(origin: .zero, size: frame.size))
    container.wantsLayer = true
    container.layer = CALayer()
    container.layer?.backgroundColor = NSColor.clear.cgColor
    container.layer?.addSublayer(playerLayer)

    window.contentView = container
    window.orderFrontRegardless()

    NotificationCenter.default.addObserver(
        forName: .AVPlayerItemDidPlayToEndTime,
        object: item, queue: .main) { _ in
            finishedCount += 1
            if finishedCount >= totalScreens { exit(0) }
        }

    windows.append(window)
    players.append(player)
}

// MARK: - 同步播放
for p in players { p.play() }

app.run()
