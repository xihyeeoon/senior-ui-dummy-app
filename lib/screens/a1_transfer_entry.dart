import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_bank_sheet.dart';
import '../widgets/sh_common.dart';
import '../widgets/sh_number_keypad.dart';
import 'a1_transfer_amount.dart';

/// 신한 이체 ①: 받는 사람 선택 — 계좌번호 직접 입력
/// 근거: docs/screenshots/04_이체/…_181550385(_00~_06).png
///
/// 계좌번호(- 없이 숫자만) + [은행 또는 증권사 선택] 시트 + 고정 숫자키패드.
/// '110' 입력 시 신한 등 추천 칩이 뜬다(캡처: 미래에셋증권/신한/신협).
/// 즐겨찾기·최근 목록은 사용하지 않는다(직접 입력 방식).
/// A1 일반 홈·A2 쉬운홈이 공유하는 이체 진입점.
class A1TransferEntry extends StatefulWidget {
  const A1TransferEntry({super.key});

  @override
  State<A1TransferEntry> createState() => _A1TransferEntryState();
}

class _A1TransferEntryState extends State<A1TransferEntry> {
  String _account = '';
  String? _bank;

  bool get _canNext => _account.isNotEmpty && _bank != null;

  /// '110'으로 시작하면 신한 계열 추천을 노출(캡처 재현).
  bool get _showSuggest => _account.startsWith('110');
  static const _suggestChips = ['미래에셋증권', '신한', '신협'];

  void _onDigit(String d) => setState(() => _account += d);
  void _onDelete() => setState(() {
        if (_account.isNotEmpty) _account = _account.substring(0, _account.length - 1);
      });
  void _clear() => setState(() => _account = '');

  Future<void> _pickBank() async {
    final picked = await showShBankSheet(context);
    if (picked != null) setState(() => _bank = picked);
  }

  void _next() {
    // 직접 입력값으로 상대를 구성(이름은 더미 예금주).
    final payee =
        ShPayee(name: ShDummy.taskPayee.name, bank: _bank!, accountNo: _account);
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
                  const SizedBox(height: 12),
                  _bankDropdown(),
                  if (_showSuggest) _suggestions(),
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

  // ---- 계좌번호 입력 필드 (키패드 구동, 시스템 키보드 없음) ----
  Widget _accountField() {
    final empty = _account.isEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ShPalette.primary, width: 1.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('계좌번호',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: ShPalette.primary)),
          const SizedBox(height: 6),
          Row(
            children: [
              // 파란 커서
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

  // ---- 추천 (110 입력 시) ----
  Widget _suggestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final b in _suggestChips) _chip(b),
            ],
          ),
          const SizedBox(height: 12),
          // 본인 계좌 자동완성 행(더미). 탭 시 신한 선택.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _bank = '신한'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ShBankMark('신한', size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${ShDummy.myAccountName}${ShDummy.myAccountType} $_account',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String bank) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _bank = bank),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShBankMark(bank, size: 24),
            const SizedBox(width: 8),
            Text(bank, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
