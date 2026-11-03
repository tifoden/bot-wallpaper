import Foundation
@main struct CLI {
 static func main() async {
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
   case "install":
    _ = try await MacOS26LockScreenInstaller.install(videoURL:URL(fileURLWithPath:args[2]),preparedURL:URL(fileURLWithPath:args[3]))
    print("installed")
   case "restore":
    try MacOS26LockScreenInstaller.restoreOriginalAerial()
    print("restored")
   default: throw NSError(domain:"Usage",code:2)
   }
  } catch {
   if CommandLine.arguments.dropFirst().first == "install" {
    do { try MacOS26LockScreenInstaller.restoreOriginalAerial() }
    catch { fputs("Restore failed: \(error.localizedDescription)\n", stderr) }
   }
   fputs("\(error.localizedDescription)\n",stderr); exit(1)
  }
 }
}
