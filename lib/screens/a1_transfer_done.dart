import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';

/// 신한 이체 ⑤: 완료 ("…님 계좌로 N원 보냈어요.")
/// 근거: docs/screenshots/04_이체/…_05.png
///
/// 파란 체크 + 문구 + [추가이체]/[상세보기] + 하단 [공유]/[확인].
/// [확인] → 홈으로 복귀(popUntil first).
class A1TransferDone extends StatelessWidget {
  final ShPayee payee;
  final int amount;
  const A1TransferDone({super.key, required this.payee, required this.amount});

  static String _comma(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '이체 · 신한 완료 · 더미'),
          const ShStatusBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: const BoxDecoration(
                      color: ShPalette.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 52, color: Colors.white),
                ),
                const SizedBox(height: 28),
                _message(),
                const SizedBox(height: 34),
                _actions(context),
              ],
            ),
          ),
          _bottomBar(context),
        ],
      ),
    );
  }

  Widget _message() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: ShColors.dark,
            height: 1.35),
        children: [
          TextSpan(text: '${payee.name}님 계좌로\n'),
          TextSpan(text: '${_comma(amount)}원 보냈어요.'),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    Widget pill(String label) => OutOfScope(
          label: label,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pill('추가이체'),
        const SizedBox(width: 14),
        pill('상세보기'),
      ],
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          OutOfScope(
            label: '공유',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 19),
              decoration: BoxDecoration(
                color: ShPalette.pale,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('공유',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: ShPalette.primary)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => popToConditionHome(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 19),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ShPalette.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('확인',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
