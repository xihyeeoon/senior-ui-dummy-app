import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';

/// 공과금 납부 ④: 납부완료
/// 근거: docs/screenshots/03_공과금납부/납부하기/6.png
///
/// 파란 체크 + 출금계좌/납부금액/납부일 + 납부정보 + 안내 + [확인].
/// [확인] → 시작한 조건 홈으로 복귀. 정보는 전부 더미([ShDummy]).
class A1BillPayDone extends StatelessWidget {
  const A1BillPayDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '공과금 · 납부완료 · 더미'),
          const ShStatusBar(),
          _topBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                        color: ShPalette.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 46, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text('납부완료',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, color: Color(0xFF3A3A3E)),
                const SizedBox(height: 8),
                _row('출금계좌', '${ShDummy.myBank} ${ShDummy.myAccountNo}',
                    valueColor: ShPalette.primary),
                _row('납부금액', ShDummy.billAmountText, valueColor: ShPalette.primary),
                _row('납부일', ShDummy.billPaidAt),
                const SizedBox(height: 6),
                const Divider(height: 1, color: Color(0xFFEDEEF1)),
                const SizedBox(height: 6),
                _row('전자납부번호(고객번호)', ShDummy.billEnoNo),
                _row('고객명', ShDummy.billCustomerName),
                _row('청구연월', ShDummy.billMonth),
                _row('고객전용지정 계좌번호', ShDummy.billDesignatedAcc),
                _row('고객주소', ShDummy.billAddress),
                const SizedBox(height: 12),
                _notice(),
              ],
            ),
          ),
          _confirmButton(context),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 16, 12),
      child: Row(
        children: [
          const Spacer(),
          OutOfScope(
            label: '고객센터',
            child: const Icon(Icons.chat_bubble_outline, size: 25, color: ShColors.dark),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => popToConditionHome(context),
            child: const Icon(Icons.home_outlined, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
          const Spacer(),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? ShColors.dark)),
          ),
        ],
      ),
    );
  }

  Widget _notice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ',
            style: TextStyle(fontSize: 17, color: Color(0xFF8A8A8F))),
        const Expanded(
          child: Text(
              "'납부 완료'가 표시되더라도 입금할 수 없는 계좌인 경우 출금계좌로 재입금됩니다.",
              style: TextStyle(fontSize: 16, height: 1.45, color: Color(0xFF6A6A6F))),
        ),
      ],
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => popToConditionHome(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 19),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ShPalette.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text('확인',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ),
    );
  }
}
