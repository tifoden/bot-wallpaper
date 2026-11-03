import Foundation
@main struct CLI {
 static func main() async {
  let wasInstalled = MacOS26LockScreenInstaller.isInstalled
  do {
   let args=CommandLine.arguments
   if args.count < 2 { throw NSError(domain:"Usage",code:1) }
   switch args[1] {
   case "prepare":
    let video=URL(fileURLWithPath:args[2]); let target=URL(fileURLWithPath:args[3])
    let result=try await AerialTemporalEncoder.encode(source:video)
    try FileManager.default.copyItem(at:result,to:target)
    try? FileManager.default.removeItem(at:result)
    print("prepared")
   case "render":
    guard args.count == 6, let color = UInt32(args[4]), let size = Int(args[5]) else { throw NSError(domain:"Usage",code:1) }
    try await LockScreenVideoRenderer.render(source: URL(fileURLWithPath:args[2]), output: URL(fileURLWithPath:args[3]), color: color, size: size)
    print("rendered")
   case "install-custom":
    guard args.count == 5, let color = UInt32(args[3]), let size = Int(args[4]) else { throw NSError(domain:"Usage",code:1) }
    let source = URL(fileURLWithPath:args[2])
    let rendered = FileManager.default.temporaryDirectory.appendingPathComponent("bot-lock-render-\(UUID().uuidString).mov")
    defer { try? FileManager.default.removeItem(at: rendered) }
    try await LockScreenVideoRenderer.render(source: source, output: rendered, color: color, size: size)
    let prepared: URL?
    if ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 27 {
        prepared = try await AerialTemporalEncoder.encode(source: rendered)
    } else { prepared = nil }
    defer { if let prepared { try? FileManager.default.removeItem(at: prepared) } }
    _ = try await MacOS26LockScreenInstaller.install(videoURL: rendered, preparedURL: prepared)
    print("installed")
   case "install":
    _ = try await MacOS26LockScreenInstaller.install(videoURL:URL(fileURLWithPath:args[2]),preparedURL:URL(fileURLWithPath:args[3]))
    print("installed")
   case "restore":
    try MacOS26LockScreenInstaller.restoreOriginalAerial()
    print("restored")
   default: throw NSError(domain:"Usage",code:2)
   }
  } catch {
   if ["install", "install-custom"].contains(CommandLine.arguments.dropFirst().first ?? "") && !wasInstalled {
    do { try MacOS26LockScreenInstaller.restoreOriginalAerial() }
    catch { fputs("Restore failed: \(error.localizedDescription)\n", stderr) }
   }
   fputs("\(error.localizedDescription)\n",stderr); exit(1)
  }
 }
}
