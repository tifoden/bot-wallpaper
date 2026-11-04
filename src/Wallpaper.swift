import Cocoa
import AVFoundation
import CoreImage
import Sparkle
import ServiceManagement

final class App: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var windows: [NSWindow] = []
    var players: [AVQueuePlayer] = []
    var loopers: [AVPlayerLooper] = []
    var playbackGeneration = 0
    var stillLayers: [CALayer] = []
    var videoLayers: [AVPlayerLayer] = []
    var contentViews: [NSView] = []
    var originalLayers: [CALayer] = []
    var desktopEnabled = true
    var desktopActive = true
    var sessionActive = true
    var displayAwake = true
    var lockEnabled = false
    let lockMediaRevision = 3
    var lockUpdatePending = false
    var lockUpdatingEnable = false
    var lockRefreshGeneration = 0
    var desktopCheck: NSButton!
    var lockCheck: NSButton!
    var loginItem: NSMenuItem!
    static let translations: [String: [String]] = [
        "ko": ["Bot Wallpaper", "캐릭터 색상", "캐릭터 크기", "Grok Bot 앱 열기", "일시정지", "다시 재생", "배경화면 종료", "빨강", "주황", "귤색", "초록", "청록", "파랑", "보라", "분홍", "흰색", "아웃라인", "크게", "중간", "작게", "하단", "배경화면", "잠금화면"],
        "en": ["Bot Wallpaper", "Character color", "Character size", "Open Grok Bot", "Pause", "Resume", "Quit wallpaper", "Red", "Orange", "Amber", "Green", "Teal", "Blue", "Purple", "Pink", "White", "Outline", "Large", "Medium", "Small", "Bottom", "Desktop", "Lock screen"],
        "ja": ["Bot Wallpaper", "キャラクターの色", "キャラクターのサイズ", "Grok Botを開く", "一時停止", "再生", "壁紙を終了", "赤", "オレンジ", "琥珀色", "緑", "青緑", "青", "紫", "ピンク", "白", "アウトライン", "大", "中", "小", "下", "デスクトップ", "ロック画面"],
        "zh-Hans": ["Bot Wallpaper", "角色颜色", "角色大小", "打开 Grok Bot", "暂停", "继续播放", "退出壁纸", "红色", "橙色", "琥珀色", "绿色", "青色", "蓝色", "紫色", "粉色", "白色", "轮廓", "大", "中", "小", "底部", "桌面", "锁定屏幕"],
        "zh-Hant": ["Bot Wallpaper", "角色顏色", "角色大小", "開啟 Grok Bot", "暫停", "繼續播放", "結束桌布", "紅色", "橙色", "琥珀色", "綠色", "青色", "藍色", "紫色", "粉紅色", "白色", "輪廓", "大", "中", "小", "底部", "桌面", "鎖定畫面"],
        "es": ["Bot Wallpaper", "Color del personaje", "Tamaño del personaje", "Abrir Grok Bot", "Pausar", "Reanudar", "Cerrar fondo", "Rojo", "Naranja", "Ámbar", "Verde", "Turquesa", "Azul", "Morado", "Rosa", "Blanco", "Contorno", "Grande", "Medio", "Pequeño", "Abajo", "Escritorio", "Pantalla bloqueada"],
        "fr": ["Bot Wallpaper", "Couleur du personnage", "Taille du personnage", "Ouvrir Grok Bot", "Pause", "Reprendre", "Quitter le fond", "Rouge", "Orange", "Ambre", "Vert", "Turquoise", "Bleu", "Violet", "Rose", "Blanc", "Contour", "Grand", "Moyen", "Petit", "Bas", "Bureau", "Écran verrouillé"],
        "de": ["Bot Wallpaper", "Figurfarbe", "Figurgröße", "Grok Bot öffnen", "Pause", "Fortsetzen", "Hintergrund beenden", "Rot", "Orange", "Bernstein", "Grün", "Türkis", "Blau", "Violett", "Pink", "Weiß", "Kontur", "Groß", "Mittel", "Klein", "Unten", "Schreibtisch", "Sperrbildschirm"],
        "pt": ["Bot Wallpaper", "Cor do personagem", "Tamanho do personagem", "Abrir Grok Bot", "Pausar", "Retomar", "Encerrar papel de parede", "Vermelho", "Laranja", "Âmbar", "Verde", "Turquesa", "Azul", "Roxo", "Rosa", "Branco", "Contorno", "Grande", "Médio", "Pequeno", "Abaixo", "Mesa", "Tela bloqueada"],
        "it": ["Bot Wallpaper", "Colore del personaggio", "Dimensione personaggio", "Apri Grok Bot", "Pausa", "Riprendi", "Chiudi sfondo", "Rosso", "Arancione", "Ambra", "Verde", "Turchese", "Blu", "Viola", "Rosa", "Bianco", "Contorno", "Grande", "Medio", "Piccolo", "Basso", "Scrivania", "Schermata di blocco"],
        "nl": ["Bot Wallpaper", "Kleur van personage", "Grootte van personage", "Open Grok Bot", "Pauzeer", "Hervat", "Sluit achtergrond", "Rood", "Oranje", "Amber", "Groen", "Turquoise", "Blauw", "Paars", "Roze", "Wit", "Omtrek", "Groot", "Middel", "Klein", "Onder", "Bureaublad", "Vergrendelscherm"],
        "ru": ["Bot Wallpaper", "Цвет персонажа", "Размер персонажа", "Открыть Grok Bot", "Пауза", "Продолжить", "Закрыть обои", "Красный", "Оранжевый", "Янтарный", "Зелёный", "Бирюзовый", "Синий", "Фиолетовый", "Розовый", "Белый", "Контур", "Большой", "Средний", "Малый", "Внизу", "Рабочий стол", "Экран блокировки"],
        "uk": ["Bot Wallpaper", "Колір персонажа", "Розмір персонажа", "Відкрити Grok Bot", "Пауза", "Продовжити", "Закрити шпалери", "Червоний", "Помаранчевий", "Бурштиновий", "Зелений", "Бірюзовий", "Синій", "Фіолетовий", "Рожевий", "Білий", "Контур", "Великий", "Середній", "Малий", "Внизу", "Робочий стіл", "Екран блокування"],
        "ar": ["Bot Wallpaper", "لون الشخصية", "حجم الشخصية", "فتح Grok Bot", "إيقاف مؤقت", "استئناف", "إغلاق الخلفية", "أحمر", "برتقالي", "كهرماني", "أخضر", "فيروزي", "أزرق", "بنفسجي", "وردي", "أبيض", "مخطط", "كبير", "متوسط", "صغير", "أسفل", "سطح المكتب", "شاشة القفل"],
        "hi": ["Bot Wallpaper", "पात्र का रंग", "पात्र का आकार", "Grok Bot खोलें", "रोकें", "फिर चलाएँ", "वॉलपेपर बंद करें", "लाल", "नारंगी", "सुनहरा", "हरा", "फ़िरोज़ी", "नीला", "बैंगनी", "गुलाबी", "सफ़ेद", "रूपरेखा", "बड़ा", "मध्यम", "छोटा", "नीचे", "डेस्कटॉप", "लॉक स्क्रीन"],
        "id": ["Bot Wallpaper", "Warna karakter", "Ukuran karakter", "Buka Grok Bot", "Jeda", "Lanjutkan", "Tutup wallpaper", "Merah", "Oranye", "Amber", "Hijau", "Toska", "Biru", "Ungu", "Merah muda", "Putih", "Garis", "Besar", "Sedang", "Kecil", "Bawah", "Desktop", "Layar kunci"],
        "vi": ["Bot Wallpaper", "Màu nhân vật", "Cỡ nhân vật", "Mở Grok Bot", "Tạm dừng", "Tiếp tục", "Thoát hình nền", "Đỏ", "Cam", "Hổ phách", "Xanh lá", "Xanh ngọc", "Xanh dương", "Tím", "Hồng", "Trắng", "Đường viền", "Lớn", "Vừa", "Nhỏ", "Dưới", "Màn hình nền", "Màn hình khóa"],
        "th": ["Bot Wallpaper", "สีตัวละคร", "ขนาดตัวละคร", "เปิด Grok Bot", "หยุดชั่วคราว", "เล่นต่อ", "ปิดวอลเปเปอร์", "แดง", "ส้ม", "อำพัน", "เขียว", "เขียวน้ำทะเล", "น้ำเงิน", "ม่วง", "ชมพู", "ขาว", "เส้นขอบ", "ใหญ่", "กลาง", "เล็ก", "ล่าง", "เดสก์ท็อป", "หน้าจอล็อก"],
        "tr": ["Bot Wallpaper", "Karakter rengi", "Karakter boyutu", "Grok Bot’u aç", "Duraklat", "Devam et", "Duvar kâğıdını kapat", "Kırmızı", "Turuncu", "Kehribar", "Yeşil", "Turkuaz", "Mavi", "Mor", "Pembe", "Beyaz", "Ana hat", "Büyük", "Orta", "Küçük", "Alt", "Masaüstü", "Kilit ekranı"],
        "pl": ["Bot Wallpaper", "Kolor postaci", "Rozmiar postaci", "Otwórz Grok Bot", "Wstrzymaj", "Wznów", "Zamknij tapetę", "Czerwony", "Pomarańczowy", "Bursztynowy", "Zielony", "Turkusowy", "Niebieski", "Fioletowy", "Różowy", "Biały", "Kontur", "Duży", "Średni", "Mały", "Dół", "Pulpit", "Ekran blokady"],
        "sv": ["Bot Wallpaper", "Figurens färg", "Figurens storlek", "Öppna Grok Bot", "Pausa", "Fortsätt", "Avsluta bakgrund", "Röd", "Orange", "Bärnsten", "Grön", "Turkos", "Blå", "Lila", "Rosa", "Vit", "Kontur", "Stor", "Mellan", "Liten", "Nedre", "Skrivbord", "Låsskärm"],
        "da": ["Bot Wallpaper", "Figurens farve", "Figurens størrelse", "Åbn Grok Bot", "Sæt på pause", "Fortsæt", "Luk baggrund", "Rød", "Orange", "Rav", "Grøn", "Turkis", "Blå", "Lilla", "Pink", "Hvid", "Kontur", "Stor", "Mellem", "Lille", "Nederst", "Skrivebord", "Låseskærm"],
        "fi": ["Bot Wallpaper", "Hahmon väri", "Hahmon koko", "Avaa Grok Bot", "Tauko", "Jatka", "Sulje taustakuva", "Punainen", "Oranssi", "Meripihka", "Vihreä", "Turkoosi", "Sininen", "Violetti", "Pinkki", "Valkoinen", "Ääriviiva", "Iso", "Keski", "Pieni", "Ala", "Työpöytä", "Lukitusnäyttö"],
        "nb": ["Bot Wallpaper", "Figurfarge", "Figurstørrelse", "Åpne Grok Bot", "Pause", "Fortsett", "Avslutt bakgrunn", "Rød", "Oransje", "Rav", "Grønn", "Turkis", "Blå", "Lilla", "Rosa", "Hvit", "Kontur", "Stor", "Medium", "Liten", "Nederst", "Skrivebord", "Låseskjerm"],
        "cs": ["Bot Wallpaper", "Barva postavy", "Velikost postavy", "Otevřít Grok Bot", "Pozastavit", "Pokračovat", "Ukončit tapetu", "Červená", "Oranžová", "Jantarová", "Zelená", "Tyrkysová", "Modrá", "Fialová", "Růžová", "Bílá", "Obrys", "Velká", "Střední", "Malá", "Dole", "Plocha", "Zamykací obrazovka"],
        "el": ["Bot Wallpaper", "Χρώμα χαρακτήρα", "Μέγεθος χαρακτήρα", "Άνοιγμα Grok Bot", "Παύση", "Συνέχεια", "Κλείσιμο ταπετσαρίας", "Κόκκινο", "Πορτοκαλί", "Κεχριμπάρι", "Πράσινο", "Τιρκουάζ", "Μπλε", "Μοβ", "Ροζ", "Λευκό", "Περίγραμμα", "Μεγάλο", "Μεσαίο", "Μικρό", "Κάτω", "Επιφάνεια εργασίας", "Οθόνη κλειδώματος"],
        "he": ["Bot Wallpaper", "צבע הדמות", "גודל הדמות", "פתיחת Grok Bot", "השהיה", "המשך", "סגירת הטפט", "אדום", "כתום", "ענבר", "ירוק", "טורקיז", "כחול", "סגול", "ורוד", "לבן", "קו מתאר", "גדול", "בינוני", "קטן", "למטה", "שולחן עבודה", "מסך נעילה"],
        "ro": ["Bot Wallpaper", "Culoarea personajului", "Mărimea personajului", "Deschide Grok Bot", "Pauză", "Reia", "Închide fundalul", "Roșu", "Portocaliu", "Chihlimbar", "Verde", "Turcoaz", "Albastru", "Mov", "Roz", "Alb", "Contur", "Mare", "Mediu", "Mic", "Jos", "Desktop", "Ecran de blocare"],
        "hu": ["Bot Wallpaper", "Karakter színe", "Karakter mérete", "Grok Bot megnyitása", "Szünet", "Folytatás", "Háttérkép bezárása", "Piros", "Narancs", "Borostyán", "Zöld", "Türkiz", "Kék", "Lila", "Rózsaszín", "Fehér", "Körvonal", "Nagy", "Közepes", "Kicsi", "Alul", "Asztal", "Zárolási képernyő"]
    ]
    lazy var text: [String] = {
        for language in Locale.preferredLanguages {
            let lower = language.lowercased()
            if lower.hasPrefix("zh") {
                let traditional = lower.contains("hant") || lower.hasPrefix("zh-tw") || lower.hasPrefix("zh-hk") || lower.hasPrefix("zh-mo")
                return Self.translations[traditional ? "zh-Hant" : "zh-Hans"]!
            }
            let code = lower.split(separator: "-").first.map(String.init) ?? "en"
            let key = code == "no" ? "nb" : code
            if let found = Self.translations[key] { return found }
        }
        return Self.translations["en"]!
    }()
    static let loginLabels: [String: String] = [
        "ko": "로그인 시 자동 실행", "en": "Launch at login", "ja": "ログイン時に起動", "zh-Hans": "登录时启动", "zh-Hant": "登入時啟動",
        "es": "Abrir al iniciar sesión", "fr": "Ouvrir à la connexion", "de": "Bei Anmeldung öffnen", "pt": "Abrir ao iniciar sessão",
        "it": "Apri al login", "nl": "Open bij inloggen", "ru": "Запускать при входе", "uk": "Запускати під час входу",
        "ar": "التشغيل عند تسجيل الدخول", "hi": "लॉगिन पर खोलें", "id": "Buka saat masuk", "vi": "Mở khi đăng nhập",
        "th": "เปิดเมื่อเข้าสู่ระบบ", "tr": "Girişte aç", "pl": "Otwórz po zalogowaniu", "sv": "Öppna vid inloggning",
        "da": "Åbn ved login", "fi": "Avaa kirjauduttaessa", "nb": "Åpne ved pålogging", "cs": "Otevřít při přihlášení",
        "el": "Άνοιγμα κατά τη σύνδεση", "he": "פתיחה בעת התחברות", "ro": "Deschide la autentificare", "hu": "Megnyitás bejelentkezéskor"
    ]
    var loginLabel: String {
        for language in Locale.preferredLanguages {
            let lower = language.lowercased()
            if lower.hasPrefix("zh") {
                let traditional = lower.contains("hant") || lower.hasPrefix("zh-tw") || lower.hasPrefix("zh-hk") || lower.hasPrefix("zh-mo")
                return Self.loginLabels[traditional ? "zh-Hant" : "zh-Hans"]!
            }
            let code = lower.split(separator: "-").first.map(String.init) ?? "en"
            if let result = Self.loginLabels[code == "no" ? "nb" : code] { return result }
        }
        return Self.loginLabels["en"]!
    }
    func t(_ index: Int) -> String { text[index] }
    var sizeNames: [String] { Array(text[17...20]) }
    var sizeButtons: [NSButton] = []
    var selectedSize = 1
    let imageContext = CIContext()
    lazy var updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    var status: NSStatusItem!
    var pauseLabel: NSTextField!
    var pauseButton: NSButton!
    var paused = false
    let colors: [(String, UInt32)] = [("빨강",0xFF263C),("주황",0xFF6700),("귤색",0xFF9800),("초록",0x00C972),("청록",0x00BCA6),("파랑",0x1084FE),("보라",0x9159FE),("분홍",0xFF309B),("흰색",0xFFFFFF),("아웃라인",0x1000000)]
    let colorLock = NSLock()
    var selectedColor: UInt32 = 0xFFFFFF
    var colorButtons: [NSButton] = []
    let recolorKernel = CIColorKernel(source: """
        kernel vec4 recolor(__sample pixel, vec3 tint) {
            float lo = min(pixel.r, min(pixel.g, pixel.b));
            float hi = max(pixel.r, max(pixel.g, pixel.b));
            float neutral = 1.0 - smoothstep(0.025, 0.12, hi - lo);
            float coverage = clamp((lo - 0.00243) / (0.905 - 0.00243), 0.0, 1.0);
            vec3 colored = mix(vec3(0.00243), tint, coverage);
            return vec4(mix(pixel.rgb, colored, neutral), pixel.a);
        }
        """)
    let outlineValue: UInt32 = 0x1000000
    let outlineKernel = CIColorKernel(source: """
        kernel vec4 outline(__sample pixel) {
            float strength = max(pixel.r, max(pixel.g, pixel.b));
            float edge = smoothstep(0.08, 0.70, strength);
            return vec4(vec3(0.00243 + 0.07 * edge), 1.0);
        }
        """)
    func outlineImage(_ input: CIImage) -> CIImage {
        guard let kernel = outlineKernel else { return input }
        let edges = input.clampedToExtent().applyingFilter("CIEdges", parameters: [kCIInputIntensityKey: 1.0]).applyingFilter("CIMorphologyMaximum", parameters: [kCIInputRadiusKey: 1.0]).cropped(to: input.extent)
        return kernel.apply(extent: input.extent, arguments: [edges]) ?? input
    }
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        if AppInstaller.offerInstallation(onOpenFailure: { [weak self] in self?.startWallpaper() }) { return }
        startWallpaper()
    }
    func startWallpaper() {
        if let saved = UserDefaults.standard.object(forKey: "characterColor") as? NSNumber {
            let value = saved.uint32Value
            if colors.contains(where: { $0.1 == value }) { selectedColor = value }
        }
        if let savedSize = UserDefaults.standard.object(forKey: "characterSize") as? NSNumber,
           sizeNames.indices.contains(savedSize.intValue) { selectedSize = savedSize.intValue }
        if let saved = UserDefaults.standard.object(forKey: "desktopEnabled") as? NSNumber { desktopEnabled = saved.boolValue }
        lockEnabled = UserDefaults.standard.bool(forKey: "lockEnabled")
        status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let url = Bundle.main.url(forResource: "status", withExtension: "png"), let icon = NSImage(contentsOf: url) {
            icon.size = NSSize(width: 18, height: 18)
            icon.isTemplate = true
            status.button?.image = icon
            status.button?.imagePosition = .imageOnly
        }
        let menu = NSMenu()
        menu.addItem(withTitle: t(0), action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        let colorLabel = NSMenuItem(title: t(1), action: nil, keyEquivalent: "")
        menu.addItem(colorLabel)
        let palette = NSView(frame: NSRect(x: 0, y: 0, width: 220, height: 64))
        for (index, color) in colors.enumerated() {
            let column = index % 5
            let row = index / 5
            let button = NSButton(frame: NSRect(x: 18 + column * 40, y: 35 - row * 30, width: 24, height: 24))
            button.isBordered = false
            button.imagePosition = .imageOnly
            button.image = swatch(color.1, selected: color.1 == selectedColor)
            button.target = self
            button.action = #selector(selectColor(_:))
            button.tag = index
            button.toolTip = t(7 + index)
            button.setAccessibilityLabel(t(7 + index) )
            colorButtons.append(button)
            palette.addSubview(button)
        }
        let paletteItem = NSMenuItem()
        paletteItem.view = palette
        menu.addItem(paletteItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: t(2), action: nil, keyEquivalent: ""))
        let sizes = NSView(frame: NSRect(x: 0, y: 0, width: 220, height: 34))
        for (index, name) in sizeNames.enumerated() {
            let button = NSButton(frame: NSRect(x: 8 + index * 51, y: 3, width: 49, height: 26))
            button.title = name
            var fontSize: CGFloat = 11
            while fontSize > 8 && (name as NSString).size(withAttributes: [.font: NSFont.systemFont(ofSize: fontSize)]).width > 40 { fontSize -= 0.5 }
            button.font = NSFont.systemFont(ofSize: fontSize)
            button.bezelStyle = .rounded
            button.setButtonType(.pushOnPushOff)
            button.state = index == selectedSize ? .on : .off
            button.target = self
            button.action = #selector(selectSize(_:))
            button.tag = index
            sizeButtons.append(button)
            sizes.addSubview(button)
        }
        let sizeItem = NSMenuItem()
        sizeItem.view = sizes
        menu.addItem(sizeItem)
        menu.addItem(NSMenuItem.separator())
        let targets = NSView(frame: NSRect(x: 0, y: 0, width: 220, height: 52))
        desktopCheck = NSButton(checkboxWithTitle: t(21), target: self, action: #selector(toggleDesktop(_:)))
        desktopCheck.frame = NSRect(x: 14, y: 27, width: 194, height: 20)
        desktopCheck.state = desktopEnabled ? .on : .off
        targets.addSubview(desktopCheck)
        lockCheck = NSButton(checkboxWithTitle: t(22), target: self, action: #selector(toggleLock(_:)))
        lockCheck.frame = NSRect(x: 14, y: 3, width: 194, height: 20)
        lockCheck.state = lockEnabled ? .on : .off
        if ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 26 {
            lockCheck.isEnabled = false
            lockCheck.toolTip = "macOS 26 or later is required"
        }
        targets.addSubview(lockCheck)
        let targetsItem = NSMenuItem()
        targetsItem.view = targets
        menu.addItem(targetsItem)
        menu.addItem(NSMenuItem.separator())
        loginItem = NSMenuItem(title: loginLabel, action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        loginItem.target = self
        menu.addItem(loginItem)
        menu.delegate = self
        configureLaunchAtLogin()
        refreshLoginItem()
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuRow(title: t(3), symbol: "grok-avatar", action: #selector(openGrokBot)))
        menu.addItem(NSMenuItem.separator())
        let pauseRow = menuRow(title: t(4), symbol: "pause.fill", action: #selector(togglePause))
        pauseLabel = pauseRow.view?.viewWithTag(2) as? NSTextField
        pauseButton = pauseRow.view?.viewWithTag(3) as? NSButton
        menu.addItem(pauseRow)
        menu.addItem(menuRow(title: t(6), symbol: "power", action: #selector(quit)))
        menu.addItem(NSMenuItem.separator())
        let updates = NSMenuItem(title: Locale.preferredLanguages.first?.hasPrefix("ko") == true ? "업데이트 확인…" : "Check for Updates…", action: #selector(SPUStandardUpdaterController.checkForUpdates(_:)), keyEquivalent: "")
        updates.target = updaterController
        menu.addItem(updates)
        status.menu = menu
        let events = NSWorkspace.shared.notificationCenter
        events.addObserver(self, selector: #selector(frontApplicationChanged(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        events.addObserver(self, selector: #selector(sessionInactive), name: NSWorkspace.sessionDidResignActiveNotification, object: nil)
        events.addObserver(self, selector: #selector(sessionRestored), name: NSWorkspace.sessionDidBecomeActiveNotification, object: nil)
        events.addObserver(self, selector: #selector(displaysAsleep), name: NSWorkspace.screensDidSleepNotification, object: nil)
        events.addObserver(self, selector: #selector(displaysAwake), name: NSWorkspace.screensDidWakeNotification, object: nil)
        refreshFrontApplication()
        setup()
        if lockEnabled && UserDefaults.standard.integer(forKey: "lockMediaRevision") != lockMediaRevision {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.lockEnabled, self.lockCheck.isEnabled else { return }
                self.lockCheck.state = .on
                self.toggleLock(self.lockCheck)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(screensChanged), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    private var appIsInstalled: Bool {
        let system = URL(fileURLWithPath: "/Applications", isDirectory: true)
        let user = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Applications", isDirectory: true)
        return AppInstaller.isInApplications(Bundle.main.bundleURL, roots: [system, user])
    }
    private func configureLaunchAtLogin() {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: "launchAtLoginConfigured") == nil, appIsInstalled else { return }
        do {
            let initialStatus = SMAppService.mainApp.status
            if initialStatus == .notRegistered || initialStatus == .notFound { try SMAppService.mainApp.register() }
            let status = SMAppService.mainApp.status
            if status == .enabled || status == .requiresApproval {
                defaults.set(true, forKey: "launchAtLoginConfigured")
            }
        } catch { NSLog("Bot Wallpaper: could not enable launch at login: %@", error.localizedDescription) }
    }
    private func refreshLoginItem() {
        let status = SMAppService.mainApp.status
        loginItem.state = status == .enabled ? .on : .off
        loginItem.toolTip = status == .requiresApproval ? (Locale.preferredLanguages.first?.hasPrefix("ko") == true ? "시스템 설정에서 로그인 항목을 허용해 주세요." : "Allow this login item in System Settings.") : nil
    }
    func menuWillOpen(_ menu: NSMenu) { refreshLoginItem() }
    @objc func toggleLaunchAtLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .requiresApproval {
                SMAppService.openSystemSettingsLoginItems()
            } else if service.status == .enabled {
                try service.unregister()
                UserDefaults.standard.set(true, forKey: "launchAtLoginConfigured")
            } else {
                guard appIsInstalled else {
                    let alert = NSAlert()
                    let korean = Locale.preferredLanguages.first?.hasPrefix("ko") == true
                    alert.messageText = korean ? "응용 프로그램 폴더로 옮겨 주세요" : "Move the app to Applications"
                    alert.informativeText = korean ? "자동 실행을 사용하려면 앱을 응용 프로그램 폴더로 옮겨 다시 열어 주세요." : "Move the app to Applications and reopen it to use launch at login."
                    NSApp.activate(ignoringOtherApps: true); alert.runModal()
                    return
                }
                try service.register()
                UserDefaults.standard.set(true, forKey: "launchAtLoginConfigured")
                if service.status == .requiresApproval { SMAppService.openSystemSettingsLoginItems() }
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = Locale.preferredLanguages.first?.hasPrefix("ko") == true ? "자동 실행 설정을 변경할 수 없어요" : "Could not change launch at login"
            alert.informativeText = error.localizedDescription
            NSApp.activate(ignoringOtherApps: true); alert.runModal()
        }
        refreshLoginItem()
    }
    func menuRow(title: String, symbol: String, action: Selector) -> NSMenuItem {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 220, height: 30))
        let label = NSTextField(labelWithString: title)
        label.frame = NSRect(x: 14, y: 5, width: 194, height: 20)
        var fontSize = NSFont.menuFont(ofSize: 0).pointSize
        while fontSize > 9 && (title as NSString).size(withAttributes: [.font: NSFont.menuFont(ofSize: fontSize)]).width > 190 { fontSize -= 0.5 }
        label.font = NSFont.menuFont(ofSize: fontSize)
        label.textColor = .labelColor
        label.tag = 2
        container.addSubview(label)
        let button = NSButton(frame: container.bounds)
        button.isBordered = false
        button.title = ""
        button.setAccessibilityLabel(title)
        button.target = self
        button.action = action
        button.tag = 3
        container.addSubview(button)
        let item = NSMenuItem()
        item.view = container
        return item
    }
    func swatch(_ value: UInt32, selected: Bool) -> NSImage {
        let color = NSColor(srgbRed: CGFloat((value >> 16) & 255)/255, green: CGFloat((value >> 8) & 255)/255, blue: CGFloat(value & 255)/255, alpha: 1)
        let image = NSImage(size: NSSize(width: 24, height: 24), flipped: false) { rect in
            if selected {
                let ring = NSBezierPath(ovalIn: rect.insetBy(dx: 1.2, dy: 1.2))
                NSColor.labelColor.setStroke(); ring.lineWidth = 1.5; ring.stroke()
            }
            let circle = NSBezierPath(ovalIn: rect.insetBy(dx: 4, dy: 4))
            if value == self.outlineValue {
                NSColor.gray.setStroke(); circle.lineWidth = 1.5; circle.stroke()
            } else {
                color.setFill(); circle.fill()
                NSColor.separatorColor.setStroke(); circle.lineWidth = 0.7; circle.stroke()
            }
            return true
        }
        image.isTemplate = false
        return image
    }
    @objc func selectColor(_ sender: NSButton) {
        guard colors.indices.contains(sender.tag) else { return }
        let value = colors[sender.tag].1
        colorLock.lock(); let previous = selectedColor; selectedColor = value; colorLock.unlock()
        UserDefaults.standard.set(NSNumber(value: value), forKey: "characterColor")
        for (i, button) in colorButtons.enumerated() {
            button.image = swatch(colors[i].1, selected: i == sender.tag)
        }
        if (previous == 0xFFFFFF) != (value == 0xFFFFFF) { reconfigureVideoPlayers() }
        if paused { updatePausedImage() }
        if previous != value { queueLockRefresh() }
        status.menu?.cancelTracking()
    }
    @objc func toggleDesktop(_ sender: NSButton) {
        desktopEnabled = sender.state == .on
        UserDefaults.standard.set(desktopEnabled, forKey: "desktopEnabled")
        updateDesktopVisibility()
        status.menu?.cancelTracking()
    }
    func updateDesktopVisibility() {
        for index in windows.indices {
            let showOriginal = !desktopEnabled && lockEnabled
            originalLayers[index].isHidden = !showOriginal
            videoLayers[index].isHidden = !desktopEnabled
            stillLayers[index].isHidden = !desktopEnabled || !paused
            if desktopEnabled || showOriginal { windows[index].orderFrontRegardless() } else { windows[index].orderOut(nil) }
        }
        updatePlayback()
    }
    func refreshFrontApplication() {
        guard let front = NSWorkspace.shared.frontmostApplication else { return }
        if front.activationPolicy == .regular {
            desktopActive = front.bundleIdentifier == "com.apple.finder"
        }
    }
    func updatePlayback() {
        let shouldPlay = desktopEnabled && !paused && sessionActive && displayAwake
        for player in players {
            if shouldPlay { if player.rate == 0 { player.playImmediately(atRate: 1.0) } }
            else if player.rate != 0 { player.pause() }
        }
    }
    @objc func frontApplicationChanged(_ notification: Notification) {
        if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
           app.activationPolicy == .regular {
            desktopActive = app.bundleIdentifier == "com.apple.finder"
        } else {
            refreshFrontApplication()
        }
        updatePlayback()
    }
    @objc func sessionInactive() { sessionActive = false; updatePlayback() }
    @objc func sessionRestored() { sessionActive = true; refreshFrontApplication(); updatePlayback() }
    @objc func displaysAsleep() { displayAwake = false; updatePlayback() }
    @objc func displaysAwake() { displayAwake = true; refreshFrontApplication(); updatePlayback() }
    func queueLockRefresh() {
        guard lockEnabled || lockUpdatingEnable else { return }
        lockUpdatePending = true
        lockRefreshGeneration += 1
        let generation = lockRefreshGeneration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, self.lockRefreshGeneration == generation,
                  self.lockUpdatePending, self.lockEnabled, self.lockCheck.isEnabled else { return }
            self.lockUpdatePending = false
            self.lockCheck.state = .on
            self.toggleLock(self.lockCheck)
        }
    }
    @objc func toggleLock(_ sender: NSButton) {
        let enable = sender.state == .on
        let helper = Bundle.main.bundleURL.appendingPathComponent("Contents/Helpers/lock-helper")
        guard FileManager.default.isExecutableFile(atPath: helper.path),
              let source = Bundle.main.url(forResource: "Lock Screen Source", withExtension: "mp4") else {
            sender.state = lockEnabled ? .on : .off
            return
        }
        if enable && !lockEnabled {
            let paths = NSScreen.screens.map { NSWorkspace.shared.desktopImageURL(for: $0)?.path ?? "" }
            UserDefaults.standard.set(paths, forKey: "originalWallpaperPaths")
        }
        sender.isEnabled = false
        lockUpdatingEnable = enable
        let requestedColor = selectedColor
        let requestedSize = selectedSize
        status.menu?.cancelTracking()
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            process.executableURL = helper
            process.arguments = enable ? ["install-custom", source.path, String(requestedColor), String(requestedSize)] : ["restore"]
            let errors = Pipe(); process.standardError = errors
            do {
                try process.run(); process.waitUntilExit()
                let detail = String(data: errors.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                let ok = process.terminationStatus == 0
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.lockCheck.isEnabled = true
                    self.lockUpdatingEnable = false
                    if ok {
                        self.lockEnabled = enable
                        UserDefaults.standard.set(enable, forKey: "lockEnabled")
                        if enable { UserDefaults.standard.set(self.lockMediaRevision, forKey: "lockMediaRevision") }
                        else { UserDefaults.standard.removeObject(forKey: "lockMediaRevision") }
                        self.lockCheck.state = enable ? .on : .off
                        self.updateDesktopVisibility()
                        if self.lockUpdatePending && enable { self.queueLockRefresh() }
                        else if !enable { self.lockUpdatePending = false }
                    } else {
                        self.lockUpdatePending = false
                        self.lockCheck.state = self.lockEnabled ? .on : .off
                        let alert = NSAlert(); alert.messageText = "Lock screen could not be updated"; alert.informativeText = detail
                        NSApp.activate(ignoringOtherApps: true); alert.runModal()
                    }
                }
            } catch {
                let detail = error.localizedDescription
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.lockUpdatingEnable = false; self.lockUpdatePending = false
                    self.lockCheck.isEnabled = true; self.lockCheck.state = self.lockEnabled ? .on : .off
                    let alert = NSAlert(); alert.messageText = "Lock screen could not be updated"; alert.informativeText = detail
                    NSApp.activate(ignoringOtherApps: true); alert.runModal()
                }
            }
        }
    }
    @objc func selectSize(_ sender: NSButton) {
        guard sizeNames.indices.contains(sender.tag) else { return }
        let previousSize = selectedSize
        selectedSize = sender.tag
        UserDefaults.standard.set(selectedSize, forKey: "characterSize")
        for (index, button) in sizeButtons.enumerated() { button.state = index == selectedSize ? .on : .off }
        applySize()
        if previousSize != selectedSize { queueLockRefresh() }
        status.menu?.cancelTracking()
    }
    func applySize() {
        let scale: CGFloat = selectedSize == 1 ? 0.75 : selectedSize == 2 ? 0.5 : 1.0
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for index in contentViews.indices {
            let bounds = contentViews[index].bounds
            let position = CGPoint(x: bounds.midX, y: bounds.midY - (selectedSize == 3 ? bounds.height * 0.36 : 0))
            for layer in [videoLayers[index] as CALayer, stillLayers[index]] {
                layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
                layer.position = position
            }
        }
        CATransaction.commit()
    }
    func linear(_ value: UInt32) -> CGFloat {
        let s = CGFloat(value) / 255
        return s <= 0.04045 ? s / 12.92 : pow((s + 0.055) / 1.055, 2.4)
    }
    @objc func togglePause() {
        paused.toggle()
        if paused {
            players.forEach { $0.pause() }
            updatePausedImage()
            stillLayers.forEach { $0.isHidden = !desktopEnabled }
        } else {
            stillLayers.forEach { $0.isHidden = true }
            updatePlayback()
        }
        let title = paused ? t(5) : t(4)
        pauseLabel.stringValue = title
        pauseButton.setAccessibilityLabel(title)
        status.menu?.cancelTracking()
    }
    @objc func openGrokBot() {
        status.menu?.cancelTracking()
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.anysphere.sand") {
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
        } else if let downloadURL = URL(string: "https://x.ai/bot") {
            NSWorkspace.shared.open(downloadURL)
        }
    }
    func updatePausedImage() {
        guard let url = Bundle.main.url(forResource: "paused", withExtension: "png"),
              let input = CIImage(contentsOf: url) else { return }
        colorLock.lock(); let value = selectedColor; colorLock.unlock()
        var result = input
        if value == outlineValue {
            result = outlineImage(input)
        } else if value != 0xFFFFFF, let kernel = recolorKernel {
            let tint = CIVector(x: linear((value >> 16) & 255), y: linear((value >> 8) & 255), z: linear(value & 255))
            result = kernel.apply(extent: input.extent, arguments: [input, tint]) ?? input
        }
        guard let image = imageContext.createCGImage(result, from: input.extent, format: .RGBA8, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)) else { return }
        stillLayers.forEach { $0.contents = image }
    }
    @objc func quit() { status.menu?.cancelTracking(); NSApp.terminate(nil) }
    @objc func screensChanged() { setup() }
    func makePlayerItem(url: URL, filtered: Bool) -> AVPlayerItem {
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        guard filtered else { return item }
        item.videoComposition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { [weak self] request in
            guard let self = self else { request.finish(with: request.sourceImage, context: nil); return }
            self.colorLock.lock(); let value = self.selectedColor; self.colorLock.unlock()
            if value == self.outlineValue {
                request.finish(with: self.outlineImage(request.sourceImage), context: nil); return
            }
            guard value != 0xFFFFFF, let kernel = self.recolorKernel else {
                request.finish(with: request.sourceImage, context: nil); return
            }
            let tint = CIVector(x: self.linear((value >> 16) & 255), y: self.linear((value >> 8) & 255), z: self.linear(value & 255))
            let output = kernel.apply(extent: request.sourceImage.extent, arguments: [request.sourceImage, tint]) ?? request.sourceImage
            request.finish(with: output, context: nil)
        })
        return item
    }
    func reconfigureVideoPlayers() {
        guard let url = Bundle.main.url(forResource: "Grok Bot", withExtension: "mp4") else { return }
        playbackGeneration += 1
        let generation = playbackGeneration
        colorLock.lock(); let filtered = selectedColor != 0xFFFFFF; colorLock.unlock()
        for index in players.indices {
            let player = players[index]
            let current = player.currentTime()
            let position = current.isNumeric && current.seconds >= 0 ? current : .zero
            player.pause()
            loopers[index].disableLooping()
            player.removeAllItems()
            loopers[index] = AVPlayerLooper(player: player, templateItem: makePlayerItem(url: url, filtered: filtered))
            player.seek(to: position, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self, weak player] _ in
                DispatchQueue.main.async {
                    guard let self = self, let player = player, self.playbackGeneration == generation,
                          self.players.contains(where: { $0 === player }) else { return }
                    self.updatePlayback()
                }
            }
        }
    }
    func setup() {
        playbackGeneration += 1
        windows.forEach { $0.close() }; windows.removeAll(); players.removeAll(); loopers.removeAll(); stillLayers.removeAll(); videoLayers.removeAll(); contentViews.removeAll(); originalLayers.removeAll()
        guard let url = Bundle.main.url(forResource: "Grok Bot", withExtension: "mp4") else { return }
        let savedPaths = UserDefaults.standard.stringArray(forKey: "originalWallpaperPaths") ?? []
        for (screenIndex, screen) in NSScreen.screens.enumerated() {
            // The initializer positions its rectangle relative to the chosen screen.
            let window = NSWindow(contentRect: NSRect(origin: .zero, size: screen.frame.size), styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
            window.isReleasedWhenClosed = false
            window.setFrame(screen.frame, display: false)
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)) + 1)
            window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
            window.ignoresMouseEvents = true
            window.isOpaque = true
            window.backgroundColor = .black
            let view = NSView(frame: NSRect(origin: .zero, size: screen.frame.size))
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor(srgbRed: 8/255, green: 8/255, blue: 8/255, alpha: 1).cgColor
            view.layer?.masksToBounds = true
            let original = CALayer()
            original.frame = view.bounds
            original.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            original.contentsGravity = .resizeAspectFill
            let originalPath = lockEnabled && screenIndex < savedPaths.count ? savedPaths[screenIndex] : NSWorkspace.shared.desktopImageURL(for: screen)?.path
            if let path = originalPath, !path.isEmpty, let image = NSImage(contentsOfFile: path) {
                original.contents = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
            }
            original.isHidden = true
            view.layer?.addSublayer(original)
            originalLayers.append(original)
            let player = AVQueuePlayer()
            player.isMuted = true
            player.automaticallyWaitsToMinimizeStalling = false
            colorLock.lock(); let filtered = selectedColor != 0xFFFFFF; colorLock.unlock()
            let item = makePlayerItem(url: url, filtered: filtered)
            let looper = AVPlayerLooper(player: player, templateItem: item)
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill
            layer.frame = view.bounds
            layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            view.layer?.addSublayer(layer)
            let still = CALayer()
            still.frame = view.bounds
            still.contentsGravity = .resizeAspectFill
            still.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            still.isHidden = !paused
            view.layer?.addSublayer(still)
            stillLayers.append(still)
            videoLayers.append(layer)
            contentViews.append(view)
            window.contentView = view
            window.orderFrontRegardless()
            windows.append(window); players.append(player); loopers.append(looper)
        }
        applySize()
        if paused { updatePausedImage() }
        updateDesktopVisibility()
    }
}
@main
struct Main {
    static func main() {
        let app = NSApplication.shared
        let delegate = App()
        app.delegate = delegate
        app.run()
    }
}
