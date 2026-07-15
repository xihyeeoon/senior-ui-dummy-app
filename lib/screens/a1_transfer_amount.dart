import 'package:flutter/material.dart';

import '../data/kb_dummy.dart';
import '../theme/kb_theme.dart';
import '../widgets/kb_common.dart';
import '../widgets/kb_number_keypad.dart';
import 'a1_transfer_done.dart';

/// A1 · 이체 (금액 입력 + 상세)
/// 근거: docs/screenshots/a1/transfer/기본_이체(2~4).png
///
/// 캡처 (2)와 (3)은 별도 화면이 아니라 **같은 화면의 키패드 열림/닫힘 상태**다.
///  - 키패드 열림(2): 받는 사람 + 금액 + 키패드
///  - 키패드 닫힘(3): 출금계좌 바 + 통장 표시 + [다음]
/// (4)는 [다음]을 눌렀을 때 뜨는 확인 바텀시트.
///
/// 금액·계좌·이름은 전부 더미([KbDummy]).
class A1TransferAmount extends StatefulWidget {
  const A1TransferAmount({super.key});

  @override
  State<A1TransferAmount> createState() => _A1TransferAmountState();
}

class _A1TransferAmountState extends State<A1TransferAmount> {
  int _amount = 0;
  bool _keypadOpen = true;

  bool get _canConfirm => _amount > 0;

  void _onDigit(String d) {
    // '00' 키 지원. 자릿수는 출금가능금액을 넘지 않는 선에서만 늘린다.
    final next = int.tryParse('$_amount$d');
    if (next == null || next > KbDummy.balance) return;
    setState(() => _amount = next);
  }

  void _onDelete() => setState(() => _amount = _amount ~/ 10);

  void _onQuick(String label) {
    setState(() {
      switch (label) {
        case '전액':
          _amount = KbDummy.balance;
        case '100만':
          _amount = _clamp(_amount + 1000000);
        case '10만':
          _amount = _clamp(_amount + 100000);
        case '5만':
          _amount = _clamp(_amount + 50000);
        case '1만':
          _amount = _clamp(_amount + 10000);
      }
    });
  }

  int _clamp(int v) => v > KbDummy.balance ? KbDummy.balance : v;

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
          const KbDevBar(label: 'A1 · 이체 금액 · 더미'),
          const KbStatusBar(),
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_keypadOpen) _withdrawBar(),
                  _payee(),
                  const SizedBox(height: 40),
                  _amountText(),
                  const SizedBox(height: 40),
                  if (!_keypadOpen) ...[
                    _memoField('받는 분 통장 표시', KbDummy.myName),
                    const SizedBox(height: 26),
                    _memoField('내 통장 표시', KbDummy.payeeName),
                    const SizedBox(height: 18),
                    _extraInfo(),
                    const SizedBox(height: 26),
                    _fraudLink(),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          if (_keypadOpen)
            KbNumberKeypad(
              onDigit: _onDigit,
              onDelete: _onDelete,
              quickAmounts: const ['전액', '100만', '10만', '5만', '1만'],
              onQuickAmount: _onQuick,
              confirmLabel: '확인',
              onConfirm:
                  _canConfirm ? () => setState(() => _keypadOpen = false) : null,
            )
          else
            _nextButton(),
        ],
      ),
    );
  }

  // ---- 이체 / 취소 ----
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('이체', style: TextStyle(fontSize: 21)),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Text('취소',
                style: TextStyle(fontSize: 21, color: Color(0xFF8A8A8F))),
          ),
        ],
      ),
    );
  }

  // ---- 출금계좌 | KB국민 000000-00-000000 ----
  Widget _withdrawBar() {
    return OutOfScope(
      label: '출금계좌 변경',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF2F3F5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            const Text('출금계좌',
                style: TextStyle(fontSize: 18, color: Color(0xFF8A8A8F))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('|', style: TextStyle(color: Color(0xFFCFD4DE))),
            ),
            const Expanded(
              child: Text('${KbDummy.myBank} ${KbDummy.myAccountNo}',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 26, color: Color(0xFF6A6A6F)),
          ],
        ),
      ),
    );
  }

  // ---- 받는 사람 ----
  Widget _payee() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: KbColors.dark),
                    children: [
                      TextSpan(text: KbDummy.payeeName),
                      TextSpan(
                          text: '님',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6A6A6F))),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                        '${KbDummy.payeeBank} ${KbDummy.payeeAccountNoPlain}',
                        style: TextStyle(fontSize: 19, color: Color(0xFF8A8A8F))),
                    if (!_keypadOpen) ...[
                      const SizedBox(width: 8),
                      OutOfScope(
                        label: '받는 계좌 변경',
                        child: const Text('변경',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF6A6A6F),
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!_keypadOpen)
            OutOfScope(
              label: '여러 건 이체',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: KbColors.line),
                ),
                child: const Text('여러 건 이체', style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }

  // ---- 금액 ----
  Widget _amountText() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _keypadOpen = true),
      child: Column(
        children: [
          Text('${_comma(_amount)}원',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: _amount == 0 ? const Color(0xFF3A3A3E) : KbColors.dark,
              )),
          const SizedBox(height: 8),
          Text('출금가능금액 ${_comma(KbDummy.balance)} 원',
              style: const TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
        ],
      ),
    );
  }

  // ---- 받는 분 / 내 통장 표시 ----
  Widget _memoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 19, color: Color(0xFF6A6A6F))),
          const SizedBox(height: 8),
          OutOfScope(
            label: label,
            child: Row(
              children: [
                Expanded(
                  child: Text(value,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.w700)),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    size: 26, color: Color(0xFF6A6A6F)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1.4, color: const Color(0xFF8B7A55)),
        ],
      ),
    );
  }

  Widget _extraInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutOfScope(
            label: '추가정보 입력',
            child: Row(
              children: const [
                Icon(Icons.add_circle_outline, size: 24, color: Color(0xFF6A6A6F)),
                SizedBox(width: 8),
                Text('추가정보 입력', style: TextStyle(fontSize: 19)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fraudLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutOfScope(
        label: '사기의심계좌 조회',
        child: Row(
          children: const [
            Icon(Icons.notifications_none, size: 22, color: Color(0xFF6A6A6F)),
            SizedBox(width: 8),
            Text('사기의심계좌인지 조회할 수 있어요',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4A4A4F),
                  decoration: TextDecoration.underline,
                )),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showConfirmSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        color: KbColors.yellow,
        child: const Text('다음',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
    );
  }

  // ---- 확인 바텀시트 (캡처 4) ----
  void _showConfirmSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(sheetContext).pop(),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(20, 18, 20, 4),
                  child: Icon(Icons.close, size: 28, color: Color(0xFF8A8A8F)),
                ),
              ),
            ),
            _bankFlow(),
            const SizedBox(height: 18),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w700, color: KbColors.dark),
                children: [
                  TextSpan(text: '${KbDummy.payeeName} 님께\n'),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w700, color: KbColors.dark),
                children: [
                  TextSpan(text: _comma(_amount)),
                  const TextSpan(
                      text: ' 원을 이체합니다.',
                      style: TextStyle(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
                '${KbDummy.payeeBankFull}  ${KbDummy.payeeAccountNo}',
                style: TextStyle(fontSize: 18, color: Color(0xFF8A8A8F))),
            const SizedBox(height: 22),
            const Divider(height: 1, color: Color(0xFFEDEEF1), indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutOfScope(
                    label: '이체 상세정보',
                    child: Row(
                      children: const [
                        Text('이체 상세정보',
                            style: TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            size: 24, color: Color(0xFF9A9EA6)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(sheetContext).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => A1TransferDone(amount: _amount)),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                color: KbColors.yellow,
                child: const Text('이체',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// KB ▶▶▶ 신한
  Widget _bankFlow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Color(0xFF6B5B4A), shape: BoxShape.circle),
          child: const Text('★',
              style: TextStyle(
                  color: KbColors.yellow, fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('▸▸▸',
              style: TextStyle(fontSize: 16, color: Color(0xFFCFD4DE))),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Color(0xFF0046FF), shape: BoxShape.circle),
          child: const Text('신한',
              style: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
