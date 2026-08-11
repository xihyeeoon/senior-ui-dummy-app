import 'package:flutter/material.dart';

import '../data/sh_dummy.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_home.dart';
import 'a1_transfer_entry.dart';
import 'sh_menu.dart';

/// A2 · 신한 쉬운홈 (배포된 고령자 모드 · 배포 현실 baseline)
/// 근거: docs/screenshots/01_메인/고령자홈/고령자_메인_1~3.png (낱개 스크롤)
///
/// 일반 홈(A1)과 다른 별도 홈. 세부 태스크 화면은 일반과 공유(v6 확인).
/// 일반 대비 차이: 글자 큼, 아이콘에 라벨, 이체=**돈보내기**(쉬운 말),
/// 곡선적 마케팅 대신 **쉬운홈 서비스** 큐레이션 목록(공과금 내기 포함).
///
/// [의도적 차이 · v6 §4.5] 이름 더미, 금액은 캡처가 '금액 숨김'. 로고·아이콘 근사.
/// 진입점: 자산 [돈보내기] → (신한 이체 플로우 미구현) · 쉬운홈 서비스 [공과금 내기] → (미구현).
/// 하단 '기본홈' → A1(일반 홈)으로 토글.
class A2Home extends StatelessWidget {
  const A2Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShPalette.page,
      body: Column(
        children: [
          const ShDevBar(label: 'A2 · 신한 쉬운홈 재현 (계좌 데이터는 더미)'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                const ShStatusBar(),
                _header(context),
                _assetCard(context),
                _cardCard(context),
                _stockCard(context),
                _pointPromo(context),
                _easyServices(context),
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

  // ---- 헤더 (아이콘 + 라벨) ----
  Widget _header(BuildContext context) {
    Widget navIcon(String asset, String label, {bool dot = false}) => OutOfScope(
          label: label,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset('assets/home_icons/$asset.png', width: 34, height: 34),
                  if (dot)
                    const Positioned(
                      right: -1,
                      top: -1,
                      child: CircleAvatar(radius: 4, backgroundColor: Color(0xFFFF4D4F)),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4F))),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF4A100),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text('C',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          ),
          const SizedBox(width: 10),
          Text('${ShDummy.myName}님',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const Spacer(),
          navIcon('h1', 'AI'),
          const SizedBox(width: 16),
          navIcon('h2', '쏠지갑'),
          const SizedBox(width: 16),
          navIcon('h3', '알림', dot: true),
          const SizedBox(width: 16),
          // 전체메뉴 진입 (A1·A2 공유 메뉴)
          GestureDetector(
            key: const ValueKey('menuEntry'),
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ShMenu())),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/home_icons/h4.png', width: 34, height: 34),
                const SizedBox(height: 3),
                const Text('메뉴',
                    style: TextStyle(fontSize: 13, color: Color(0xFF4A4A4F))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- 자산 카드 (돈보내기 진입) ----
  Widget _assetCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitleRow('자산'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bankMark(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('[금융거래한도계좌2]신한 주거래 우대통장(저축예금)',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w700, height: 1.3)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('${ShDummy.payeeBank} ${ShDummy.myAccountNo}',
                            style: const TextStyle(fontSize: 17, color: Color(0xFF8A8A8F))),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy_outlined, size: 17, color: Color(0xFF9A9EA6)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('금액 숨김',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF9A9EA6))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 고령자 모드의 이체 = '돈보내기'(쉬운 말). A1과 동일한 신한 이체 플로우 공유.
          _fullButton(context, '돈보내기',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const A1TransferEntry()))),
        ],
      ),
    );
  }

  // ---- SOL Pay 체크카드 ----
  Widget _cardCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1E)),
              children: [
                TextSpan(text: 'SOL Pay ', style: TextStyle(color: ShPalette.primary)),
                TextSpan(text: 'Pick E 체크캐릭터형(하리보)'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE9C8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.credit_card, color: Color(0xFFE08A00)),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('7월 이용 금액',
                      style: TextStyle(fontSize: 17, color: Color(0xFF8A8A8F))),
                  Text('금액 숨김',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF9A9EA6))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _fullButton(context, '+ 앱카드 가입',
              onTap: () => showOutOfScope(context, '앱카드 가입')),
        ],
      ),
    );
  }

  // ---- 주식 ----
  Widget _stockCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitleRow('주식'),
          const SizedBox(height: 14),
          Row(
            children: const [
              Icon(Icons.candlestick_chart, size: 34, color: Color(0xFFE8506B)),
              SizedBox(width: 12),
              Text('금액 숨김',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF9A9EA6))),
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
            colors: [ShPalette.promoFrom, ShPalette.promoTo],
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
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: const Text('P',
                      style: TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('마이신한포인트',
                        style: TextStyle(fontSize: 17, color: Colors.white70)),
                    Text('금액 숨김',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2A5FD6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('모으기',
                  style: TextStyle(
                      color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 쉬운홈 서비스 (큐레이션 목록) ----
  Widget _easyServices(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text('쉬운홈 서비스',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
          ),
          _svc(context, Icons.lock_outline, const Color(0xFF9AA0AA), '지켜요(금융사기 예방)'),
          _svc(context, Icons.list_alt, const Color(0xFF5B8DEF), '전체계좌조회'),
          _svc(context, Icons.local_atm, const Color(0xFF3FA65C), 'ATM 돈찾기'),
          _svc(context, Icons.savings, const Color(0xFF5B8DEF), '상품가입'),
          // 과제 1(공과금) 진입점 — 고령자 모드가 공과금을 홈에 직접 노출한다.
          _svc(context, Icons.receipt_long, const Color(0xFFE8802B), '공과금 내기',
              onTap: () =>
                  showOutOfScope(context, '공과금 내기 (신한 공과금 플로우 미구현 · 캡처 대기)')),
          _svc(context, Icons.verified_user, const Color(0xFF2A6BF2), '신한인증서'),
          _svc(context, Icons.shield_outlined, const Color(0xFF5B8DEF), '보안 서비스'),
          _svc(context, Icons.notifications_active, const Color(0xFFE8506B), '사고 신고'),
        ],
      ),
    );
  }

  Widget _svc(BuildContext context, IconData i, Color fg, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => showOutOfScope(context, label),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            SizedBox(width: 40, child: Icon(i, size: 28, color: fg)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const Icon(Icons.chevron_right, size: 26, color: Color(0xFF9A9A9F)),
          ],
        ),
      ),
    );
  }

  // ---- 신한금융그룹 ----
  Widget _groupCard(BuildContext context) {
    Widget row(IconData i, Color fg, String title, String sub) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(i, color: fg, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                    Text(sub, style: const TextStyle(fontSize: 15, color: Color(0xFF8A8A8F))),
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
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          row(Icons.credit_card, const Color(0xFF3A6EF0), '신한카드', '나에게 맞는 카드 찾기'),
          row(Icons.show_chart, const Color(0xFFE8506B), '신한투자증권', '지금 뜨는 주식 보러가기'),
          row(Icons.health_and_safety, const Color(0xFF3FA65C), '신한라이프',
              '내게 필요한 보험, 보장분석으로 확인하기'),
        ],
      ),
    );
  }

  // ---- 하단 링크 (기본홈 = A1 토글) ----
  Widget _bottomLinks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const A1Home())),
            child: const Text('기본홈', style: TextStyle(fontSize: 18, color: Color(0xFF4A4A4F))),
          ),
          Container(
              width: 1,
              height: 15,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xFFDDE0E6)),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showOutOfScope(context, '금액 숨기기'),
            child: const Text('금액 숨기기', style: TextStyle(fontSize: 18, color: Color(0xFF4A4A4F))),
          ),
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
                Icon(i, size: 26, color: active ? ShPalette.primary : const Color(0xFF9A9EA6)),
                const SizedBox(height: 4),
                Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active ? ShPalette.primary : const Color(0xFF9A9EA6))),
              ],
            ),
          ),
        );
    return Container(
      height: 78,
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
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      );

  Widget _cardTitleRow(String title) => Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
        ],
      );

  // 자산 계좌(신한) 실제 은행 로고. 기존 은행 아이콘 세트(b0=신한) 재사용.
  Widget _bankMark() => const ShBankMark('신한', size: 48);

  Widget _fullButton(BuildContext context, String label, {required VoidCallback onTap}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: ShPalette.pale, borderRadius: BorderRadius.circular(12)),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: ShPalette.primary)),
        ),
      );
}
