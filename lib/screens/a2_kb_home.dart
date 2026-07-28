import 'package:flutter/material.dart';

import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';

/// A2 · KB스타뱅킹 간편홈(배포 단순화/고령자 모드) 재현
/// 실제 앱의 '간편홈 ON' 상태를 충실히 재현. 계좌 데이터는 더미.
///
/// 과제(공과금 납부) 경로 밖 요소는 [showOutOfScope] 로 처리해 자유 탐색 시 안 깨지게 함.
class A2KbHome extends StatelessWidget {
  const A2KbHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShColors.bg,
      body: Column(
        children: [
          const ShDevBar(label: 'A2 · 간편홈(단순화 모드) 재현 · 더미'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShStatusBar(),
                  _header(context),
                  _userRow(context),
                  _accountCard(context),
                  _repRow(context),
                  _banner(context),
                  _txnRow(context),
                  const SizedBox(height: 8),
                  _darkBar(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _header(BuildContext context) {
    Widget menu(String t) => OutOfScope(
          label: t,
          child: Text(t,
              style: const TextStyle(fontSize: 16, color: Color(0xFF2A2A2E))),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('간편홈', style: TextStyle(fontSize: 17)),
              const SizedBox(width: 8),
              OutOfScope(
                label: '간편홈 토글',
                child: Container(
                  width: 54,
                  height: 28,
                  decoration: BoxDecoration(
                    color: ShColors.yellow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 9,
                        top: 6,
                        child: Text('ON',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7A5A00))),
                      ),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              menu('알림'),
              const SizedBox(width: 18),
              menu('상담'),
              const SizedBox(width: 18),
              menu('검색'),
              const SizedBox(width: 18),
              menu('메뉴'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 44,
                height: 34,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        color: ShColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: ShColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: ShColors.bg, width: 2),
                        ),
                        child: const Icon(Icons.check, size: 9, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Text('홍길동님', style: ShText.name),
              const SizedBox(width: 4),
              const Text('›', style: TextStyle(fontSize: 18, color: ShColors.gray)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: ShColors.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration:
                      const BoxDecoration(color: ShColors.green, shape: BoxShape.circle),
                  child: const Text('F',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 5),
                const Text('패밀리', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountCard(BuildContext context) {
    return Container(
      margin: ShGap.screenPad,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ShColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFF6B5B4A), shape: BoxShape.circle),
                child: const Text('★',
                    style: TextStyle(
                        color: ShColors.yellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: ShColors.badge, borderRadius: BorderRadius.circular(6)),
                child: const Text('한도제한계좌',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF55585F),
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Text('KB마이핏통장', style: ShText.cardTitle)),
              const Icon(Icons.more_vert, color: Color(0xFF9A9A9F)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Text('000000-00-000000',
                  style: TextStyle(fontSize: 19, color: Color(0xFF3A3A3E))),
              SizedBox(width: 8),
              Icon(Icons.copy, size: 16, color: Color(0xFFB6B6BB)),
            ],
          ),
          const SizedBox(height: 44),
          Row(
            children: [
              const Text('12,500원', style: ShText.balance),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: ShColors.line),
                ),
                child: const Text('숨김',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6F))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ShButton(
                  label: '이체',
                  onTap: () => showOutOfScope(context, '이체'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShButton(
                  label: '전용화면',
                  primary: false,
                  onTap: () => showOutOfScope(context, '전용화면'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _repRow(BuildContext context) {
    return OutOfScope(
      label: '대표계좌 설정',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings, size: 18, color: Color(0xFF4A4A4F)),
                SizedBox(width: 8),
                Text('대표계좌 설정',
                    style: TextStyle(fontSize: 17, color: Color(0xFF4A4A4F))),
              ],
            ),
            Positioned(
              right: 4,
              child: Text('1 / 4',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2A2A2E))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _banner(BuildContext context) {
    return OutOfScope(
      label: '번호표 미리 뽑기',
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ShColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF86C06F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.receipt_long, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('은행가서 기다리지 않는 방법',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  SizedBox(height: 3),
                  Text('번호표 미리 뽑기', style: ShText.sub),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
          ],
        ),
      ),
    );
  }

  Widget _txnRow(BuildContext context) {
    return OutOfScope(
      label: '통합거래내역',
      child: Container(
        margin: ShGap.screenPad,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ShColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.assignment, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text('통합거래내역',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5B301), shape: BoxShape.circle),
                  child: const Text('P',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ShColors.darkBar,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('매일 랜덤P',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _darkBar(BuildContext context) {
    Widget item(String t) => Expanded(
          child: OutOfScope(
            label: t,
            child: Center(
              child: Text(t,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        );
    return Container(
      color: ShColors.darkBar,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          item('▢ KB Pay'),
          const SizedBox(
            height: 20,
            child: VerticalDivider(color: Color(0xFF6A6A72), width: 1),
          ),
          item('🪪 국민지갑(신분증)'),
        ],
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    final items = [
      (Icons.folder_outlined, '전체계좌', false),
      (Icons.shopping_bag_outlined, '금융상품', false),
      (Icons.pie_chart_outline, '자산관리', false),
      (Icons.card_giftcard_outlined, '혜택', false),
      (Icons.home_outlined, '부동산', true),
    ];
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDEEF1))),
      ),
      child: Row(
        children: items.map((it) {
          final active = it.$3;
          return Expanded(
            child: OutOfScope(
              label: it.$2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(it.$1, size: 24, color: active ? ShColors.dark : ShColors.gray),
                  const SizedBox(height: 3),
                  Text(it.$2,
                      style: TextStyle(
                          fontSize: 12,
                          color: active ? ShColors.dark : ShColors.gray)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
