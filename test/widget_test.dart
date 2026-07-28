// 더미 앱 기본 스모크 테스트.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:senior_ui_dummy_app/data/sh_dummy.dart';
import 'package:senior_ui_dummy_app/main.dart';
import 'package:senior_ui_dummy_app/screens/a1_bill_input.dart';
import 'package:senior_ui_dummy_app/screens/a1_kb_home.dart';
import 'package:senior_ui_dummy_app/screens/a1_bill_main.dart';
import 'package:senior_ui_dummy_app/screens/a1_menu.dart';
import 'package:senior_ui_dummy_app/screens/a1_transfer_amount.dart';
import 'package:senior_ui_dummy_app/screens/a1_transfer_entry.dart';
import 'package:senior_ui_dummy_app/screens/sh_menu.dart';
import 'package:senior_ui_dummy_app/theme/sh_theme.dart';
import 'package:senior_ui_dummy_app/widgets/sh_number_keypad.dart';

/// 키패드 범위로 한정해 숫자 키를 탭한다(필드에 찍힌 숫자와의 혼동 방지).
Finder _keypadKey(String d) =>
    find.descendant(of: find.byType(ShNumberKeypad), matching: find.text(d));

/// 이체 진입 화면은 세로가 길어 기본 테스트 창(800×600)에선 드롭다운·칩이
/// 화면 밖으로 밀린다. 실제 폰 크기 창으로 렌더링해 모든 요소를 탭 가능하게 한다.
void _useTallPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('랜딩 화면에 A1/A2/C 조건이 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    expect(find.text('원본 재현 · 신한 일반 홈'), findsOneWidget);
    expect(find.text('쉬운홈(고령자 모드)'), findsOneWidget);
    expect(find.text('도구 재설계'), findsOneWidget);
  });

  testWidgets('A1 카드를 누르면 신한 일반 홈이 열린다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    await tester.tap(find.text('원본 재현 · 신한 일반 홈'));
    await tester.pumpAndSettle();

    expect(find.text('${ShDummy.myName}님'), findsOneWidget); // 헤더 (더미 이름)
    expect(find.text('자산'), findsOneWidget); // 상단 자산 카드 (이체 진입)
  });

  testWidgets('A2 카드는 신한 쉬운홈을 연다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    await tester.tap(find.text('쉬운홈(고령자 모드)'));
    await tester.pumpAndSettle();

    // 쉬운홈 고유: 이체가 '돈보내기'(쉬운 말)로 표기된다.
    expect(find.text('돈보내기'), findsOneWidget);
  });

  testWidgets('A1 홈 상단 아이콘으로 전체메뉴에 진입한다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());
    await tester.tap(find.text('원본 재현 · 신한 일반 홈'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.manage_search)); // 상단 우측 전체메뉴 아이콘(줄+돋보기)
    await tester.pumpAndSettle();

    expect(find.text('전체계좌 조회'), findsOneWidget); // 메뉴 은행 › 조회/관리
  });

  testWidgets('A2 쉬운홈 상단 메뉴 아이콘으로 전체메뉴에 진입한다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());
    await tester.tap(find.text('쉬운홈(고령자 모드)'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.manage_search));
    await tester.pumpAndSettle();

    expect(find.text('전체계좌 조회'), findsOneWidget); // 동일 공유 메뉴
  });

  // 메뉴는 A1·A2 공유. 진입 직후 은행 탭 상단(조회/관리)이 보인다.
  testWidgets('신한 메뉴: 대분류 탭과 은행 조회/관리가 보인다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShMenu()));
    await tester.pumpAndSettle();

    expect(find.text('은행'), findsWidgets); // 탭 + 카테고리 제목
    expect(find.text('전체계좌 조회'), findsOneWidget); // 은행 › 조회/관리 첫 항목
    // 과제 경로 소분류가 존재
    expect(find.text('이체'), findsWidgets);
    expect(find.text('세금/공과금'), findsWidgets);
  });

  testWidgets('신한 메뉴: 세금/공과금 칩으로 납부하기까지 이동한다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShMenu()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('납부하기'),
      400,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('shMenuList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('납부하기'), findsOneWidget); // 과제1 진입 항목
  });

  testWidgets('입력란을 탭하면 키패드가 열리고 숫자가 입력된다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1BillInput()));

    // 캡처 기준: 진입 직후에는 키패드가 닫혀 있다.
    expect(find.text('7'), findsNothing);

    await tester.tap(find.text('숫자 10자리'));
    await tester.pumpAndSettle();

    // 이체 금액 화면과 같은 일반 키패드(배열 고정 · '00' 키 포함)
    expect(find.text('7'), findsOneWidget);
    expect(find.text('00'), findsOneWidget);

    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('7'));
    await tester.pump();

    expect(find.text('37'), findsOneWidget); // 입력 표시란
  });

  // KB 화면은 신한 전환으로 휴면 상태(트리 잔존, 랜딩 미연결). 신한 플로우 완성 시
  // 히스토리로 보낸다. 그 전까지 KB 홈을 직접 띄워 기존 플로우 커버리지를 유지한다.
  testWidgets('[KB·휴면] 기본 홈의 메뉴 아이콘으로 전체메뉴에 진입한다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1KbHome()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('최근/My메뉴'), findsOneWidget);
    expect(find.text('상품가입/관리'), findsOneWidget);
  });

  // 연구 타당성 방어: 캡처에는 My메뉴에 [공과금 납부/조회] 칩이 있었으나
  // 이는 캡처 기기의 개인화 상태였다. 그대로 두면 메뉴 진입 즉시 1탭으로
  // 과제가 끝나 A1의 탐색 비용(=baseline 난이도)이 사라진다.
  testWidgets('메뉴 최상단에 공과금 바로가기가 없다 (탐색 비용 유지)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1Menu()));
    await tester.pumpAndSettle();

    expect(find.text('최근/My메뉴'), findsOneWidget);
    // 진입 직후 화면에서는 공과금으로 가는 지름길이 노출되지 않아야 한다.
    expect(find.text('공과금 납부/조회'), findsNothing);
  });

  testWidgets('공과금 섹션의 공과금 납부/조회로 공과금 메인에 진입한다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1Menu()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('공과금 납부/조회'),
      400,
      // ListView 안의 그리드도 Scrollable이므로 최상위 하나만 지목한다.
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('menuList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('공과금 납부/조회'));
    await tester.pumpAndSettle();

    expect(find.text('납부하기'), findsOneWidget); // 공과금 메인 탭
    // 캡처의 실명은 더미로 치환되어 있어야 한다 (연구 원칙: 실거래·실제 금융정보 0).
    expect(find.text('홍길동님, 납부할 세금을 확인해보세요'), findsOneWidget);
  });

  testWidgets('생활공과금 전기/TV로 전자납부번호 입력 화면에 진입한다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1BillMain()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('전기/TV'),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('billMainList')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('전기/TV'));
    await tester.pumpAndSettle();

    expect(find.text('전기요금/TV수신료 납부'), findsOneWidget);
    expect(find.text('숫자 10자리'), findsOneWidget);
  });

  // 캡처 기준: [조회]는 10자리를 다 채우기 전에는 비활성(회색)이다.
  testWidgets('전자납부번호 10자리를 채워야 조회가 활성화된다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1BillInput()));

    await tester.tap(find.text('숫자 10자리'));
    await tester.pumpAndSettle();

    // 0~9를 순서대로 누른다. 같은 숫자를 반복하면 입력값 표시("1")와
    // 키패드 키("1")가 함께 잡혀 finder가 모호해지므로 서로 다른 숫자를 쓴다.
    for (var i = 0; i < 9; i++) {
      await tester.tap(find.text('$i'));
      await tester.pump();
    }
    expect(_queryButtonColor(tester), const Color(0xFFE4E7EB)); // 9자리 → 비활성

    await tester.tap(find.text('9'));
    await tester.pump();
    expect(_queryButtonColor(tester), ShColors.yellow); // 10자리 → 활성
  });

  // ---- 과제 2: 이체 ----

  testWidgets('[KB·휴면] 기본 홈의 이체 버튼으로 이체 진입에 들어간다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1KbHome()));
    await tester.pumpAndSettle();

    // 계좌 카드의 [이체]는 기본 화면 크기에서 접혀 있을 수 있다.
    await tester.ensureVisible(find.text('이체'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('이체'));
    await tester.pumpAndSettle();

    expect(find.text('누구에게 보낼까요?'), findsOneWidget);
  });

  testWidgets('이체 전체 플로우: 계좌입력 → 은행선택 → 금액 → 보내기 → 비밀번호 → 완료',
      (WidgetTester tester) async {
    _useTallPhone(tester);
    await tester.pumpWidget(const MaterialApp(home: A1TransferEntry()));
    await tester.pumpAndSettle();

    // 1. 계좌번호 직접 입력 — '110' 입력 시 신한 추천 칩이 뜬다
    await tester.tap(_keypadKey('1'));
    await tester.tap(_keypadKey('1'));
    await tester.tap(_keypadKey('0'));
    await tester.pump();
    expect(find.text('신한'), findsWidgets);

    // 2. 신한 칩으로 은행 선택 → [다음]
    await tester.tap(find.text('신한').first);
    await tester.pump();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    // 3. 금액 입력 — 시작은 '얼마를 보낼까요?' 플레이스홀더
    expect(find.text('얼마를 보낼까요?'), findsOneWidget);
    await tester.tap(_keypadKey('1'));
    await tester.pump();
    expect(find.text('1원'), findsOneWidget);

    // 3. [다음] → 확인 화면 (질문 문구는 RichText)
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.textContaining('보낼까요?', findRichText: true), findsOneWidget);
    expect(find.text('수수료 무료'), findsOneWidget);

    // 4. [보내기] → 계좌 비밀번호
    await tester.tap(find.text('보내기'));
    await tester.pumpAndSettle();
    expect(find.text('계좌 비밀번호'), findsOneWidget);

    // 5. 4자리 입력 → 완료 (파란 키패드에 0~9 모두 존재)
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('7'));
      await tester.pump();
    }
    await tester.pumpAndSettle(); // 완료 화면 전환(지연 타이머 소진)
    expect(find.textContaining('보냈어요', findRichText: true), findsOneWidget);
  });

  // 요구사항: 계좌·은행이 모두 있어야 [다음]이 활성된다. 은행/증권사 시트로 선택.
  testWidgets('이체 진입: 계좌·은행 모두 채워야 다음이 활성된다',
      (WidgetTester tester) async {
    _useTallPhone(tester);
    await tester.pumpWidget(const MaterialApp(home: A1TransferEntry()));
    await tester.pumpAndSettle();

    // 아무것도 없으면 다음을 눌러도 진행하지 않는다.
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.text('누구에게 보낼까요?'), findsOneWidget);

    // 은행/증권사 시트 열기 → 두 탭과 증권사 목록 확인
    await tester.tap(find.text('은행 또는 증권사 선택').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('증권사'));
    await tester.pumpAndSettle();
    expect(find.text('신한투자증권'), findsOneWidget);

    // 은행 탭에서 신한 선택 → 시트 닫힘
    await tester.tap(find.text('은행'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('신한'));
    await tester.pumpAndSettle();

    // 계좌 한 자리 입력 후 다음 → 금액 화면으로 진행
    await tester.tap(_keypadKey('1'));
    await tester.pump();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.text('얼마를 보낼까요?'), findsOneWidget);
  });

  // 캡처 기준: 금액이 0원이면 [다음]이 비활성이라 확인으로 못 넘어간다.
  testWidgets('금액이 0원이면 다음이 비활성이다', (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: A1TransferAmount(payee: ShDummy.taskPayee)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    // 확인 화면으로 넘어가지 않았다 — 여전히 금액 화면.
    expect(find.text('수수료 무료'), findsNothing);
    expect(find.text('얼마를 보낼까요?'), findsOneWidget);
  });

  // 더미 원칙: 출금가능금액(잔액)을 넘는 금액은 입력되지 않는다.
  testWidgets('출금가능금액을 넘는 금액은 입력되지 않는다',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: A1TransferAmount(payee: ShDummy.taskPayee)));
    await tester.pumpAndSettle();

    // 금액 표시와 출금가능금액 라인 둘 다 1,000,000원이 된다.
    await tester.tap(find.text('전액'));
    await tester.pump();
    expect(find.text('1,000,000원'), findsNWidgets(2)); // ShDummy.balance

    // 여기서 숫자를 더 눌러도 잔액을 넘으므로 무시된다.
    await tester.tap(find.text('9'));
    await tester.pump();
    expect(find.text('1,000,000원'), findsNWidgets(2));
  });
}

/// [조회] 버튼의 현재 배경색.
Color? _queryButtonColor(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.ancestor(of: find.text('조회'), matching: find.byType(Container)).first,
  );
  return (container.decoration as BoxDecoration?)?.color;
}
