import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import '../widgets/sh_number_keypad.dart';
import 'a1_transfer_confirm.dart';

/// 신한 이체 ②: 금액 입력 ("얼마를 보낼까요?")
/// 근거: docs/screenshots/04_이체/…_01.png
///
/// 상단 보내는·받는 계좌 요약 + 출금가능금액 + 빠른칩(+1만/+5만/+10만/전액) +
/// 숫자패드(00 포함) + [다음]. 금액·계좌는 전부 더미([ShDummy]).
class A1TransferAmount extends StatefulWidget {
  final ShPayee payee;
  const A1TransferAmount({super.key, required this.payee});

  @override
  State<A1TransferAmount> createState() => _A1TransferAmountState();
}

class _A1TransferAmountState extends State<A1TransferAmount> {
  int _amount = 0;

  bool get _canNext => _amount > 0;

  void _onDigit(String d) {
    final next = int.tryParse('$_amount$d');
    if (next == null || next > ShDummy.balance) return;
    setState(() => _amount = next);
  }

  void _onDelete() => setState(() => _amount = _amount ~/ 10);

  void _onQuick(String label) {
    setState(() {
      switch (label) {
        case '전액':
          _amount = ShDummy.balance;
        case '+10만':
          _amount = _clamp(_amount + 100000);
        case '+5만':
          _amount = _clamp(_amount + 50000);
        case '+1만':
          _amount = _clamp(_amount + 10000);
      }
    });
  }

  int _clamp(int v) => v > ShDummy.balance ? ShDummy.balance : v;

  static String _comma(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => A1TransferConfirm(payee: widget.payee, amount: _amount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '이체 · 신한 금액 입력 · 더미'),
          const ShStatusBar(),
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _summary(),
                  const SizedBox(height: 40),
                  _amountText(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          ShNumberKeypad(
            onDigit: _onDigit,
            onDelete: _onDelete,
            quickAmounts: const ['+1만', '+5만', '+10만', '전액'],
            onQuickAmount: _onQuick,
            quickPill: true,
            confirmLabel: '다음',
            confirmColor: ShPalette.primary,
            confirmTextColor: Colors.white,
            onConfirm: _canNext ? _next : null,
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 16, 6),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.arrow_back_ios_new, size: 22, color: ShColors.dark),
          ),
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

  // ---- 보내는·받는 계좌 요약 ----
  Widget _summary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutOfScope(
            label: '출금계좌 변경',
            child: Row(
              children: const [
                Flexible(
                  child: Text('${ShDummy.myAccountName} 계좌에서',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700, height: 1.3)),
                ),
                Icon(Icons.keyboard_arrow_down, size: 24, color: Color(0xFF6A6A6F)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text('${widget.payee.name}님 계좌로',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text('${widget.payee.bank} ${widget.payee.accountNo}',
              style: const TextStyle(fontSize: 17, color: Color(0xFF8A8A8F))),
        ],
      ),
    );
  }

  // ---- 금액 ----
  Widget _amountText() {
    return Column(
      children: [
        Text(
          _amount == 0 ? '얼마를 보낼까요?' : '${_comma(_amount)}원',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: _amount == 0 ? const Color(0xFFAEB2BA) : ShColors.dark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('출금가능금액 ',
                style: TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
            Text('${_comma(ShDummy.balance)}원',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3A3A3E),
                  decoration: TextDecoration.underline,
                )),
          ],
        ),
      ],
    );
  }
}
