import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_bill_pay_password.dart';

/// 공과금 납부 ②: 납부정보
/// 근거: docs/screenshots/03_공과금납부/납부하기/3.png
///
/// 촬영/OCR 결과로 채워진 납부정보 + 출금계좌 + [납부].
/// 캡처의 실정보(고객명·전자납부번호·계좌·주소)는 전부 더미([ShDummy]).
class A1BillPayInfo extends StatelessWidget {
  const A1BillPayInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '공과금 · 납부정보 · 더미'),
          const ShStatusBar(),
          _topBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 10),
                const Text('납부정보',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFF3A3A3E)),
                const SizedBox(height: 8),
                _row('전자납부번호(고객번호)', ShDummy.billEnoNo),
                _row('고객명', ShDummy.billCustomerName),
                _row('청구연월', ShDummy.billMonth),
                _row('고객전용지정 계좌번호', ShDummy.billDesignatedAcc),
                _row('고객주소', ShDummy.billAddress),
                _row('납부금액', ShDummy.billAmountText, valueColor: ShPalette.primary),
                const SizedBox(height: 24),
                const Text('출금계좌',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _withdrawCard(),
              ],
            ),
          ),
          _payButton(context),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.arrow_back_ios_new, size: 22, color: ShColors.dark),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(ShDummy.billTitle,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          ),
          OutOfScope(
            label: '고객센터',
            child: const Icon(Icons.chat_bubble_outline, size: 25, color: ShColors.dark),
          ),
          const SizedBox(width: 16),
          OutOfScope(
            label: '홈',
            child: const Icon(Icons.home_outlined, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
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

  Widget _withdrawCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3E5EA)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShBankMark('신한', size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${ShDummy.myAccountName}${ShDummy.myAccountType}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700, height: 1.3)),
                    const SizedBox(height: 4),
                    Text('${ShDummy.myBank} ${ShDummy.myAccountNo}',
                        style: const TextStyle(fontSize: 16, color: Color(0xFF8A8A8F))),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 26, color: Color(0xFF6A6A6F)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('출금가능금액 ',
                  style: TextStyle(fontSize: 16, color: Color(0xFF8A8A8F))),
              Text(ShDummy.billAvailableText,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _payButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const A1BillPayPassword()),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 19),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ShPalette.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text('납부',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ),
    );
  }
}
