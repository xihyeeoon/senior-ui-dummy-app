import 'package:flutter/material.dart';

import '../data/sh_menu_data.dart';
import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';

/// 신한 SOL뱅킹 전체 메뉴 (A1·A2 공유 — 고령자/일반 메뉴 동일).
/// 근거: docs/screenshots/02_메뉴/ (43장). 데이터: [shMenu].
///
/// 구조: 고정 대분류 탭 바(7개, 스크롤 스파이 + 탭 이동) + 카테고리별 칩 행 + 섹션 리스트.
/// 과제 경로: 은행 › 이체 › 계좌이체 / 은행 › 세금/공과금 › 납부하기.
/// 항목은 신한 세부 플로우 미구현이라 현재는 [showOutOfScope] 안내.
class ShMenu extends StatefulWidget {
  const ShMenu({super.key});

  @override
  State<ShMenu> createState() => _ShMenuState();
}

class _ShMenuState extends State<ShMenu> {
  final _scrollCtrl = ScrollController();
  final _tabCtrl = ScrollController();

  final _catKeys = {for (final c in shMenu) c.tab: GlobalKey()};
  final _tabKeys = {for (final c in shMenu) c.tab: GlobalKey()};
  // 섹션 키: "카테고리::칩"
  final _sectionKeys = <String, GlobalKey>{
    for (final c in shMenu)
      for (final s in c.sections) '${c.tab}::${s.chip}': GlobalKey(),
  };

  String _activeCat = shMenu.first.tab;

  static const _catIcons = {
    '은행': Icons.account_balance,
    '카드': Icons.credit_card,
    '증권': Icons.show_chart,
    '보험': Icons.health_and_safety,
    '혜택': Icons.celebration,
    '상품': Icons.shopping_bag,
    '고객센터': Icons.headset_mic,
  };

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    String active = shMenu.first.tab;
    for (final c in shMenu) {
      final ctx = _catKeys[c.tab]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= 240) active = c.tab;
    }
    if (active != _activeCat) {
      setState(() => _activeCat = active);
      _revealTab(active);
    }
  }

  void _revealTab(String tab) {
    final ctx = _tabKeys[tab]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 250), alignment: 0.1);
  }

  void _jumpToCategory(String tab) {
    final ctx = _catKeys[tab]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 350), alignment: 0.02);
  }

  void _jumpToSection(String key) {
    final ctx = _sectionKeys[key]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 350), alignment: 0.05);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShPalette.page,
      body: Column(
        children: [
          const ShDevBar(label: '메뉴 · 신한 전체메뉴 재현 (A1·A2 공유)'),
          const ShStatusBar(),
          _topBar(),
          _searchBar(),
          _tabBar(),
          Expanded(
            child: ListView(
              key: const ValueKey('shMenuList'),
              controller: _scrollCtrl,
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                for (final c in shMenu) _category(c),
              ],
            ),
          ),
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
          OutOfScope(
              label: '고객센터 채팅',
              child: const Icon(Icons.chat_bubble_outline, size: 25, color: ShColors.dark)),
          const SizedBox(width: 18),
          OutOfScope(
              label: '설정',
              child: const Icon(Icons.settings_outlined, size: 25, color: ShColors.dark)),
          const SizedBox(width: 18),
          OutOfScope(
              label: '로그아웃',
              child: const Icon(Icons.logout, size: 25, color: ShColors.dark)),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return OutOfScope(
      label: '검색',
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEFF3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: const [
            Expanded(
              child: Text('상품, 메뉴, 혜택 등을 검색해보세요',
                  style: TextStyle(fontSize: 17, color: Color(0xFF9A9EA6))),
            ),
            Icon(Icons.search, size: 24, color: Color(0xFF6A6A6F)),
          ],
        ),
      ),
    );
  }

  // ---- 대분류 탭 바 (고정 · 스파이 · 탭 이동) ----
  Widget _tabBar() {
    return Container(
      height: 58,
      color: ShPalette.page,
      child: ListView(
        controller: _tabCtrl,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final c in shMenu) _tab(c.tab),
        ],
      ),
    );
  }

  Widget _tab(String tab) {
    final active = tab == _activeCat;
    return GestureDetector(
      key: _tabKeys[tab],
      behavior: HitTestBehavior.opaque,
      onTap: () => _jumpToCategory(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(_catIcons[tab],
                    size: 20,
                    color: active ? ShPalette.primary : const Color(0xFF9A9EA6)),
                const SizedBox(width: 6),
                Text(tab,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                      color: active ? ShColors.dark : const Color(0xFF9A9EA6),
                    )),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 3,
              width: 40,
              color: active ? ShColors.dark : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  // ---- 카테고리 블록 ----
  Widget _category(ShMenuCategory c) {
    return Container(
      key: _catKeys[c.tab],
      color: ShPalette.page,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 제목
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            child: Row(
              children: [
                Icon(_catIcons[c.tab], size: 24, color: ShPalette.primary),
                const SizedBox(width: 8),
                Text(c.tab,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          // 칩 행 (섹션으로 이동)
          if (c.sections.length > 1) _chipRow(c),
          // 섹션들
          Container(
            color: Colors.white,
            child: Column(
              children: [for (final s in c.sections) _section(c.tab, s)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipRow(ShMenuCategory c) {
    return SizedBox(
      height: 54,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final s in c.sections)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _jumpToSection('${c.tab}::${s.chip}'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: ShColors.line),
                  ),
                  child: Center(
                    child: Text(s.chip, style: const TextStyle(fontSize: 15)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _section(String tab, ShMenuSection s) {
    return Column(
      key: _sectionKeys['$tab::${s.chip}'],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
          child: Row(
            children: [
              Text(s.chip,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF6A6A6F))),
              if (s.hasGap) ...[
                const SizedBox(width: 6),
                const Icon(Icons.more_horiz, size: 18, color: Color(0xFFC0C4CC)),
              ],
            ],
          ),
        ),
        for (final item in s.items) _item(item),
        const Divider(height: 1, color: Color(0xFFF0F1F4)),
      ],
    );
  }

  Widget _item(String label) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showOutOfScope(context, label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(label, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
