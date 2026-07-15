// 더미 앱 기본 스모크 테스트.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:senior_ui_dummy_app/data/kb_dummy.dart';
import 'package:senior_ui_dummy_app/main.dart';
import 'package:senior_ui_dummy_app/screens/a1_bill_input.dart';
import 'package:senior_ui_dummy_app/screens/a1_bill_main.dart';
import 'package:senior_ui_dummy_app/screens/a1_menu.dart';
import 'package:senior_ui_dummy_app/screens/a1_transfer_amount.dart';
import 'package:senior_ui_dummy_app/screens/a1_transfer_entry.dart';
import 'package:senior_ui_dummy_app/theme/kb_theme.dart';

void main() {
  testWidgets('랜딩 화면에 A1/A2/C 조건이 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    expect(find.text('원본 재현 · 기본 홈'), findsOneWidget);
    expect(find.text('간편홈(단순화 모드)'), findsOneWidget);
    expect(find.text('도구 재설계'), findsOneWidget);
  });

  testWidgets('A1 카드를 누르면 기본 홈이 열린다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    await tester.tap(find.text('원본 재현 · 기본 홈'));
    await tester.pumpAndSettle();

    expect(find.text('홍길동님'), findsOneWidget); // 기본 홈 헤더
    expect(find.text('KB마이핏통장'), findsOneWidget); // 계좌 캐러셀 첫 카드
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

  testWidgets('기본 홈의 메뉴 아이콘으로 전체메뉴에 진입한다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());
    await tester.tap(find.text('원본 재현 · 기본 홈'));
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
    expect(_queryButtonColor(tester), KbColors.yellow); // 10자리 → 활성
  });

  // ---- 과제 2: 이체 ----

  testWidgets('기본 홈의 이체 버튼으로 이체 진입에 들어간다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());
    await tester.tap(find.text('원본 재현 · 기본 홈'));
    await tester.pumpAndSettle();

    // 계좌 카드의 [이체]는 기본 화면 크기에서 접혀 있을 수 있다.
    await tester.ensureVisible(find.text('이체'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('이체'));
    await tester.pumpAndSettle();

    expect(find.text('누구에게 보낼까요?'), findsOneWidget);
  });

  testWidgets('이체 전체 플로우: 상대 선택 → 금액 → 다음 → 이체 → 완료',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1TransferEntry()));
    await tester.pumpAndSettle();

    // 1. 최근 목록에서 받는 사람 선택
    await tester.tap(find.text(KbDummy.payeeName));
    await tester.pumpAndSettle();

    // 2. 금액 입력 (키패드 열린 상태로 시작)
    expect(find.text('0원'), findsOneWidget);
    await tester.tap(find.text('1'));
    await tester.pump();
    expect(find.text('1원'), findsOneWidget);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    // 3. 키패드가 닫히면 상세 폼이 드러난다
    expect(find.text('받는 분 통장 표시'), findsOneWidget);
    expect(find.text('출금계좌'), findsOneWidget);

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    // 4. 확인 바텀시트 — 금액만 볼드라 RichText다. find.text는 기본적으로
    //    RichText를 보지 않으므로 findRichText를 켠다.
    expect(find.textContaining('원을 이체합니다', findRichText: true),
        findsOneWidget);

    // 상단 라벨과 시트 버튼 둘 다 '이체'라 마지막(시트 버튼)을 누른다.
    await tester.tap(find.text('이체').last);
    await tester.pumpAndSettle();

    // 5. 완료
    expect(find.text('이체가 완료되었습니다.'), findsOneWidget);
  });

  // 캡처 기준: 금액이 0원이면 [확인]이 비활성이라 다음으로 못 넘어간다.
  testWidgets('금액이 0원이면 확인이 비활성이다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1TransferAmount()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    // 여전히 키패드 화면 — 상세 폼으로 넘어가지 않았다.
    expect(find.text('받는 분 통장 표시'), findsNothing);
  });

  // 더미 원칙: 출금가능금액(잔액)을 넘는 금액은 입력되지 않는다.
  testWidgets('출금가능금액을 넘는 금액은 입력되지 않는다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1TransferAmount()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('전액'));
    await tester.pump();
    expect(find.text('12,500원'), findsOneWidget); // KbDummy.balance

    // 여기서 숫자를 더 누르면 잔액을 넘으므로 무시된다.
    await tester.tap(find.text('9'));
    await tester.pump();
    expect(find.text('12,500원'), findsOneWidget);
  });
}

/// [조회] 버튼의 현재 배경색.
Color? _queryButtonColor(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.ancestor(of: find.text('조회'), matching: find.byType(Container)).first,
  );
  return (container.decoration as BoxDecoration?)?.color;
}
