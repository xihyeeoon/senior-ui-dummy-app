# 고령자 UI 연구 — 실험용 더미 앱 (Flutter)

HCI 석사 연구 *"고령자 친화 모바일 UI 재설계 자동화 도구"*의 **평가용 클릭 프로토타입**입니다.
진단→재설계 **엔진(도구)** 코드는 별도 저장소에 있으며, 이 repo는 그와 독립적입니다.

## 역할 (연구 계획 v6)

인터뷰·평가에서 참가자에게 보여줄 **클릭 가능한 화면**. 실거래·실제 금융정보는 넣지 않습니다(**실금융정보 0**).
대상 앱 = **신한 SOL뱅킹**. 평가는 **과제 기반 자유 탐색**(참가자에게 과제만 주고 스스로 수행).

### 조건

- **A1 (원본 재현)** — 신한 SOL뱅킹 **일반 홈**을 충실히 재현한 baseline. 개인·금융정보는 더미로 치환.
- **A2 (배포 고령자 모드)** — 앱에 실제 배포된 **쉬운홈**(고령자 모드) 재현. 별도 홈이지만 세부 태스크 화면은 A1과 공유.
- **C (도구 재설계)** — 엔진이 생성한 재설계안 프로토타입 (미구현·플레이스홀더).

### 과제 (플로우) 2개

| | 과제 | 조건 | 경로 | 상태 |
|---|---|---|---|---|
| 1 | **공과금 납부** | A1 / C | 메뉴 → 은행 › 세금/공과금 › 납부하기 → 고지서 촬영 → 납부정보 → 계좌 비밀번호 → 납부완료 | **전 구간 재현** |
| 2 | **이체** | A1 / A2 / C | 홈 [이체]/[돈보내기] 또는 메뉴 › 계좌이체 → 계좌번호 직접입력 → 은행 선택 → 금액 → 확인 → 비밀번호 → 완료 | **전 구간 재현** |

> 재현은 **실제 캡처가 있을 때만** 합니다. 근거·의도적 차이·미확인 항목은 [`docs/fidelity.md`](docs/fidelity.md) 참고.

### 이체 과제 정답 판정

- **정답 = 신한은행 + 계좌 `110234567890`**. 판정 시점은 각기 다름:
  - 계좌번호 자체 오답 → 진입 [다음]에서 **ELB00016** 팝업(즉시 차단)
  - 계좌는 맞고 은행 오답 → 확인 [보내기]에서 **ETA00325** 팝업
- **백도어**: 계좌번호를 `0` 한 글자로 입력하면 은행 무관 통과(실험자 편의). 단 은행 선택 자체는 필수.
- 규칙은 `lib/data/sh_dummy.dart`의 `checkTransfer` / `isAccountValid` 한 곳에 정의.

## 기술 스택

- **Flutter (네이티브)** — 지도교수 방침. 실험폰(안드로이드)에 실제 앱으로 설치해 평가.
- 개발 중 미리보기는 Chrome(웹)으로 가능(안드로이드 SDK 없이도).
- 은행/증권사/공과금/헤더 아이콘은 실제 캡처를 누끼 처리해 `assets/`에 번들(비상업 학술 재현).

## 구조

```
lib/
├─ main.dart                      # 앱 진입 + 조건(A1/A2/C) 선택 랜딩(개발용)
├─ data/
│  ├─ sh_dummy.dart               # 더미 이름·계좌·잔액 + 이체 정답/공과금 더미
│  ├─ sh_menu_data.dart           # 전체메뉴 7개 카테고리·섹션·항목
│  └─ sh_bank_data.dart           # 은행 38 / 증권사 29 목록
├─ theme/
│  └─ sh_theme.dart               # ShColors·ShPalette 색/타이포 토큰
├─ util/
│  └─ hangul.dart                 # 자모 분해 검색 키(jamoKey)
├─ widgets/
│  ├─ sh_common.dart              # ShAppBar/DevBar/StatusBar, OutOfScope,
│  │                              #   ShBankMark(실로고), 오류 팝업, popToConditionHome
│  ├─ sh_bank_sheet.dart          # 은행/증권사 선택 바텀시트
│  ├─ sh_number_keypad.dart       # 일반 숫자 키패드(배열 고정) — 금액·계좌번호
│  └─ sh_security_keypad.dart     # 보안 키패드(숫자 섞임) — 계좌 비밀번호(신한 파란형)
└─ screens/
   # --- 신한 (현행) ---
   ├─ a1_home.dart                # A1 · 신한 일반 홈
   ├─ a2_home.dart                # A2 · 신한 쉬운홈(고령자 모드)
   ├─ sh_menu.dart                # 전체메뉴 (A1·A2 공유, 스크롤 스파이)
   ├─ sh_menu_search.dart         # 전체메뉴 검색 (앱 동작 재현·자모 검색)
   ├─ a1_bill_home.dart           # 과제1 · 세금/공과금 메인
   ├─ a1_bill_pay_camera.dart     # 과제1 · 고지서 촬영(카메라 모크)
   ├─ a1_bill_pay_info.dart       # 과제1 · 납부정보
   ├─ a1_bill_pay_password.dart   # 과제1 · 계좌 비밀번호
   ├─ a1_bill_pay_done.dart       # 과제1 · 납부완료
   ├─ a1_transfer_entry.dart      # 과제2 · 누구에게 보낼까요?(계좌 목록 공란)
   ├─ a1_transfer_account.dart    # 과제2 · 계좌번호 직접입력 + 은행 선택
   ├─ a1_transfer_amount.dart     # 과제2 · 금액 입력
   ├─ a1_transfer_confirm.dart    # 과제2 · 확인(아래 계좌로 N원)
   ├─ a1_transfer_password.dart   # 과제2 · 계좌 비밀번호
   ├─ a1_transfer_done.dart       # 과제2 · 이체 완료
   # --- KB (휴면 · 히스토리 보존) ---
   ├─ a1_kb_home.dart, a2_kb_home.dart, a1_menu.dart,
   └─ a1_bill_main.dart, a1_bill_input.dart
assets/
├─ bank_logos/                    # 은행 b0~b37 / 증권사 s0~s28 (ASCII 파일명)
├─ bill_icons/                    # 공과금 항목 c1~c18
└─ home_icons/                    # 홈 헤더 h1~h4 (메시지·지갑·알림·메뉴)
docs/
├─ fidelity.md                    # A1 ↔ 실제 신한 충실도 대조표
└─ screenshots/                   # 근거 캡처 (커밋 제외, 로컬 보관)
test/
└─ widget_test.dart               # 화면 전환·과제 경로·정답 판정 검증 (27개)
```

> KB 화면(`*_kb_*`, `a1_menu`, `a1_bill_main/input`)은 신한 전환 전 자산으로 **휴면 보존**(랜딩에서 진입 안 함, 테스트로만 직접 검증). 확장성 데모(RQ3)에 재활용 가능.

## 실행

```powershell
# 웹(Chrome) 미리보기 — 안드로이드 SDK 불필요. 에셋 추가 시 재시작 필요.
flutter run -d chrome

# 실험폰(안드로이드)에 설치 — Android SDK 세팅 + USB 디버깅 필요
flutter run -d <device_id>     # flutter devices 로 id 확인
flutter build apk              # APK로 빌드해 설치도 가능

# 검증
flutter analyze
flutter test
```

> 실험폰 배포 전 `flutter doctor` 에서 `[√] Android toolchain` 확인 필요
> (Android Studio SDK Manager로 SDK 설치 후 `flutter doctor --android-licenses`).

## 상태 / 다음 단계

- [x] 신한 전환 (KB→신한, `Sh*` 네이밍, KB 화면 휴면 보존)
- [x] A1 일반 홈 · A2 쉬운홈 · 전체메뉴(+검색) 재현
- [x] 과제2 이체: 계좌 직접입력 → … → 완료 + 정답/오류(ETA00325·ELB00016) 판정
- [x] 과제1 공과금: 촬영 → 납부정보 → 비밀번호 → 완료
- [x] 은행/증권사/공과금/헤더 실제 아이콘 적용, 자산 카드 신한 로고
- [ ] A2 쉬운홈 '공과금 내기' 연결 여부 (v6 §4.2: 공과금=A1/C — 확인 필요)
- [ ] 공과금 '조회하기'·개별 항목 상세 (캡처 대기)
- [ ] C: 엔진 재설계 산출물을 화면으로 구현 (과제 2개분)
- [ ] 실험폰 전체화면(시스템 UI 숨김) 세팅
