# Bot Wallpaper — 배포 준비

macOS 메뉴 막대에서 캐릭터 배경화면의 색상과 크기를 선택하는 앱입니다. GitHub Releases에서 다운로드할 수 있습니다.

## 다운로드 및 설치

[최신 버전 다운로드](https://github.com/tifoden/bot-wallpaper/releases/latest/download/Bot-Wallpaper-1.0.0.zip) 후 압축을 풀고 `Bot Wallpaper.app`을 **응용 프로그램** 폴더에 옮겨 실행합니다. 실행 후 메뉴 막대 아이콘에서 설정할 수 있습니다. 이미 이전 개인용 버전을 실행 중이라면 먼저 종료해 주세요.

## 기능과 제한

- Apple Silicon과 Intel용 범용 빌드, macOS 13 이상. 움직이는 잠금화면은 macOS 26 이상에서만 활성화됩니다.
- 잠금화면은 macOS의 공개 API가 아닌 Apple 풍경 영상 슬롯을 사용합니다. 적용 전 기존 설정과 영상을 백업하고 해제할 때 복원합니다. macOS 업데이트에 따라 작동이 달라질 수 있습니다.
- 잠금화면 영상은 흰색·중간 크기이고, 바탕화면에서 선택한 색상이나 크기를 자동으로 따르지 않습니다.
- Sparkle 2를 사용해 자동으로 업데이트를 확인하고 설치합니다. 업데이트 압축 파일을 EdDSA로 검증합니다.
- 봇 영상과 아바타는 xAI 페이지에서 유래합니다. 공개 배포 전에 원본 사용 권한과 제품 이름·아이콘에 대한 [xAI 브랜드 지침](https://x.ai/legal/brand-guidelines)을 확인해야 합니다.
- 잠금화면 도우미는 GPL-3.0인 [Motion Wallpaper](https://github.com/krol44/MotionWallpaper)를 기반으로 합니다. 수정된 도우미 소스와 라이선스를 `Lock Screen Helper Source`에 포함했습니다. Sparkle 라이선스는 프레임워크 다운로드에 포함됩니다.

## 로컬 빌드

1. Xcode 명령줄 도구를 설치합니다.
2. `scripts/bootstrap.sh`로 Sparkle 2.10.1을 내려받습니다. 스크립트는 SHA-256을 확인합니다.
3. 실제 릴리스에 사용할 HTTPS appcast 주소를 지정해 빌드합니다.

```sh
FEED_URL='https://example.com/appcast.xml' scripts/build.sh
scripts/verify-build.sh
```

기본 빌드는 임시 폴더 `/tmp/bot-wallpaper-release-build`에 생성하며 로컬 시험용 서명입니다. 이 주소는 예시입니다. 사용자에게 배포할 빌드에는 실제 GitHub 주소가 필요합니다.

## 공증 및 릴리스 준비

macOS Developer ID Application 인증서와 `notarytool` 키체인 프로필이 필요합니다. 인증 정보나 Sparkle 개인 키를 저장소에 넣지 마세요. 이 Mac의 Sparkle 키체인 계정은 `tifoden.bot-wallpaper`입니다. 이 키를 잃으면 기존 사용자에게 업데이트를 제공하는 데 문제가 생길 수 있으므로 안전하게 보관해야 합니다.

```sh
GITHUB_REPOSITORY='owner/repository' \
VERSION='1.0.0' BUILD_NUMBER='1' \
SIGNING_IDENTITY='Developer ID Application: Name (TEAMID)' \
NOTARY_PROFILE='profile-name' \
scripts/release-local.sh
```

이 스크립트는 Apple Developer ID 서명 → 공증 → 스테이플 → ZIP → 서명된 `appcast.xml`을 로컬에서 생성합니다. 자동으로 GitHub에 게시하지 않습니다. 결과를 확인한 다음 해당 버전 태그의 GitHub Release에 ZIP과 `appcast.xml`을 함께 올려야 합니다. 새 릴리스마다 `BUILD_NUMBER`를 증가시켜야 합니다. 각 릴리스를 올린 뒤 공개 다운로드 URL과 업데이트 피드가 정상적으로 열리는지 확인하세요.

## 출처 및 비공식 프로젝트 안내

이 프로젝트는 개인이 만든 **비공식·비상업적** 프로젝트이며 SpaceXSI의 제작, 승인, 후원 또는 제휴를 받지 않았습니다. Grok 및 Grok Bot과 관련 상표·로고·캐릭터 등의 모든 관련 권리는 SpaceXSI에 있습니다. 출처와 권리 귀속을 명시하는 것은 그 자체로 원본 영상·아바타의 재배포 권한을 부여하지 않습니다.
