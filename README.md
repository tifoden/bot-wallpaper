# Bot Wallpaper

[English](#english) · [日本語](#日本語) · [简体中文](#简体中文) · [한국어](#한국어)

## English

Bot Wallpaper is a macOS menu bar app for choosing the color and size of an animated character wallpaper.

### Download and installation

Download the ZIP from the [latest release](https://github.com/tifoden/bot-wallpaper/releases/latest), unzip it, and move `Bot Wallpaper.app` to **Applications** before opening it. Use its menu bar icon to change settings. If you are running an earlier personal version, quit it first.

### Features and limitations

- Universal build for Apple Silicon and Intel Macs; macOS 13 or later. The animated lock screen option requires macOS 26 or later.
- The lock screen option uses an Apple aerial video slot rather than a public macOS API. It backs up the existing video and settings before applying the wallpaper and restores them when disabled. Behavior may change after macOS updates.
- The lock screen video is white and medium-sized; desktop color and size choices do not automatically apply to it.
- Sparkle 2 automatically checks for and installs updates. Update archives are verified using EdDSA signatures.
- The lock screen helper is based on [Motion Wallpaper](https://github.com/krol44/MotionWallpaper), licensed under GPL-3.0. Its modified source and license are in `Lock Screen Helper Source`; the Sparkle license is included with its download.

### Building and releasing

Install the Xcode command-line tools, then run `scripts/bootstrap.sh` to download Sparkle 2.10.1 with SHA-256 verification. Build and verify with an HTTPS appcast URL:

```sh
FEED_URL='https://example.com/appcast.xml' scripts/build.sh
scripts/verify-build.sh
```

The default output is `/tmp/bot-wallpaper-release-build`, signed locally for testing. The URL above is an example; a distributable build needs the real GitHub appcast URL.

To prepare a release, use a Developer ID Application certificate and a `notarytool` Keychain profile:

```sh
GITHUB_REPOSITORY='owner/repository' \
VERSION='1.0.0' BUILD_NUMBER='1' \
SIGNING_IDENTITY='Developer ID Application: Name (TEAMID)' \
NOTARY_PROFILE='profile-name' \
scripts/release-local.sh
```

The script signs, notarizes and staples the app, then creates a ZIP and signed `appcast.xml` locally; it does not publish to GitHub. Review and upload both assets to the matching GitHub Release. Increase `BUILD_NUMBER` for each release, and verify the public download and feed URLs afterward. Keep credentials and Sparkle private keys out of the repository. The Sparkle Keychain account for this project is `tifoden.bot-wallpaper`; safeguard it because losing the key can affect updates for existing users.

### Attribution

This is an **unofficial, non-commercial** independent project. It is not made, endorsed, sponsored, or affiliated with SpaceXSI. All rights to Grok, Grok Bot, and related trademarks, logos, and characters belong to SpaceXSI. The bot video and avatar originate from the xAI website. Attribution does not itself grant permission to redistribute them; review the [xAI brand guidelines](https://x.ai/legal/brand-guidelines).

---

## 日本語

Bot Wallpaper は、動くキャラクター壁紙の色とサイズをメニューバーから選べる macOS アプリです。

### ダウンロードとインストール

[最新リリース](https://github.com/tifoden/bot-wallpaper/releases/latest)から ZIP をダウンロードして展開し、`Bot Wallpaper.app` を**アプリケーション**フォルダに移動してから開いてください。設定はメニューバーのアイコンから変更できます。以前の個人用バージョンを使用中の場合は、先に終了してください。

### 機能と制限

- Apple Silicon と Intel 向けのユニバーサルビルド。macOS 13 以降に対応し、動くロック画面には macOS 26 以降が必要です。
- ロック画面には公開 API ではなく Apple の空撮動画スロットを使用します。適用前に既存の動画と設定をバックアップし、無効化時に復元します。macOS の更新により動作が変わる場合があります。
- ロック画面の動画は白色・中サイズで、デスクトップの色やサイズの設定は自動では反映されません。
- Sparkle 2 が更新を自動的に確認・インストールし、更新ファイルを EdDSA 署名で検証します。
- ロック画面ヘルパーは GPL-3.0 の [Motion Wallpaper](https://github.com/krol44/MotionWallpaper) を基にしています。変更したソースとライセンスは `Lock Screen Helper Source` に収録しています。Sparkle のライセンスはそのダウンロードに含まれます。

### ビルドとリリース

Xcode コマンドラインツールをインストールし、`scripts/bootstrap.sh` で Sparkle 2.10.1 をダウンロードします。SHA-256 が検証されます。ビルドと公証のコマンドは[英語の手順](#building-and-releasing)を参照してください。リリースには Developer ID Application 証明書と `notarytool` のキーチェーンプロファイルが必要です。認証情報や Sparkle の秘密鍵をリポジトリに含めないでください。

### 権利表記

本アプリは独立した**非公式・非商用**プロジェクトであり、SpaceXSI による制作、承認、後援、提携を受けていません。Grok、Grok Bot および関連する商標・ロゴ・キャラクターのすべての権利は SpaceXSI に帰属します。動画とアバターは xAI のウェブサイトに由来します。出典表記だけで再配布の許可が得られるわけではありません。[xAI ブランドガイドライン](https://x.ai/legal/brand-guidelines)を確認してください。

---

## 简体中文

Bot Wallpaper 是一款 macOS 菜单栏应用，可选择动态角色壁纸的颜色和大小。

### 下载与安装

从[最新版本](https://github.com/tifoden/bot-wallpaper/releases/latest)下载 ZIP 并解压，将 `Bot Wallpaper.app` 移到**应用程序**文件夹后打开。通过菜单栏图标调整设置。如果正在运行旧的个人版本，请先退出。

### 功能与限制

- 提供适用于 Apple Silicon 和 Intel Mac 的通用构建，需要 macOS 13 或更高版本。动态锁屏功能需要 macOS 26 或更高版本。
- 锁屏功能使用 Apple 航拍视频槽位，而非 macOS 公开 API。应用前会备份原视频及设置，关闭功能时恢复。macOS 更新后行为可能变化。
- 锁屏视频固定为白色、中等大小，不会自动跟随桌面的颜色和大小设置。
- Sparkle 2 自动检查并安装更新，使用 EdDSA 签名验证更新文件。
- 锁屏辅助程序基于 GPL-3.0 许可的 [Motion Wallpaper](https://github.com/krol44/MotionWallpaper)。修改后的源代码和许可证位于 `Lock Screen Helper Source`；Sparkle 的许可证包含在其下载文件中。

### 构建与发布

安装 Xcode 命令行工具后，运行 `scripts/bootstrap.sh` 下载 Sparkle 2.10.1，脚本会验证 SHA-256。构建和公证命令见[英文说明](#building-and-releasing)。发布需要 Developer ID Application 证书和 `notarytool` 钥匙串配置；请勿将凭据或 Sparkle 私钥提交到仓库。

### 权利声明

本项目是独立的**非官方、非商业**项目，不由 SpaceXSI 制作、认可、赞助或与其关联。Grok、Grok Bot 及相关商标、标志和角色的所有权利归 SpaceXSI 所有。视频和头像来自 xAI 网站。标明来源本身并不授予再分发权限；请查看 [xAI 品牌指南](https://x.ai/legal/brand-guidelines)。

---

## 한국어

Bot Wallpaper는 움직이는 캐릭터 배경화면의 색상과 크기를 메뉴 막대에서 선택할 수 있는 macOS 앱입니다.

### 다운로드 및 설치

[최신 릴리스](https://github.com/tifoden/bot-wallpaper/releases/latest)에서 ZIP을 내려받아 압축을 풀고, `Bot Wallpaper.app`을 **응용 프로그램** 폴더로 옮겨 실행합니다. 메뉴 막대 아이콘에서 설정을 바꿀 수 있습니다. 이전 개인용 버전을 실행 중이라면 먼저 종료해 주세요.

### 기능과 제한

- Apple Silicon과 Intel용 범용 빌드이며 macOS 13 이상이 필요합니다. 움직이는 잠금화면은 macOS 26 이상에서 사용할 수 있습니다.
- 잠금화면에는 공개 API가 아닌 Apple 풍경 영상 슬롯을 사용합니다. 적용 전에 기존 영상과 설정을 백업하고 해제할 때 복원합니다. macOS 업데이트 후 동작이 달라질 수 있습니다.
- 잠금화면 영상은 흰색·중간 크기이며, 바탕화면에서 선택한 색상과 크기는 자동으로 반영되지 않습니다.
- Sparkle 2가 업데이트를 자동으로 확인·설치하고, 업데이트 파일을 EdDSA 서명으로 검증합니다.
- 잠금화면 도우미는 GPL-3.0인 [Motion Wallpaper](https://github.com/krol44/MotionWallpaper)를 기반으로 합니다. 수정된 소스와 라이선스는 `Lock Screen Helper Source`에 포함되어 있으며, Sparkle 라이선스는 프레임워크 다운로드에 포함됩니다.

### 빌드 및 릴리스

Xcode 명령줄 도구를 설치한 뒤 `scripts/bootstrap.sh`를 실행하면 Sparkle 2.10.1을 다운로드하고 SHA-256을 확인합니다. 빌드와 공증 명령은 [영어 안내](#building-and-releasing)를 참고해 주세요. 릴리스에는 Developer ID Application 인증서와 `notarytool` 키체인 프로필이 필요합니다. 인증 정보나 Sparkle 개인 키를 저장소에 넣지 마세요.

### 권리 안내

이 프로젝트는 독립적인 **비공식·비상업적** 프로젝트이며, SpaceXSI의 제작·승인·후원 또는 제휴를 받지 않았습니다. Grok, Grok Bot 및 관련 상표·로고·캐릭터의 모든 권리는 SpaceXSI에 있습니다. 봇 영상과 아바타는 xAI 웹사이트에서 유래합니다. 출처 표기 자체가 재배포 권한을 부여하지는 않으므로 [xAI 브랜드 지침](https://x.ai/legal/brand-guidelines)을 확인해 주세요.
