import 'package:flutter/material.dart';

import '../data/kb_dummy.dart';
import '../theme/kb_theme.dart';
import '../widgets/kb_common.dart';

/// A1 · 이체 완료
/// 근거: docs/screenshots/a1/transfer/기본_이체(5).png
///
/// [원본과 다른 점] 실제 화면 상단에는 곰 캐릭터 + ₩ 코인 일러스트가 있다.
/// 저작권 자산이라 더미에서는 동일 위치·크기의 원형 아이콘으로 대체한다.
/// 레이아웃·문구·버튼 구성은 캡처 그대로.
class A1TransferDone extends StatelessWidget {
  final int amount;
  const A1TransferDone({super.key, required this.amount});

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
          const KbDevBar(label: 'A1 · 이체 완료 · 더미'),
          const KbStatusBar(),
          _topBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 30),
                _illust(),
                const SizedBox(height: 22),
                _message(),
                const SizedBox(height: 22),
                _accountPill(context),
                const SizedBox(height: 22),
                _shareRow(context),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFEDEEF1)),
                _detailToggle(context),
                const SizedBox(height: 8),
                _actions(context),
                const SizedBox(height: 18),
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
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
      child: Row(
        children: [
          const Expanded(child: Text('이체', style: TextStyle(fontSize: 21))),
          OutOfScope(
            label: '홈',
            child: const Icon(Icons.home_outlined, size: 27, color: KbColors.dark),
          ),
          const SizedBox(width: 16),
          OutOfScope(
            label: '메뉴',
            child: const Icon(Icons.menu, size: 27, color: KbColors.dark),
          ),
        ],
      ),
    );
  }

  /// 원본의 곰 + 코인 일러스트 자리.
  Widget _illust() {
    return Center(
      child: SizedBox(
        width: 150,
        height: 110,
        child: Stack(
          children: [
            Positioned(
              left: 22,
              top: 18,
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                    color: Color(0xFFA98A72), shape: BoxShape.circle),
                child: const Icon(Icons.savings, size: 36, color: Colors.white),
              ),
            ),
            Positioned(
              right: 6,
              top: 0,
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: KbColors.yellow, shape: BoxShape.circle),
                child: const Text('₩',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _message() {
    return Column(
      children: [
        const Text('${KbDummy.payeeName} 님께',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('${_comma(amount)} 원',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text('이체가 완료되었습니다.', style: TextStyle(fontSize: 24)),
      ],
    );
  }

  Widget _accountPill(BuildContext context) {
    return Center(
      child: OutOfScope(
        label: '받는 계좌 즐겨찾기',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: KbColors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(KbDummy.payeeBankFull,
                  style: TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
              SizedBox(width: 10),
              Text(KbDummy.payeeAccountNo, style: TextStyle(fontSize: 19)),
              SizedBox(width: 8),
              Icon(Icons.star_border, size: 22, color: Color(0xFF9A9EA6)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shareRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutOfScope(
          label: '메시지카드',
          child: Row(
            children: const [
              Icon(Icons.mail_outline, size: 24, color: Color(0xFF4A4A4F)),
              SizedBox(width: 8),
              Text('메시지카드', style: TextStyle(fontSize: 19)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('|', style: TextStyle(color: Color(0xFFCFD4DE))),
        ),
        OutOfScope(
          label: '공유하기',
          child: Row(
            children: const [
              Icon(Icons.share_outlined, size: 24, color: Color(0xFF4A4A4F)),
              SizedBox(width: 8),
              Text('공유하기', style: TextStyle(fontSize: 19)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
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
                Icon(Icons.keyboard_arrow_down, size: 24, color: Color(0xFF9A9EA6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    Widget btn(String label) => Expanded(
          child: OutOfScope(
            label: label,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 17),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: KbColors.line),
              ),
              child: Text(label, style: const TextStyle(fontSize: 19)),
            ),
          ),
        );
    return Row(
      children: [
        btn('추가이체'),
        const SizedBox(width: 12),
        btn('거래내역조회'),
      ],
    );
  }

  Widget _notice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Color(0xFF9A9EA6), shape: BoxShape.circle),
          child: const Text('!',
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('다른 은행 계좌로 이체 시 입금 은행의 사정에 따라 해당 계좌의 입금이 다소 지연될 수 있습니다.',
              style: TextStyle(fontSize: 17, height: 1.45, color: Color(0xFF4A4A4F))),
        ),
      ],
    );
  }

  /// 실험 흐름상 완료 후에는 홈으로 되돌린다.
  Widget _confirmButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        color: KbColors.yellow,
        child: const Text('확인',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
