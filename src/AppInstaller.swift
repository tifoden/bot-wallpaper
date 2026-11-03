import Cocoa

enum AppInstaller {
    // Title, explanation, install, later, failure title, failure explanation, OK.
    static let strings: [String: [String]] = [
        "en": ["Move Bot Wallpaper to Applications?", "Keep the app in Applications so it remains available if you clean up Downloads. A copy will be installed and opened.", "Move to Applications", "Later", "Could not install Bot Wallpaper", "The app could not be copied or opened. You can continue using this copy or move it manually.", "OK"],
        "ko": ["Bot Wallpaper를 응용 프로그램으로 옮길까요?", "다운로드 폴더를 정리해도 앱을 사용할 수 있도록 응용 프로그램 폴더에 복사하고 실행합니다.", "응용 프로그램으로 이동", "나중에", "Bot Wallpaper를 설치할 수 없어요", "앱을 복사하거나 열지 못했습니다. 지금 앱을 계속 사용하거나 직접 옮길 수 있습니다.", "확인"],
        "ja": ["Bot Wallpaperをアプリケーションに移動しますか？", "ダウンロードを整理しても使えるよう、アプリケーションフォルダにコピーして開きます。", "アプリケーションに移動", "あとで", "Bot Wallpaperをインストールできません", "コピーまたは起動できませんでした。このまま使うか、手動で移動してください。", "OK"],
        "zh-Hans": ["将 Bot Wallpaper 移到应用程序？", "应用将复制到应用程序文件夹并打开，清理下载文件夹后仍可使用。", "移到应用程序", "稍后", "无法安装 Bot Wallpaper", "无法复制或打开应用。您可以继续使用此副本，或手动移动。", "好"],
        "zh-Hant": ["將 Bot Wallpaper 移到應用程式？", "App 會複製到應用程式資料夾並開啟，清理下載項目後仍可使用。", "移到應用程式", "稍後", "無法安裝 Bot Wallpaper", "無法複製或開啟 App。您可以繼續使用此副本，或手動移動。", "好"],
        "es": ["¿Mover Bot Wallpaper a Aplicaciones?", "Se copiará y abrirá en Aplicaciones para que puedas conservarla al limpiar Descargas.", "Mover a Aplicaciones", "Más tarde", "No se pudo instalar Bot Wallpaper", "No se pudo copiar o abrir la aplicación. Puedes seguir usando esta copia o moverla manualmente.", "Aceptar"],
        "fr": ["Déplacer Bot Wallpaper dans Applications ?", "L’app sera copiée et ouverte dans Applications pour rester disponible après le nettoyage des téléchargements.", "Déplacer dans Applications", "Plus tard", "Installation de Bot Wallpaper impossible", "Impossible de copier ou d’ouvrir l’app. Continuez avec cette copie ou déplacez-la manuellement.", "OK"],
        "de": ["Bot Wallpaper in Programme verschieben?", "Die App wird in Programme kopiert und geöffnet, damit sie beim Bereinigen der Downloads erhalten bleibt.", "In Programme verschieben", "Später", "Bot Wallpaper konnte nicht installiert werden", "Die App konnte nicht kopiert oder geöffnet werden. Verwende diese Kopie weiter oder verschiebe sie manuell.", "OK"],
        "pt": ["Mover Bot Wallpaper para Aplicativos?", "O app será copiado e aberto em Aplicativos para continuar disponível ao limpar os downloads.", "Mover para Aplicativos", "Depois", "Não foi possível instalar o Bot Wallpaper", "Não foi possível copiar ou abrir o app. Continue usando esta cópia ou mova-a manualmente.", "OK"],
        "it": ["Spostare Bot Wallpaper in Applicazioni?", "L’app verrà copiata e aperta in Applicazioni per mantenerla disponibile dopo la pulizia dei download.", "Sposta in Applicazioni", "Più tardi", "Impossibile installare Bot Wallpaper", "Impossibile copiare o aprire l’app. Continua a usare questa copia o spostala manualmente.", "OK"],
        "nl": ["Bot Wallpaper naar Apps verplaatsen?", "De app wordt naar Apps gekopieerd en geopend, zodat deze beschikbaar blijft na het opruimen van Downloads.", "Verplaats naar Apps", "Later", "Bot Wallpaper kon niet worden geïnstalleerd", "De app kon niet worden gekopieerd of geopend. Gebruik deze kopie of verplaats de app handmatig.", "OK"],
        "ru": ["Переместить Bot Wallpaper в «Программы»?", "Приложение будет скопировано в «Программы» и открыто, чтобы оно осталось доступным после очистки загрузок.", "Переместить в «Программы»", "Позже", "Не удалось установить Bot Wallpaper", "Не удалось скопировать или открыть приложение. Используйте эту копию или переместите её вручную.", "ОК"],
        "uk": ["Перемістити Bot Wallpaper у «Програми»?", "Програму буде скопійовано в «Програми» та відкрито, щоб вона залишилася після очищення завантажень.", "Перемістити в «Програми»", "Пізніше", "Не вдалося встановити Bot Wallpaper", "Не вдалося скопіювати або відкрити програму. Користуйтеся цією копією або перемістіть її вручну.", "ОК"],
        "ar": ["نقل Bot Wallpaper إلى التطبيقات؟", "سيُنسخ التطبيق إلى مجلد التطبيقات ويُفتح ليبقى متاحًا عند تنظيف التنزيلات.", "نقل إلى التطبيقات", "لاحقًا", "تعذر تثبيت Bot Wallpaper", "تعذر نسخ التطبيق أو فتحه. يمكنك متابعة استخدام هذه النسخة أو نقلها يدويًا.", "موافق"],
        "hi": ["Bot Wallpaper को Applications में ले जाएँ?", "ऐप को Applications में कॉपी करके खोला जाएगा, ताकि Downloads साफ़ करने पर भी वह उपलब्ध रहे।", "Applications में ले जाएँ", "बाद में", "Bot Wallpaper इंस्टॉल नहीं हो सका", "ऐप को कॉपी या खोला नहीं जा सका। इस कॉपी का उपयोग जारी रखें या इसे स्वयं ले जाएँ।", "ठीक है"],
        "id": ["Pindahkan Bot Wallpaper ke Aplikasi?", "Aplikasi akan disalin dan dibuka dari Aplikasi agar tetap tersedia saat Unduhan dibersihkan.", "Pindahkan ke Aplikasi", "Nanti", "Bot Wallpaper tidak dapat diinstal", "Aplikasi tidak dapat disalin atau dibuka. Gunakan salinan ini atau pindahkan secara manual.", "OK"],
        "vi": ["Chuyển Bot Wallpaper vào Ứng dụng?", "Ứng dụng sẽ được sao chép và mở từ Ứng dụng để vẫn còn khi dọn thư mục Tải về.", "Chuyển vào Ứng dụng", "Để sau", "Không thể cài đặt Bot Wallpaper", "Không thể sao chép hoặc mở ứng dụng. Bạn có thể tiếp tục dùng bản này hoặc tự chuyển.", "OK"],
        "th": ["ย้าย Bot Wallpaper ไปยังแอปพลิเคชันหรือไม่?", "แอปจะถูกคัดลอกและเปิดจากโฟลเดอร์แอปพลิเคชัน เพื่อให้ยังใช้งานได้เมื่อล้างโฟลเดอร์ดาวน์โหลด", "ย้ายไปยังแอปพลิเคชัน", "ภายหลัง", "ติดตั้ง Bot Wallpaper ไม่ได้", "ไม่สามารถคัดลอกหรือเปิดแอปได้ ใช้สำเนานี้ต่อหรือย้ายด้วยตนเอง", "ตกลง"],
        "tr": ["Bot Wallpaper Uygulamalar’a taşınsın mı?", "Uygulama, İndirilenler temizlendiğinde kaybolmaması için Uygulamalar’a kopyalanıp açılır.", "Uygulamalar’a taşı", "Daha sonra", "Bot Wallpaper yüklenemedi", "Uygulama kopyalanamadı veya açılamadı. Bu kopyayı kullanmaya devam edin veya elle taşıyın.", "Tamam"],
        "pl": ["Przenieść Bot Wallpaper do Aplikacji?", "Aplikacja zostanie skopiowana i otwarta z folderu Aplikacje, aby pozostała po wyczyszczeniu Pobranych.", "Przenieś do Aplikacji", "Później", "Nie można zainstalować Bot Wallpaper", "Nie można skopiować ani otworzyć aplikacji. Używaj tej kopii lub przenieś ją ręcznie.", "OK"],
        "sv": ["Flytta Bot Wallpaper till Program?", "Appen kopieras till och öppnas från Program så att den finns kvar när hämtningar rensas.", "Flytta till Program", "Senare", "Det gick inte att installera Bot Wallpaper", "Appen kunde inte kopieras eller öppnas. Använd denna kopia eller flytta den manuellt.", "OK"],
        "da": ["Flyt Bot Wallpaper til Programmer?", "Appen kopieres til og åbnes fra Programmer, så den bevares, når overførsler ryddes.", "Flyt til Programmer", "Senere", "Bot Wallpaper kunne ikke installeres", "Appen kunne ikke kopieres eller åbnes. Brug denne kopi eller flyt den manuelt.", "OK"],
        "fi": ["Siirretäänkö Bot Wallpaper Ohjelmat-kansioon?", "Appi kopioidaan ja avataan Ohjelmat-kansiosta, jotta se säilyy latauksia siivottaessa.", "Siirrä Ohjelmiin", "Myöhemmin", "Bot Wallpaperia ei voitu asentaa", "Appia ei voitu kopioida tai avata. Jatka tämän kopion käyttöä tai siirrä se itse.", "OK"],
        "nb": ["Flytt Bot Wallpaper til Programmer?", "Appen kopieres til og åpnes fra Programmer slik at den beholdes når nedlastinger ryddes.", "Flytt til Programmer", "Senere", "Kunne ikke installere Bot Wallpaper", "Appen kunne ikke kopieres eller åpnes. Bruk denne kopien eller flytt den manuelt.", "OK"],
        "cs": ["Přesunout Bot Wallpaper do Aplikací?", "Aplikace se zkopíruje a otevře ze složky Aplikace, aby zůstala po vyčištění stažených souborů.", "Přesunout do Aplikací", "Později", "Bot Wallpaper nelze nainstalovat", "Aplikaci nelze zkopírovat nebo otevřít. Použijte tuto kopii nebo ji přesuňte ručně.", "OK"],
        "el": ["Μεταφορά του Bot Wallpaper στις Εφαρμογές;", "Η εφαρμογή θα αντιγραφεί και θα ανοίξει από τις Εφαρμογές, ώστε να παραμείνει μετά την εκκαθάριση των λήψεων.", "Μεταφορά στις Εφαρμογές", "Αργότερα", "Δεν ήταν δυνατή η εγκατάσταση του Bot Wallpaper", "Δεν ήταν δυνατή η αντιγραφή ή το άνοιγμα. Χρησιμοποιήστε αυτό το αντίγραφο ή μεταφέρετέ το χειροκίνητα.", "OK"],
        "he": ["להעביר את Bot Wallpaper ליישומים?", "היישום יועתק וייפתח מתיקיית היישומים כדי שיישאר זמין לאחר ניקוי ההורדות.", "העברה ליישומים", "מאוחר יותר", "לא ניתן להתקין את Bot Wallpaper", "לא ניתן להעתיק או לפתוח את היישום. אפשר להמשיך להשתמש בעותק הזה או להעביר אותו ידנית.", "אישור"],
        "ro": ["Muți Bot Wallpaper în Aplicații?", "Aplicația va fi copiată și deschisă din Aplicații pentru a rămâne disponibilă după curățarea descărcărilor.", "Mută în Aplicații", "Mai târziu", "Bot Wallpaper nu a putut fi instalat", "Aplicația nu a putut fi copiată sau deschisă. Folosește această copie sau mut-o manual.", "OK"],
        "hu": ["Áthelyezi a Bot Wallpapert az Alkalmazásokba?", "Az app az Alkalmazások mappába másolva nyílik meg, így a letöltések törlése után is elérhető marad.", "Áthelyezés az Alkalmazásokba", "Később", "A Bot Wallpaper nem telepíthető", "Az app nem másolható vagy nyitható meg. Használja ezt a példányt, vagy helyezze át kézzel.", "OK"]
    ]
    static func localized(_ languages: [String]) -> [String] {
        for language in languages {
            let lower = language.lowercased()
            if lower.hasPrefix("zh") {
                let traditional = lower.contains("hant") || lower.hasPrefix("zh-tw") || lower.hasPrefix("zh-hk") || lower.hasPrefix("zh-mo")
                return strings[traditional ? "zh-Hant" : "zh-Hans"]!
            }
            let code = lower.split(separator: "-").first.map(String.init) ?? "en"
            if let found = strings[code == "no" ? "nb" : code] { return found }
        }
        return strings["en"]!
    }
    static func isInApplications(_ app: URL, roots: [URL]) -> Bool {
        let path = app.standardizedFileURL.resolvingSymlinksInPath().path
        return roots.contains { root in
            let prefix = root.standardizedFileURL.resolvingSymlinksInPath().path + "/"
            return path.hasPrefix(prefix)
        }
    }
    static func copyApplication(from source: URL, to directory: URL) throws -> URL {
        let fm = FileManager.default
        try fm.createDirectory(at: directory, withIntermediateDirectories: true)
        let destination = directory.appendingPathComponent("Bot Wallpaper.app", isDirectory: true)
        // Never overwrite an existing installation.
        try fm.copyItem(at: source, to: destination)
        return destination
    }
    static func offerInstallation(onOpenFailure: @escaping () -> Void) -> Bool {
        let fm = FileManager.default
        let system = URL(fileURLWithPath: "/Applications", isDirectory: true)
        let user = fm.homeDirectoryForCurrentUser.appendingPathComponent("Applications", isDirectory: true)
        let source = Bundle.main.bundleURL
        guard !isInApplications(source, roots: [system, user]) else { return false }
        let words = localized(Locale.preferredLanguages)
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = words[0]; alert.informativeText = words[1]
        alert.addButton(withTitle: words[2]); alert.addButton(withTitle: words[3])
        guard alert.runModal() == .alertFirstButtonReturn else { return false }
        let directory = fm.isWritableFile(atPath: system.path) ? system : user
        do {
            let destination = try copyApplication(from: source, to: directory)
            let config = NSWorkspace.OpenConfiguration()
            config.createsNewApplicationInstance = true
            NSWorkspace.shared.openApplication(at: destination, configuration: config) { _, error in
                DispatchQueue.main.async {
                    if let error = error { showError(error, words: words); onOpenFailure() }
                    else { NSApp.terminate(nil) }
                }
            }
            return true
        } catch {
            showError(error, words: words)
            return false
        }
    }
    static func showError(_ error: Error, words: [String]) {
        let alert = NSAlert()
        alert.messageText = words[4]; alert.informativeText = words[5] + "\n\n" + error.localizedDescription
        alert.addButton(withTitle: words[6]); alert.runModal()
    }
}
