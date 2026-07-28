import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_transfer_entry.dart';
import 'a2_home.dart';
import 'sh_menu.dart';

/// A1 · 신한 SOL뱅킹 일반 홈 (원본 재현 · baseline)
/// 근거: docs/screenshots/01_메인/일반홈/일반_메인_1.jpg (전체 스크롤·계좌없음)
///       docs/screenshots/01_메인/일반홈/일반_메인_2.png (계좌 등록 상태·상단)
///
/// 두 캡처를 합쳐 **계좌 등록 상태**를 기준으로 재현한다(이체 과제엔 계좌가 필요).
///  - 상단 자산/체크카드 카드 = _2
///  - 땡겨요 아래(소비·마이신한포인트·추천서비스·계열사·쉬운홈) = _1
///
/// [의도적 차이 · v6 §4.5 근사 허용]
///  - 이름은 더미([ShDummy.myName]). 잔액은 캡처가 '금액 숨김' 상태라 그대로 숨김.
///  - 신한 로고·캐릭터·아이콘 세부는 근사(원형/아이콘 대체). 레이아웃·라벨·색 계열은 캡처 기준.
///  - 색은 공용 [ShPalette].
///
/// 진입점: 자산 카드 [이체] → (신한 이체 플로우 미구현, 현재 안내) · 하단 '쉬운홈' → A2.
class A1Home extends StatelessWidget {
  const A1Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShPalette.page,
      body: Column(
        children: [
          const ShDevBar(label: 'A1 · 신한 일반 홈 재현 (계좌 데이터는 더미)'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                const ShStatusBar(),
                _header(context),
                _assetCard(context),
                _checkCardCard(context),
                _ddCard(context),
                _spendCard(context),
                _pointPromo(context),
                _recommendCard(context),
                _connectBanner(context),
                _groupCard(context),
                _bottomLinks(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ---- 헤더 ----
  Widget _header(BuildContext context) {
    Widget icon(IconData i, String label, {bool dot = false}) => OutOfScope(
          label: label,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(i, size: 27, color: const Color(0xFF2A2A2E)),
              if (dot)
                const Positioned(
                  right: -1,
                  top: -1,
                  child: CircleAvatar(radius: 3.5, backgroundColor: Color(0xFFFF4D4F)),
                ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 16, 14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF4A100),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text('C',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
          ),
          const SizedBox(width: 10),
          Text('${ShDummy.myName}님',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const Spacer(),
          icon(Icons.chat_bubble_outline, '메시지'),
          const SizedBox(width: 18),
          icon(Icons.account_balance_wallet_outlined, '지갑'),
          const SizedBox(width: 18),
          icon(Icons.notifications_none, '알림', dot: true),
          const SizedBox(width: 18),
          // 신한의 돋보기+줄 아이콘 = 전체메뉴 진입 (A1·A2 공유 메뉴)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ShMenu())),
            child: const Icon(Icons.manage_search, size: 27, color: Color(0xFF2A2A2E)),
          ),
        ],
      ),
    );
  }

  // ---- 자산 카드 (이체 진입) ----
  Widget _assetCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitleRow('자산'),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bankMark(),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('[금융거래한도계좌2]신한 주거래 우대통장',
                        style: TextStyle(fontSize: 16, color: Color(0xFF3A3A3E))),
                    Text('(저축예금)',
                        style: TextStyle(fontSize: 16, color: Color(0xFF3A3A3E))),
                    SizedBox(height: 8),
                    Text('금액 숨김',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF9A9EA6))),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const A1TransferEntry())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                  decoration: BoxDecoration(
                    color: ShPalette.pale,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('이체',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700, color: ShPalette.primary)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutOfScope(
            label: 'IRP 안내',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('절세혜택과 안정적인 노후, IRP로 준비하세요',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // ---- 체크카드 카드 ----
  Widget _checkCardCard(BuildContext context) {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE9C8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.credit_card, color: Color(0xFFE08A00)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pick E 체크캐릭터형(하리보)',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                    SizedBox(height: 3),
                    Text('금액 숨김',
                        style: TextStyle(fontSize: 16, color: Color(0xFF9A9EA6))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _fullButton(context, '앱카드 가입'),
        ],
      ),
    );
  }

  // ---- 땡겨요 ----
  Widget _ddCard(BuildContext context) {
    return _card(
      child: Column(
        children: [
          _cardTitleRow('땡겨요'),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEBD0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lunch_dining, color: Color(0xFFE8802B)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('할인쿠폰 드려요',
                        style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8F))),
                    SizedBox(height: 2),
                    Text('bhc치킨 최대 9,000원',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              _pill(context, '바로받기'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEDEEF1)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _linkText(context, '이벤트'),
              _vline(),
              _linkText(context, '쿠폰'),
              _vline(),
              _linkText(context, '포인트'),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 7월 소비 ----
  Widget _spendCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('7월 소비',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              const Icon(Icons.refresh, size: 20, color: Color(0xFF9A9EA6)),
              const Spacer(),
              OutOfScope(
                label: '소비 상세',
                child: const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FA),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.calendar_today, size: 20, color: Color(0xFF5B8DEF)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('오늘 쓴 돈',
                      style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8F))),
                  Text('0원',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 마이신한포인트 (파란 프로모) ----
  Widget _pointPromo(BuildContext context) {
    return OutOfScope(
      label: '마이신한포인트',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3D7BF5), Color(0xFF5B95F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('카드 쓸때마다 쌓이고, 현금처럼 쓰는',
                          style: TextStyle(fontSize: 15, color: Colors.white70)),
                      SizedBox(height: 4),
                      Text('마이신한포인트',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.white24, shape: BoxShape.circle),
                  child: const Text('P',
                      style: TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2A5FD6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('시작하기',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 추천서비스 ----
  Widget _recommendCard(BuildContext context) {
    Widget row(IconData i, Color bg, Color fg, String title, String sub,
            {bool pin = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                child: Icon(i, color: fg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(sub, style: const TextStyle(fontSize: 15, color: Color(0xFF8A8A8F))),
                  ],
                ),
              ),
              if (pin)
                const Icon(Icons.push_pin_outlined, size: 20, color: Color(0xFF9A9EA6)),
            ],
          ),
        );

    return _card(
      child: Column(
        children: [
          _cardTitleRow('추천서비스'),
          const SizedBox(height: 6),
          row(Icons.home_filled, const Color(0xFFFDE7EA), const Color(0xFFE8506B),
              'SOL패밀리', '가족과 함께하는 금융생활'),
          row(Icons.savings, const Color(0xFFE6F3EA), const Color(0xFF3FA65C),
              '급여클럽+', '급여이체 우대 혜택', pin: true),
          row(Icons.credit_card, const Color(0xFFEAF0FA), const Color(0xFF4A6FA5),
              '내 카드 승인내역', '모든 카드 실시간 승인내역', pin: true),
        ],
      ),
    );
  }

  Widget _connectBanner(BuildContext context) {
    return OutOfScope(
      label: '자산 연결 이벤트',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('더 많은 금융자산 모두',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('연결하면 커피쿠폰 즉시지급!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  SizedBox(height: 6),
                  Text('이벤트 바로가기  ›',
                      style: TextStyle(fontSize: 15, color: ShPalette.primary)),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE6DA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.emoji_nature, color: Color(0xFFB98A5A), size: 30),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 신한금융그룹 ----
  Widget _groupCard(BuildContext context) {
    Widget row(IconData i, Color fg, String title, String sub) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Icon(i, color: fg, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    Text(sub, style: const TextStyle(fontSize: 14, color: Color(0xFF8A8A8F))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
            ],
          ),
        );

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('신한금융그룹',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          row(Icons.credit_card, const Color(0xFF3A6EF0), '신한카드', '나에게 맞는 카드 찾기'),
          row(Icons.show_chart, const Color(0xFFE8506B), '신한투자증권', '지금 뜨는 주식 보러가기'),
          row(Icons.health_and_safety, const Color(0xFF3FA65C), '신한라이프',
              '내게 필요한 보험, 보장분석으로 확인하기'),
        ],
      ),
    );
  }

  // ---- 하단 링크 (쉬운홈 진입 = A2) ----
  Widget _bottomLinks(BuildContext context) {
    Widget link(String label, VoidCallback onTap) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Text(label,
              style: const TextStyle(fontSize: 17, color: Color(0xFF4A4A4F))),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          link('쉬운홈', () {
            // 실제 앱의 고령자 모드 토글. 현재 A2는 구현 전 플레이스홀더.
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const A2Home()));
          }),
          _vline(),
          link('홈화면 설정', () => showOutOfScope(context, '홈화면 설정')),
          _vline(),
          link('금액 숨기기', () => showOutOfScope(context, '금액 숨기기')),
        ],
      ),
    );
  }

  // ---- 하단 탭 ----
  Widget _bottomNav(BuildContext context) {
    Widget item(IconData i, String label, {bool active = false}) => Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => active ? null : showOutOfScope(context, label),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(i, size: 25, color: active ? ShPalette.primary : const Color(0xFF9A9EA6)),
                const SizedBox(height: 4),
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active ? ShPalette.primary : const Color(0xFF9A9EA6))),
              ],
            ),
          ),
        );
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDEEF1))),
      ),
      child: Row(
        children: [
          item(Icons.home_filled, '홈', active: true),
          item(Icons.account_balance_wallet, '금융'),
          item(Icons.shopping_bag_outlined, '상품'),
          item(Icons.card_giftcard, '혜택'),
          item(Icons.show_chart, '주식'),
        ],
      ),
    );
  }

  // ---- 공통 조각 ----
  Widget _card({required Widget child}) => Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      );

  Widget _cardTitleRow(String title) => Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
        ],
      );

  Widget _bankMark() => Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Color(0xFF0046D6), shape: BoxShape.circle),
        child: const Text('신한',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
      );

  Widget _fullButton(BuildContext context, String label) => OutOfScope(
        label: label,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: ShPalette.pale, borderRadius: BorderRadius.circular(12)),
          child: Text(label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: ShPalette.primary)),
        ),
      );

  Widget _pill(BuildContext context, String label) => OutOfScope(
        label: label,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(color: ShPalette.pale, borderRadius: BorderRadius.circular(999)),
          child: Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ShPalette.primary)),
        ),
      );

  Widget _linkText(BuildContext context, String label) => OutOfScope(
        label: label,
        child: Text(label, style: const TextStyle(fontSize: 17)),
      );

  Widget _vline() => Container(
        width: 1,
        height: 14,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        color: const Color(0xFFDDE0E6),
      );
}
