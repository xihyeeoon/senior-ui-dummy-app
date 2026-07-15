import 'package:flutter/material.dart';

import '../theme/kb_theme.dart';
import '../widgets/kb_common.dart';
import 'a1_menu.dart';
import 'a1_transfer_entry.dart';

/// A1 · KB스타뱅킹 기본 홈 (원본 일반 모드 · 간편홈 OFF) 충실 재현
/// 실제 앱의 기본 홈 전체 스크롤 구간을 재현. 개인·금융정보는 더미로 치환.
///
/// 과제(공과금 납부) 경로 밖 요소는 [showOutOfScope] 로 처리해 자유 탐색 시 안 깨지게 함.
class A1KbHome extends StatefulWidget {
  const A1KbHome({super.key});

  @override
  State<A1KbHome> createState() => _A1KbHomeState();
}

class _A1KbHomeState extends State<A1KbHome> {
  final _pageController = PageController(viewportFraction: 0.92);
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KbColors.bg,
      body: Column(
        children: [
          const KbDevBar(label: 'A1 · 원본 재현 — 기본 홈 (계좌 데이터는 더미)'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KbStatusBar(),
                  _header(context),
                  _govBanner(context),
                  _promoBanner(context),
                  _allAccounts(context),
                  _accountCarousel(context),
                  _indicator(),
                  _authCard(context, '인증서 로그인으로 자산 정보를 확인해 보세요'),
                  _authCard(context, '인증서 로그인으로 지출 정보를 확인해 보세요'),
                  _serviceGrid(context),
                  _notice(context),
                  _simpleHomeButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ---- 헤더 (프로필 + 아이콘, 간편홈 토글 없음) ----
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: KbColors.line),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: KbColors.green, shape: BoxShape.circle),
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
              const SizedBox(width: 10),
              const Text('홍길동님', style: KbText.name),
              const SizedBox(width: 4),
              const Text('›', style: TextStyle(fontSize: 18, color: KbColors.gray)),
            ],
          ),
          Row(
            children: [
              OutOfScope(
                label: '알림',
                child: const _BadgeIcon(icon: Icons.notifications_none),
              ),
              const SizedBox(width: 16),
              OutOfScope(
                label: '검색',
                child: const Icon(Icons.search, size: 26, color: Color(0xFF2A2A2E)),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const A1Menu()),
                ),
                child: const Icon(Icons.menu, size: 26, color: Color(0xFF2A2A2E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 정부 지원금 배너 ----
  Widget _govBanner(BuildContext context) {
    return OutOfScope(
      label: '정부 지원금 및 행정알림',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: KbColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('정부 지원금 및 행정알림',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      SizedBox(height: 6),
                      Text('이제는 국민비서로\n간편하게 확인하세요!',
                          style: TextStyle(fontSize: 15, color: Color(0xFF4A4A4F))),
                      SizedBox(height: 14),
                      Text('맞춤알림 받기  ›',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE8FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mail_outline,
                      color: Color(0xFF3B7DD8), size: 30),
                ),
              ],
            ),
            const Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.close, size: 20, color: Color(0xFFB0B4BC)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 프로모 배너 (KB Youth Club) ----
  Widget _promoBanner(BuildContext context) {
    return OutOfScope(
      label: 'KB Youth Club 프로모',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('워터밤속초? 캐리비안베이?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('KB Youth Club에 다 있어요!',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4F))),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _Dot(active: true),
                      _Dot(),
                      _Dot(),
                      _Dot(),
                      _Dot(),
                      SizedBox(width: 6),
                      Icon(Icons.play_arrow, size: 16, color: KbColors.gray),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF7C5CFF), Color(0xFFB86CE0)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('KB Youth Club',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 내 계좌 전체보기 ----
  Widget _allAccounts(BuildContext context) {
    return OutOfScope(
      label: '내 계좌 전체보기',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: KbColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              color: const Color(0xFFFFF3C4),
              child: const Text('내 계좌 전체보기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
          ],
        ),
      ),
    );
  }

  // ---- 계좌 캐러셀 (PageView + 1/5) ----
  Widget _accountCarousel(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 5,
        onPageChanged: (i) => setState(() => _page = i),
        itemBuilder: (_, i) =>
            i == 0 ? _mainAccountCard(context) : _simpleAccountCard(i),
      ),
    );
  }

  Widget _mainAccountCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KbColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFF6B5B4A), shape: BoxShape.circle),
                child: const Text('★',
                    style: TextStyle(color: KbColors.yellow, fontSize: 13)),
              ),
              const SizedBox(width: 8),
              const Text('KB마이핏통장',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: KbColors.badge, borderRadius: BorderRadius.circular(6)),
                child: const Text('한도제한',
                    style: TextStyle(fontSize: 12, color: Color(0xFF55585F))),
              ),
              const Spacer(),
              const Icon(Icons.more_vert, size: 20, color: Color(0xFF9A9A9F)),
            ],
          ),
          const SizedBox(height: 2),
          const Row(
            children: [
              Text('000000-00-000000',
                  style: TextStyle(fontSize: 15, color: KbColors.gray)),
              SizedBox(width: 6),
              Icon(Icons.copy, size: 14, color: Color(0xFFB6B6BB)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('650원', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: KbColors.line),
                ),
                child: const Text('숨김',
                    style: TextStyle(fontSize: 13, color: KbColors.gray)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: KbButton(
                  label: '이체',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const A1TransferEntry()),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KbButton(
                    label: '전용화면',
                    primary: false,
                    onTap: () => showOutOfScope(context, '전용화면')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _simpleAccountCard(int i) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KbColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('예금·적금 $i',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          const Text('000000-00-000000',
              style: TextStyle(fontSize: 15, color: KbColors.gray)),
          const SizedBox(height: 40),
          const Text('0원', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _indicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_left, size: 20, color: KbColors.gray),
            const SizedBox(width: 12),
            Text('${_page + 1} / 5',
                style: const TextStyle(fontSize: 16, color: Color(0xFF4A4A4F))),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, size: 20, color: KbColors.gray),
          ],
        ),
      ),
    );
  }

  // ---- 인증서 로그인 카드 ----
  Widget _authCard(BuildContext context, String text) {
    return OutOfScope(
      label: text,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: KbColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF6A6A6F))),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
          ],
        ),
      ),
    );
  }

  // ---- 서비스 타일 그리드 ----
  Widget _serviceGrid(BuildContext context) {
    final tiles = <Widget>[
      _tile(context, '모바일 신분증', Icons.badge_outlined, const Color(0xFF5B8DEF)),
      _tile(context, 'KB Youth\nClub', Icons.groups, const Color(0xFF7C5CFF)),
      _tile(context, 'KB증권\n주식 투자하기', Icons.trending_up, const Color(0xFFFF7A45)),
      _tile(context, '매일\n용돈받기', Icons.savings, const Color(0xFFEF7BA0)),
      _addTile(context),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.98,
        children: tiles,
      ),
    );
  }

  Widget _tile(BuildContext context, String title, IconData icon, Color color) {
    return OutOfScope(
      label: title.replaceAll('\n', ' '),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE4F1EF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(icon, color: color, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTile(BuildContext context) {
    return OutOfScope(
      label: '메뉴 추가',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: KbColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: KbColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('메뉴 추가',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xFFDDDFE4), shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 공지 ----
  Widget _notice(BuildContext context) {
    return OutOfScope(
      label: '공지',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: KbColors.darkBar,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('공지',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
            const SizedBox(width: 10),
            const Text('KB스타뱅킹「홈 화면」개편 안내',
                style: TextStyle(fontSize: 16, color: Color(0xFF3A3A3E))),
          ],
        ),
      ),
    );
  }

  // ---- 간편홈 보기 버튼 ----
  Widget _simpleHomeButton(BuildContext context) {
    return Center(
      child: OutOfScope(
        label: '간편홈 보기',
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: KbColors.line),
          ),
          child: const Text('간편홈 보기', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  // ---- 하단 네비 ----
  Widget _bottomNav(BuildContext context) {
    final items = [
      (Icons.shopping_bag_outlined, '상품', false),
      (Icons.pie_chart_outline, '자산', false),
      (Icons.account_balance_wallet_outlined, '지갑', false),
      (Icons.card_giftcard_outlined, '혜택', false),
      (Icons.palette_outlined, '테마', true),
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
                  Icon(it.$1,
                      size: 24, color: active ? KbColors.yellow : KbColors.gray),
                  const SizedBox(height: 3),
                  Text(it.$2,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          color: active ? KbColors.dark : KbColors.gray)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 알림 벨 + 빨간 점 배지
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  const _BadgeIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, size: 26, color: const Color(0xFF2A2A2E)),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({this.active = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 16 : 6,
      height: 6,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6A6A6F) : const Color(0xFFC9CDD4),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
