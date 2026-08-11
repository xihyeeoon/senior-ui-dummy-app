import 'package:flutter/material.dart';

import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_bill_pay_camera.dart';

/// 신한 세금/공과금 메인
/// 근거: docs/screenshots/03_공과금납부/…_192712592(_00~_03).png (긴 스크롤 1화면)
///
/// 히어로 + [납부하기]/[조회하기] 카드 + 섹션 리스트(국고금·통합지방세·
/// 생활공과금·4대 보험/연금·벌금/과태료).
/// 과제 경로: 은행 › 세금/공과금 › 납부하기 로 진입.
///
/// [미구현] 납부하기/개별 항목의 다음 단계(지로번호 입력→완료)는 캡처가 없어
/// 추측 재현하지 않고 [showOutOfScope]로 둔다. 캡처 확보 시 연결 예정.
/// 아이콘·일러스트 세부는 근사(v6 §4.5).
class A1BillHome extends StatelessWidget {
  const A1BillHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '공과금 · 신한 세금/공과금 메인 · 더미'),
          const ShStatusBar(),
          _topBar(context),
          Expanded(
            child: ListView(
              key: const ValueKey('billHomeList'),
              padding: EdgeInsets.zero,
              children: [
                _hero(),
                _entryCard(context),
                const SizedBox(height: 12),
                for (final s in _sections) _section(context, s),
                const SizedBox(height: 30),
              ],
            ),
          ),
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
          OutOfScope(
            label: '고객센터',
            child: const Icon(Icons.chat_bubble_outline, size: 25, color: ShColors.dark),
          ),
          const SizedBox(width: 18),
          OutOfScope(
            label: '홈',
            child: const Icon(Icons.home_outlined, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  // ---- 히어로 + 카드 (연회색 배경 위) ----
  Widget _hero() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEEF2FB),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Text('각종 세금/공과금 이제\n간편하게 납부해보세요',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, height: 1.3)),
          ),
          Container(
            width: 84,
            height: 84,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long, size: 40, color: Color(0xFF6A7A95)),
          ),
        ],
      ),
    );
  }

  Widget _entryCard(BuildContext context) {
    Widget half(String title, String desc, IconData icon, Color fg,
        {VoidCallback? onTap}) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap ?? () => showOutOfScope(context, title),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF8A8A8F), height: 1.35)),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 30, color: fg),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      // 히어로 연회색이 카드 뒤로 이어지도록.
      color: const Color(0xFFEEF2FB),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  half('납부하기', '종이고지서 번호로 바로 납부',
                      Icons.description_outlined, const Color(0xFF3B6FE0),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const A1BillPayCamera()))),
                  const VerticalDivider(width: 1, color: Color(0xFFEDEEF1)),
                  half('조회하기', '전자고지서로 간편하게 확인',
                      Icons.phone_android, const Color(0xFF3FA65C)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            OutOfScope(
              label: '자주쓰는 지로번호 등록',
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text('자주쓰는 지로번호 등록해보세요!',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                    Icon(Icons.chevron_right, size: 22, color: Color(0xFF9A9A9F)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 섹션 ----
  Widget _section(BuildContext context, _BillSection s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
          child: Text(s.title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
        ),
        for (final it in s.items) _row(context, it),
        const SizedBox(height: 6),
        Container(height: 8, color: const Color(0xFFF2F4F8)),
      ],
    );
  }

  /// 에셋이 없을 때의 색상 원형 근사(폴백).
  Widget _fallbackIcon(_BillItem it) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: it.bg,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(it.icon, size: 25, color: it.fg),
    );
  }

  Widget _row(BuildContext context, _BillItem it) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          showOutOfScope(context, '${it.label} (신한 납부 상세 미구현 · 캡처 대기)'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            it.asset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      'assets/bill_icons/${it.asset}.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _fallbackIcon(it),
                    ),
                  )
                : _fallbackIcon(it),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(it.label,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700)),
                  if (it.sub != null) ...[
                    const SizedBox(height: 2),
                    Text(it.sub!,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF8A8A8F))),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFFB8BDC7)),
          ],
        ),
      ),
    );
  }
}

// ---- 데이터 (캡처 기준 순서) ----

class _BillItem {
  final String label;
  final String? sub;
  final IconData icon;
  final Color bg;
  final Color fg;

  /// 실제 아이콘 에셋 이름(assets/bill_icons/{asset}.png). null이면 Material 근사.
  final String? asset;
  const _BillItem(this.label, this.icon, this.bg, this.fg, {this.sub, this.asset});
}

class _BillSection {
  final String title;
  final List<_BillItem> items;
  const _BillSection(this.title, this.items);
}

const _blueBg = Color(0xFFEAF0FA);
const _blue = Color(0xFF3B6FE0);
const _orangeBg = Color(0xFFFDEEE1);
const _orange = Color(0xFFE8802B);
const _yellowBg = Color(0xFFFFF4D6);
const _yellow = Color(0xFFF2B01E);
const _grayBg = Color(0xFFEEF0F4);
const _gray = Color(0xFF6A7A95);
const _redBg = Color(0xFFFDECEC);
const _red = Color(0xFFE0574F);

const _sections = <_BillSection>[
  _BillSection('국고금', [
    _BillItem('국세', Icons.receipt_long, _orangeBg, _orange, asset: 'c1'),
    _BillItem('관세', Icons.account_balance_wallet, _blueBg, _blue, asset: 'c2'),
    _BillItem('국고', Icons.account_balance, _grayBg, _gray, asset: 'c3'),
    _BillItem('국세 환급금 조회', Icons.plagiarism_outlined, _orangeBg, _orange,
        asset: 'c4'),
  ]),
  _BillSection('통합지방세', [
    _BillItem('지방세', Icons.receipt_long, _orangeBg, _orange,
        sub: '주민세, 재산세, 자동차세 등', asset: 'c5'),
    _BillItem('환경개선부담금', Icons.directions_car, _blueBg, _blue,
        sub: '경유자동차 사용 부담금', asset: 'c6'),
    _BillItem('세외수입', Icons.volunteer_activism, _yellowBg, _yellow,
        sub: '과태료, 수수료, 기부금 등', asset: 'c7'),
  ]),
  _BillSection('생활공과금', [
    _BillItem('아파트/상가관리비', Icons.apartment, _blueBg, _blue, asset: 'c8'),
    _BillItem('KT통신요금', Icons.smartphone, _grayBg, Color(0xFF2B2B2B), asset: 'c9'),
    _BillItem('전기요금/TV수신료', Icons.bolt, _blueBg, _blue, asset: 'c10'),
    _BillItem('상하수도요금', Icons.water_drop, _blueBg, _blue, asset: 'c11'),
    _BillItem('고속도로 통행료', Icons.alt_route, _grayBg, _gray, asset: 'c12'),
  ]),
  _BillSection('4대 보험/연금', [
    _BillItem('국민연금', Icons.savings, _yellowBg, _yellow, asset: 'c13'),
    _BillItem('공무원연금', Icons.person, _blueBg, _blue, asset: 'c14'),
    _BillItem('통합징수 보험료', Icons.health_and_safety, _blueBg, _blue, asset: 'c15'),
    _BillItem('고용/산재보험료', Icons.beach_access, _yellowBg, _yellow, asset: 'c16'),
  ]),
  _BillSection('벌금/과태료', [
    _BillItem('교통범칙금', Icons.directions_car, _redBg, _red, asset: 'c17'),
    _BillItem('검찰청 벌과금', Icons.gavel, _redBg, _red, asset: 'c18'),
  ]),
];
