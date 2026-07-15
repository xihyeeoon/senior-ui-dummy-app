# 고령자 UI 연구 — 실험용 더미 앱 (Flutter)

HCI 석사 연구 *"고령자 친화 모바일 UI 재설계 자동화 도구"*의 **평가용 클릭 프로토타입**입니다.
진단→재설계 **엔진(도구)** 코드는 별도 저장소 `senior-ui-redesign`에 있으며, 이 repo는 그와 독립적입니다.

## 역할 (연구 계획 v4)

인터뷰·평가에서 참가자에게 보여줄 **클릭 가능한 화면**. 실거래·실제 금융정보는 넣지 않습니다(0).
대상 앱 = **KB스타뱅킹**, 플로우 = **공과금 납부**. 평가는 **과제 기반 자유 탐색**(참가자에게 과제만 주고 스스로 수행).

- **A1 (원본 재현)** — 실제 KB스타뱅킹을 *충실히 재현*한 목업 (개선 없이 원본 그대로). 개인·금융정보는 더미로 치환.
- **A2 (배포 고령자 모드)** — 앱에 실제 배포된 고령자/쉬운 모드 재현.
- **C (도구 재설계)** — 엔진이 생성한 재설계안을 구현한 프로토타입.

## 기술 스택 결정

- **Flutter (네이티브)** — 지도교수 방침. 실험폰(안드로이드)에 실제 앱으로 설치해 평가.
- 개발 중 미리보기는 Chrome(웹)으로 가능(안드로이드 SDK 없이도).

## 구조

```
lib/
├─ main.dart                  # 앱 진입 + 조건(A1/A2/C) 선택 랜딩(개발용)
└─ screens/
   └─ a1_kb_home.dart         # A1 · KB 홈 재현
test/
└─ widget_test.dart           # 스모크 테스트
```

## 실행

```powershell
# 웹(Chrome) 미리보기 — 안드로이드 SDK 불필요
flutter run -d chrome

# 실험폰(안드로이드)에 설치 — Android SDK 세팅 + USB 디버깅 필요
flutter run -d <device_id>     # flutter devices 로 id 확인
flutter build apk              # APK로 빌드해 설치도 가능
```

> 실험폰 배포 전 `flutter doctor` 에서 `[√] Android toolchain` 확인 필요
> (Android Studio SDK Manager로 SDK 설치 후 `flutter doctor --android-licenses`).

## 다음 단계

- [ ] A1: 공과금 납부 플로우 화면들 재현 (진입 → 납부번호 입력 → 확인 → 인증 → 완료)
- [ ] A1 ↔ 실제 KB 1:1 충실도 대조표 (`docs/fidelity.md`)
- [ ] 범위 밖 탭 처리(자유 탐색 시 안 깨지게)
- [ ] A2: 배포 고령자 모드 재현
- [ ] C: 엔진 재설계 산출물을 화면으로 구현
- [ ] 실험폰 PWA/전체화면(시스템 UI 숨김) 세팅
