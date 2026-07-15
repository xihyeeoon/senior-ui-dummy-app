# 고령자 UI 연구 — 실험용 더미 앱 (Flutter)

HCI 석사 연구 *"고령자 친화 모바일 UI 재설계 자동화 도구"*의 **평가용 클릭 프로토타입**입니다.
진단→재설계 **엔진(도구)** 코드는 별도 저장소 `senior-ui-redesign`에 있으며, 이 repo는 그와 독립적입니다.

## 역할 (연구 계획 v4)

인터뷰·평가에서 참가자에게 보여줄 **클릭 가능한 화면**. 실거래·실제 금융정보는 넣지 않습니다(0).
대상 앱 = **KB스타뱅킹**. 평가는 **과제 기반 자유 탐색**(참가자에게 과제만 주고 스스로 수행).

과제(플로우)는 2개입니다.

| | 과제 | 경로 | 상태 |
|---|---|---|---|
| 1 | **공과금 납부** | 메뉴 → 공과금 납부/조회 → 생활공과금 > 전기/TV → 전자납부번호 입력 → 조회 → … | 입력까지 재현 (이후 캡처 없음) |
| 2 | **이체** | 홈 [이체] 또는 메뉴 → 이체 → 상대 선택 → 금액 → 확인 → 완료 | **전 구간 재현** |

> 재현은 **실제 캡처가 있을 때만** 합니다. 근거·의도적 차이·미확인 항목은 [`docs/fidelity.md`](docs/fidelity.md) 참고.

- **A1 (원본 재현)** — 실제 KB스타뱅킹을 *충실히 재현*한 목업 (개선 없이 원본 그대로). 개인·금융정보는 더미로 치환.
- **A2 (배포 고령자 모드)** — 앱에 실제 배포된 고령자/쉬운 모드 재현.
- **C (도구 재설계)** — 엔진이 생성한 재설계안을 구현한 프로토타입.

## 기술 스택 결정

- **Flutter (네이티브)** — 지도교수 방침. 실험폰(안드로이드)에 실제 앱으로 설치해 평가.
- 개발 중 미리보기는 Chrome(웹)으로 가능(안드로이드 SDK 없이도).

## 구조

```
lib/
├─ main.dart                     # 앱 진입 + 조건(A1/A2/C) 선택 랜딩(개발용)
├─ data/
│  └─ kb_dummy.dart              # 더미 이름·계좌·잔액 (실정보 0)
├─ theme/
│  └─ kb_theme.dart              # 색·타이포 토큰
├─ widgets/
│  ├─ kb_common.dart             # KbAppBar, KbDevBar, KbButton, OutOfScope 등
│  ├─ kb_number_keypad.dart      # 일반 숫자 키패드 (배열 고정) — 금액·납부번호
│  └─ kb_security_keypad.dart    # 보안 키패드 (숫자 섞임) — 현재 미사용
└─ screens/
   ├─ a1_kb_home.dart            # A1 · 기본 홈 (간편홈 OFF)
   ├─ a2_kb_home.dart            # A2 · 간편홈 (단순화 모드)
   ├─ a1_menu.dart               # A1 · 전체메뉴 (13개 섹션 + 스크롤 스파이)
   ├─ a1_bill_main.dart          # 과제1 · 공과금 납부/조회
   ├─ a1_bill_input.dart         # 과제1 · 전기요금/TV수신료 전자납부번호 입력
   ├─ a1_transfer_entry.dart     # 과제2 · 이체 진입 (받는 사람)
   ├─ a1_transfer_amount.dart    # 과제2 · 금액 입력 + 상세 + 확인 시트
   └─ a1_transfer_done.dart      # 과제2 · 이체 완료
docs/
├─ fidelity.md                   # A1 ↔ 실제 KB 충실도 대조표
└─ screenshots/                  # 근거 캡처 (커밋 제외, 로컬 보관)
test/
└─ widget_test.dart              # 화면 전환·과제 경로 검증
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

- [x] A1 ↔ 실제 KB 1:1 충실도 대조표 (`docs/fidelity.md`)
- [x] 범위 밖 탭 처리(자유 탐색 시 안 깨지게) — `OutOfScope`
- [x] A1 · 전체메뉴 재현 (과제 진입 경로)
- [x] A1 · 과제2 이체: 진입 → 금액 → 확인 → 완료
- [x] A2: 간편홈 재현
- [ ] **A1 · 과제1 공과금: `[조회]` 이후 (확인 → 인증 → 완료)** — 실제 고지서 없어 캡처 대기
- [ ] 공과금 입력란 키패드 확인 (현재는 이체 근거로 일반 키패드 채택)
- [ ] 인증 화면 — 공과금·이체 양쪽 다 캡처 없음 (이체 1원은 인증이 생략됨)
- [ ] A2: 과제1·2 플로우 화면들 (간편홈은 경로가 다를 수 있음)
- [ ] C: 엔진 재설계 산출물을 화면으로 구현 (과제 2개분)
- [ ] 실험폰 PWA/전체화면(시스템 UI 숨김) 세팅
