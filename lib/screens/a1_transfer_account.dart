import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_bank_sheet.dart';
import '../widgets/sh_common.dart';
import '../widgets/sh_number_keypad.dart';
import 'a1_transfer_amount.dart';

/// 신한 이체 ①-B: 계좌번호 직접 입력
/// 근거: docs/screenshots/04_이체/…_181550385, "14자 이상 입력 시".png
///
/// 계좌번호(- 없이 숫자만, 최대 14자리) + [은행 또는 증권사 선택] 시트 +
/// 고정 숫자키패드. 은행 추천 칩은 사용하지 않는다.
/// 정답 판정은 여기서 하지 않고 확인 화면 [보내기]에서 한다.
class A1TransferAccount extends StatefulWidget {
  const A1TransferAccount({super.key});

  @override
  State<A1TransferAccount> createState() => _A1TransferAccountState();
}

class _A1TransferAccountState extends State<A1TransferAccount> {
  static const _maxLen = 14;

  String _account = '';
  String? _bank;

  bool get _atMax => _account.length >= _maxLen;

  // 계좌번호 + 은행 선택이 모두 있어야 진행(은행 선택 필수).
  bool get _canNext => _account.isNotEmpty && _bank != null;

  void _onDigit(String d) {
    if (_atMax) {
      setState(() {}); // 경고 문구 갱신
      return;
    }
    setState(() => _account += d);
  }

  void _onDelete() => setState(() {
        if (_account.isNotEmpty) {
          _account = _account.substring(0, _account.length - 1);
        }
      });

  void _clear() => setState(() => _account = '');

  Future<void> _pickBank() async {
    final picked = await showShBankSheet(context);
    if (picked != null) setState(() => _bank = picked);
  }

  void _next() {
    // 계좌번호 오류(ELB00016)는 여기서 바로 막는다. 은행 오류는 확인 화면에서.
    if (!ShDummy.isAccountValid(_account)) {
      showShErrorDialog(context,
          code: 'ELB00016',
          message: '계좌번호[$_account]\n'
              '입력하신 계좌번호가 올바르지 않습니다.\n계좌번호를 확인하시기 바랍니다.');
      return;
    }
    final payee = ShPayee(
      name: ShDummy.taskPayee.name,
      bank: _bank!, // _canNext가 은행 선택을 보장
      accountNo: _account,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => A1TransferAmount(payee: payee)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '이체 · 신한 계좌번호 직접입력 · 더미'),
          const ShStatusBar(),
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Text('누구에게 보낼까요?',
                        style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
                  ),
                  _accountField(),
                  if (_atMax) _maxWarning(),
                  const SizedBox(height: 12),
                  _bankDropdown(),
                ],
              ),
            ),
          ),
          ShNumberKeypad(
            onDigit: _onDigit,
            onDelete: _onDelete,
            showDoubleZero: false,
          ),
          _nextButton(),
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
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.close, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  // ---- 계좌번호 입력 필드 (키패드 구동) ----
  Widget _accountField() {
    final empty = _account.isEmpty;
    final err = _atMax; // 최대 자리 → 빨간 강조
    final accent = err ? const Color(0xFFE0433B) : ShPalette.primary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent, width: 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('계좌번호',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: accent)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(width: 2, height: 26, color: ShPalette.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  empty ? '없이 숫자만 입력' : _account,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: empty ? const Color(0xFF9A9EA6) : ShColors.dark,
                  ),
                ),
              ),
              if (!empty)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _clear,
                  child: const Icon(Icons.cancel, size: 24, color: Color(0xFFB8BDC7)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _maxWarning() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 8, 20, 0),
      child: Row(
        children: [
          Icon(Icons.error, size: 18, color: Color(0xFFE0433B)),
          SizedBox(width: 6),
          Text('최대 14자리 입력 가능합니다.',
              style: TextStyle(fontSize: 16, color: Color(0xFFE0433B))),
        ],
      ),
    );
  }

  Widget _bankDropdown() {
    final chosen = _bank != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _pickBank,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3E5EA)),
        ),
        child: Row(
          children: [
            if (chosen) ...[
              ShBankMark(_bank!, size: 28),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                chosen ? _bank! : '은행 또는 증권사 선택',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: chosen ? FontWeight.w700 : FontWeight.w500,
                  color: chosen ? ShColors.dark : const Color(0xFF9A9EA6),
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 26, color: Color(0xFF6A6A6F)),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _canNext ? _next : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 19),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _canNext ? ShPalette.primary : const Color(0xFFEDEFF3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text('다음',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _canNext ? Colors.white : const Color(0xFF9A9EA6),
              )),
        ),
      ),
    );
  }
}
