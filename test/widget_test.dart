// 더미 앱 기본 스모크 테스트.

import 'package:flutter_test/flutter_test.dart';

import 'package:senior_ui_dummy_app/main.dart';

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
}
