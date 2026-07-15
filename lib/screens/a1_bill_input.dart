import 'package:flutter/material.dart';

import '../theme/kb_theme.dart';
import '../widgets/kb_common.dart';
import '../widgets/kb_security_keypad.dart';

/// A1 · 공과금 납부번호 입력 (템플릿)
/// 보안 키패드 컴포넌트를 실제로 사용하는 패턴 화면.
/// 실제 KB 입력 화면 스크린샷을 받으면 라벨·레이아웃을 정밀 재현할 예정.
class A1BillInput extends StatefulWidget {
  const A1BillInput({super.key});

  @override
  State<A1BillInput> createState() => _A1BillInputState();
}

class _A1BillInputState extends State<A1BillInput> {
  String _value = '';

  void _onDigit(String d) => setState(() => _value += d);
  void _onDelete() =>
      setState(() => _value = _value.isEmpty ? '' : _value.substring(0, _value.length - 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KbColors.bg,
      body: Column(
        children: [
          const KbDevBar(label: 'A1 · 납부번호 입력 (템플릿)'),
          const KbStatusBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text('전자납부번호를 입력하세요',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: KbColors.line),
                    ),
                    child: Text(
                      _value.isEmpty ? '납부번호' : _value,
                      style: TextStyle(
                        fontSize: 22,
                        letterSpacing: 2,
                        color: _value.isEmpty ? const Color(0xFFBFC3CC) : KbColors.dark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          KbSecurityKeypad(onDigit: _onDigit, onDelete: _onDelete),
        ],
      ),
    );
  }
}
