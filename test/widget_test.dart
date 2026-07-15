// 더미 앱 기본 스모크 테스트.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:senior_ui_dummy_app/main.dart';
import 'package:senior_ui_dummy_app/screens/a1_bill_input.dart';

void main() {
  testWidgets('랜딩 화면에 A1/A2/C 조건이 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    expect(find.text('원본 재현'), findsOneWidget);
    expect(find.text('배포 고령자 모드'), findsOneWidget);
    expect(find.text('도구 재설계'), findsOneWidget);
  });

  testWidgets('A1 카드를 누르면 KB 홈이 열린다', (WidgetTester tester) async {
    await tester.pumpWidget(const DummyApp());

    await tester.tap(find.text('원본 재현'));
    await tester.pumpAndSettle();

    expect(find.text('KB마이핏통장'), findsOneWidget);
    expect(find.text('홍길동님'), findsOneWidget);
  });

  testWidgets('보안 키패드로 숫자를 입력하면 표시된다', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: A1BillInput()));

    // 키패드가 렌더된다 (재배열/삭제 키)
    expect(find.text('재배열'), findsOneWidget);
    expect(find.text('삭제'), findsOneWidget);

    // 숫자는 섞여 있어도 각 숫자는 정확히 하나씩 → 텍스트로 탭 가능
    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('7'));
    await tester.pump();

    expect(find.text('37'), findsOneWidget); // 입력 표시란
  });
}
