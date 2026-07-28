import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import '../widgets/sh_security_keypad.dart';
import 'a1_transfer_done.dart';

/// 신한 이체 ④: 계좌 비밀번호 (4자리)
/// 근거: docs/screenshots/04_이체/…_03·04.png
///
/// 파란 보안 키패드(숫자 매번 뒤섞임 · 재배열). 4자리를 채우면 완료로 이동.
/// 실제 비밀번호 검증은 없다(더미) — 어떤 4자리든 통과.
class A1TransferPassword extends StatefulWidget {
  final ShPayee payee;
  final int amount;
  const A1TransferPassword({super.key, required this.payee, required this.amount});

  @override
  State<A1TransferPassword> createState() => _A1TransferPasswordState();
}

class _A1TransferPasswordState extends State<A1TransferPassword> {
  int _filled = 0;

  void _onDigit(String _) {
    if (_filled >= 4) return;
    setState(() => _filled++);
    if (_filled == 4) {
      // 입력 완료 직후 완료 화면으로.
      Future<void>.delayed(const Duration(milliseconds: 180), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                A1TransferDone(payee: widget.payee, amount: widget.amount),
          ),
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
          const ShDevBar(label: '이체 · 신한 계좌 비밀번호 · 더미'),
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
            onTap: () => popToConditionHome(context),
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
