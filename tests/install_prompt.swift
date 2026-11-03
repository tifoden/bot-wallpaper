import Cocoa

@main struct InstallPromptTests {
    static func main() {
        let system = URL(fileURLWithPath: "/Applications")
        let user = URL(fileURLWithPath: "/Users/example/Applications")
        precondition(AppInstaller.isInApplications(URL(fileURLWithPath: "/Applications/Bot Wallpaper.app"), roots: [system, user]))
        precondition(AppInstaller.isInApplications(URL(fileURLWithPath: "/Users/example/Applications/Bot Wallpaper.app"), roots: [system, user]))
        precondition(!AppInstaller.isInApplications(URL(fileURLWithPath: "/Applications-old/Bot Wallpaper.app"), roots: [system, user]))
        precondition(!AppInstaller.isInApplications(URL(fileURLWithPath: "/Users/example/Downloads/Bot Wallpaper.app"), roots: [system, user]))
        for (language, messages) in AppInstaller.strings {
            precondition(messages.count == 7 && messages.allSatisfy { !$0.isEmpty }, "Incomplete translation: \(language)")
            precondition(AppInstaller.localized([language]) == messages, "Wrong translation: \(language)")
        }
        precondition(AppInstaller.localized(["zh-TW"]) == AppInstaller.strings["zh-Hant"]!)
        precondition(AppInstaller.localized(["zh-CN"]) == AppInstaller.strings["zh-Hans"]!)
        precondition(AppInstaller.localized(["no-NO"]) == AppInstaller.strings["nb"]!)
        precondition(AppInstaller.localized(["xx-XX"]) == AppInstaller.strings["en"]!)
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: temp) }
        let source = temp.appendingPathComponent("source.app", isDirectory: true)
        let destination = temp.appendingPathComponent("Applications", isDirectory: true)
        try! FileManager.default.createDirectory(at: source, withIntermediateDirectories: true)
        try! Data("app".utf8).write(to: source.appendingPathComponent("content"))
        let copied = try! AppInstaller.copyApplication(from: source, to: destination)
        precondition(FileManager.default.fileExists(atPath: source.path))
        precondition((try! Data(contentsOf: copied.appendingPathComponent("content"))) == Data("app".utf8))
        do { _ = try AppInstaller.copyApplication(from: source, to: destination); fatalError("Overwrote existing app") }
        catch { precondition(FileManager.default.fileExists(atPath: copied.path)) }
        print("Installation location, copy and localization checks passed")
    }
}
