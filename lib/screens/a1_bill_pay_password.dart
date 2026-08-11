import 'package:flutter/material.dart';

import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import '../widgets/sh_security_keypad.dart';
import 'a1_bill_pay_done.dart';

/// 공과금 납부 ③: 계좌 비밀번호 (4자리)
/// 근거: docs/screenshots/03_공과금납부/납부하기/4·5.png
///
/// 이체와 동일한 파란 보안 키패드. 4자리를 채우면 납부완료로 이동.
/// 실제 검증은 없다(더미) — 어떤 4자리든 통과.
class A1BillPayPassword extends StatefulWidget {
  const A1BillPayPassword({super.key});

  @override
  State<A1BillPayPassword> createState() => _A1BillPayPasswordState();
}

class _A1BillPayPasswordState extends State<A1BillPayPassword> {
  int _filled = 0;

  void _onDigit(String _) {
    if (_filled >= 4) return;
    setState(() => _filled++);
    if (_filled == 4) {
      Future<void>.delayed(const Duration(milliseconds: 180), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const A1BillPayDone()),
        );
      });
    }
  }

  void _onDelete() {
    if (_filled == 0) return;
    setState(() => _filled--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '공과금 · 계좌 비밀번호 · 더미'),
          const ShStatusBar(),
          _topBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('계좌 비밀번호',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                const SizedBox(height: 34),
                _dots(),
              ],
            ),
          ),
          ShSecurityKeypad.shinhan(onDigit: _onDigit, onDelete: _onDelete),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 16, 6),
      child: Row(
        children: [
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.close, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < _filled ? ShPalette.primary : Colors.transparent,
              border: Border.all(
                color: i < _filled ? ShPalette.primary : const Color(0xFFB8BDC7),
                width: 2,
              ),
            ),
          ),
      ],
    );
  }
}
