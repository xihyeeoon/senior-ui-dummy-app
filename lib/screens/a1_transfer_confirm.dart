import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_transfer_password.dart';

/// 신한 이체 ③: 확인 ("…님 계좌로 N원 보낼까요?")
/// 근거: docs/screenshots/04_이체/…_02.png
///
/// 받는 사람 로고 + 문구 + 수수료 무료 + 보내는/받는 계좌·메모 카드 + [보내기].
/// [보내기] → 계좌 비밀번호 입력.
class A1TransferConfirm extends StatelessWidget {
  final ShPayee payee;
  final int amount;
  const A1TransferConfirm({super.key, required this.payee, required this.amount});

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
          const ShDevBar(label: '이체 · 신한 확인 · 더미'),
          const ShStatusBar(),
          _topBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 30),
                Center(child: ShBankMark(payee.bank, size: 84)),
                const SizedBox(height: 20),
                _question(),
                const SizedBox(height: 14),
                const Center(
                  child: Text('수수료 무료',
                      style: TextStyle(fontSize: 19, color: Color(0xFF8A8A8F))),
                ),
                const SizedBox(height: 30),
                _detailCard(),
              ],
            ),
          ),
          _sendButton(context),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
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

  Widget _question() {
    // 직접 입력이라 예금주명이 없어 "아래 계좌로"로 표기(캡처 기준).
    return Text('아래 계좌로\n${_comma(amount)}원 보낼까요?',
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: ShColors.dark,
            height: 1.35));
  }

  Widget _detailCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row('보내는 계좌', '${ShDummy.myBank} ${ShDummy.myAccountNo}'),
          const SizedBox(height: 16),
          _row('받는 계좌', '${payee.bank} ${payee.accountNo}'),
          const SizedBox(height: 16),
          _row('받는분 메모', payee.name, editable: true),
          const SizedBox(height: 16),
          _row('내통장 메모', payee.name, editable: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool editable = false}) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, color: Color(0xFF8A8A8F))),
        const Spacer(),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        if (editable) ...[
          const SizedBox(width: 6),
          const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF9A9EA6)),
        ],
      ],
    );
  }

  void _onSend(BuildContext context) {
    // 정답 판정은 여기서(캡처: 확인 화면 [보내기] 시 오류 팝업).
    switch (ShDummy.checkTransfer(payee.accountNo, payee.bank)) {
      case TransferCheck.ok:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => A1TransferPassword(payee: payee, amount: amount),
          ),
        );
      case TransferCheck.wrongBank:
        showShErrorDialog(context,
            code: 'ETA00325',
            message: '해당 계좌번호내 과목코드 오류입니다.\n입력하신 계좌번호를 확인해주세요.');
      case TransferCheck.wrongAccount:
        showShErrorDialog(context,
            code: 'ELB00016',
            message: '계좌번호[${payee.accountNo}]\n'
                '입력하신 계좌번호가 올바르지 않습니다.\n계좌번호를 확인하시기 바랍니다.');
    }
  }

  Widget _sendButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onSend(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        color: ShPalette.primary,
        child: const Text('보내기',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}
