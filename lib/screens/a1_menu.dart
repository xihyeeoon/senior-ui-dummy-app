import 'package:flutter/material.dart';

import '../theme/kb_theme.dart';
import '../widgets/kb_common.dart';
import 'a1_bill_main.dart';
import 'a1_transfer_entry.dart';

/// A1 · KB스타뱅킹 전체메뉴 재현
/// 근거: docs/screenshots/a1/01_menu/기본_메뉴(1~10).png
///
/// 과제(공과금 납부)의 **진입 경로**를 만드는 화면. 자유 탐색 평가에서
/// 탐색 비용(섹션 12개, 공과금은 4번째)이 A1 baseline 난이도의 핵심이므로
/// 섹션 순서·라벨·부제를 캡처 그대로 옮긴다.
///
/// [원본과 의도적으로 다른 점 — docs/fidelity.md 참고]
/// 캡처의 '최근/My메뉴'에는 [환경설정] [공과금 납부/조회] 두 칩이 있으나,
/// 이는 캡처한 기기가 공과금을 최근 사용해 생긴 개인화 상태다.
/// 그대로 두면 메뉴 진입 즉시 1탭으로 과제가 끝나 탐색 비용이 사라지므로
/// **[공과금 납부/조회] 칩은 제외**한다. 실험폰 초기 상태 캡처를 받으면 그에 맞춰 정정.
class A1Menu extends StatefulWidget {
  const A1Menu({super.key});

  @override
  State<A1Menu> createState() => _A1MenuState();
}

class _A1MenuState extends State<A1Menu> {
  final _scrollCtrl = ScrollController();
  final _chipCtrl = ScrollController();

  /// 섹션별 위치 추적용 (스크롤 스파이 + 칩 탭 이동).
  final _sectionKeys = <String, GlobalKey>{
    for (final s in _sections) s.title: GlobalKey(),
  };
  final _chipKeys = <String, GlobalKey>{
    for (final s in _sections)
      if (s.hasChip) s.title: GlobalKey(),
  };

  /// 칩 바는 최상단에서는 숨어 있다가 스크롤하면 나타난다(캡처 1 vs 2).
  bool _showChips = false;
  String _active = _chipTitles.first;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _chipCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollCtrl.offset > 120;
    if (show != _showChips) setState(() => _showChips = show);

    // 화면 상단(칩 바 아래)을 지나간 마지막 섹션을 활성 칩으로.
    String active = _chipTitles.first;
    for (final title in _chipTitles) {
      final ctx = _sectionKeys[title]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= 220) active = title;
    }
    if (active != _active) {
      setState(() => _active = active);
      _revealChip(active);
    }
  }

  /// 활성 칩이 칩 바 안에 보이도록 가로 스크롤(캡처에서 선택 칩이 늘 왼쪽에 옴).
  void _revealChip(String title) {
    final ctx = _chipKeys[title]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 250),
      alignment: 0.05,
    );
  }

  void _jumpTo(String title) {
    final ctx = _sectionKeys[title]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      alignment: 0.02,
    );
  }

  /// 과제 경로만 실제 화면으로 연결한다 (과제 1: 공과금 납부, 과제 2: 이체).
  void _onItemTap(String label) {
    final page = switch (label) {
      '공과금 납부/조회' => const A1BillMain(),
      '이체' => const A1TransferEntry(),
      _ => null,
    };
    if (page == null) {
      showOutOfScope(context, label);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const KbDevBar(label: 'A1 · 전체메뉴 재현 · 더미'),
          const KbStatusBar(),
          _topBar(),
          if (_showChips) _chipBar(),
          Expanded(
            child: ListView(
              key: const ValueKey('menuList'),
              controller: _scrollCtrl,
              padding: EdgeInsets.zero,
              children: [
                if (!_showChips) ...[
                  _quickBar(),
                  _myMenu(),
                ],
                const _SectionGap(),
                for (final s in _sections) _section(s),
                _lastAccess(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- 상단: 로그아웃 / 검색 / 닫기 ----
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutOfScope(
            label: '로그아웃',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('로그아웃',
                    style: TextStyle(fontSize: 19, color: Color(0xFF8A8A8F))),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 20, color: Color(0xFF8A8A8F)),
              ],
            ),
          ),
          Row(
            children: [
              OutOfScope(
                label: '검색',
                child: const Icon(Icons.search, size: 28, color: KbColors.dark),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(Icons.close, size: 28, color: KbColors.dark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 고객센터 / 인증·보안 / 환경설정 ----
  Widget _quickBar() {
    Widget item(IconData icon, String label) => Expanded(
          child: OutOfScope(
            label: label,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: const Color(0xFF3A3A3E)),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF2A2A2E))),
              ],
            ),
          ),
        );
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          item(Icons.headset_mic_outlined, '고객센터'),
          item(Icons.verified_user_outlined, '인증/보안'),
          item(Icons.settings_outlined, '환경설정'),
        ],
      ),
    );
  }

  // ---- 최근/My메뉴 ----
  // 캡처의 [공과금 납부/조회] 칩은 의도적으로 제외 (클래스 주석 참고).
  Widget _myMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최근/My메뉴',
                  style: TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
              OutOfScope(
                label: 'My메뉴 설정',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('My메뉴 설정',
                        style: TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
                    Icon(Icons.chevron_right, size: 20, color: Color(0xFF9A9A9F)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _myMenuChip('환경설정'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myMenuChip(String label) {
    return OutOfScope(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: KbColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 17)),
            const SizedBox(width: 8),
            const Icon(Icons.star_border, size: 19, color: Color(0xFF9A9A9F)),
          ],
        ),
      ),
    );
  }

  // ---- 카테고리 칩 바 (스크롤 시 노출 · 스크롤 스파이) ----
  Widget _chipBar() {
    return Container(
      height: 62,
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(color: Colors.white),
      child: ListView(
        controller: _chipCtrl,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final title in _chipTitles) _chip(title),
          // 캡처의 [∨] 더보기 — 범위 밖.
          Center(
            child: OutOfScope(
              label: '카테고리 더보기',
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFECEEF2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.keyboard_arrow_down,
                    size: 24, color: Color(0xFF4A4A4F)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String title) {
    final active = title == _active;
    return Padding(
      key: _chipKeys[title],
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _jumpTo(title),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF3A3D44) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                  color: active ? const Color(0xFF3A3D44) : KbColors.line),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? Colors.white : KbColors.dark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- 섹션 ----
  Widget _section(_Section s) {
    return Column(
      key: _sectionKeys[s.title],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              _SectionIcon(section: s),
              const SizedBox(width: 10),
              Text(s.title,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7A7A7F))),
            ],
          ),
        ),
        if (s.grid.isNotEmpty) _grid(s.grid) else ...s.items.map(_item),
        const _SectionGap(),
      ],
    );
  }

  Widget _grid(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
        children: [
          for (final l in labels)
            OutOfScope(
              label: l,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(l,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _item(_Item it) {
    // 테마별서비스: 라벨과 설명이 한 줄에 나란히.
    if (it.inline) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTap(it.label),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 62,
                child: Text(it.label,
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(it.sub!,
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF8A8A8F))),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTap(it.label),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 13, 20, it.sub == null ? 13 : 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(it.label,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            if (it.sub != null) ...[
              const SizedBox(height: 3),
              Text(it.sub!,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF8A8A8F))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _lastAccess() {
    return Container(
      color: const Color(0xFFF7F8FA),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
      alignment: Alignment.centerRight,
      child: const Text('최근접속 2026.07.15 15:24:05',
          style: TextStyle(fontSize: 15, color: Color(0xFF6A6A6F))),
    );
  }
}

/// 섹션 사이 연회색 구분 띠.
class _SectionGap extends StatelessWidget {
  const _SectionGap();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFEDEEF1),
    );
  }
}

class _SectionIcon extends StatelessWidget {
  final _Section section;
  const _SectionIcon({required this.section});

  @override
  Widget build(BuildContext context) {
    if (section.title == '상품가입/관리') {
      return Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: KbColors.yellow,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text('KB',
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF5A4A00))),
      );
    }
    if (section.title == '공과금') {
      return Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2FB79B),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text('TAX',
            style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
      );
    }
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: section.iconBg,
        shape: section.squareIcon ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: section.squareIcon ? BorderRadius.circular(4) : null,
      ),
      child: Icon(section.icon, size: 13, color: Colors.white),
    );
  }
}

// ---- 데이터 (캡처 기준) ----

class _Item {
  final String label;
  final String? sub;

  /// 라벨·설명을 한 줄에 나란히 (테마별서비스 스타일).
  final bool inline;
  const _Item(this.label, [this.sub]) : inline = false;
  const _Item.inline(this.label, this.sub) : inline = true;
}

class _Section {
  final String title;
  final IconData icon;
  final Color iconBg;
  final bool squareIcon;
  final List<_Item> items;
  final List<String> grid;

  /// 상단 칩 바에 나오는 섹션인지 (캡처상 '상품가입/관리'는 칩이 없다).
  final bool hasChip;

  const _Section(
    this.title, {
    required this.icon,
    required this.iconBg,
    this.squareIcon = false,
    this.items = const [],
    this.grid = const [],
    this.hasChip = true,
  });
}

const _sections = <_Section>[
  _Section(
    '상품가입/관리',
    icon: Icons.star,
    iconBg: KbColors.yellow,
    hasChip: false,
    grid: [
      '추천상품', '예적금', '대출', '입출금',
      '퇴직연금', '펀드', '청약/채권', 'ISA',
      '외화예금', '보험', '신탁', '골드/실버',
    ],
  ),
  _Section(
    '조회',
    icon: Icons.search,
    iconBg: Color(0xFF17B26A),
    items: [
      _Item('전체계좌조회'),
      _Item('통합거래내역조회'),
      _Item('패밀리뱅킹', '부부 모임통장/노후자금, 우리아이 금융상품 관리'),
      _Item('휴면예금 · 보험금 찾기'),
      _Item('계좌관리', '비밀번호 관리, 계좌통합관리서비스(어카운트인포) 등'),
    ],
  ),
  _Section(
    '이체/출금',
    icon: Icons.arrow_forward,
    iconBg: Color(0xFF2E90FA),
    items: [
      _Item('이체'),
      _Item('이체결과조회(이체확인증)'),
      _Item('자동이체'),
      _Item('ATM/지점출금'),
      _Item('이체관리', '이체한도 조회/변경, 출금계좌등록/해제/등록방법변경 등'),
    ],
  ),
  // 과제 목표 섹션. 12개 중 4번째 — 참가자는 여기까지 탐색해야 한다.
  _Section(
    '공과금',
    icon: Icons.receipt_long,
    iconBg: Color(0xFF2FB79B),
    squareIcon: true,
    items: [
      _Item('공과금 납부/조회'),
      _Item('법원업무'),
      _Item('숨은 환급금 찾기'),
    ],
  ),
  _Section(
    '자산관리',
    icon: Icons.pie_chart,
    iconBg: Color(0xFFE85D75),
    items: [
      _Item('한번에', '총자산, 디지털PB, 금융일정, 또래비교'),
      _Item('지출', '가계부, 카드관리, 정기지출'),
      _Item('투자', '투자자산, 투자수익률, 투자체크, 케이봇쌤 포트폴리오'),
      _Item('연금/절세', '연금/절세자산, 연금수익률, 은퇴준비, 세금줄이기'),
      _Item('금융팁', '재테크·세무·부동산·상품 꿀팁'),
      _Item('마이데이터 설정'),
    ],
  ),
  _Section(
    '외환',
    icon: Icons.attach_money,
    iconBg: Color(0xFFF5A524),
    items: [
      _Item('환율'),
      _Item('환전'),
      _Item('해외송금'),
      _Item('국내외화 이체/입출금'),
      _Item('외환정보 관리'),
    ],
  ),
  _Section(
    '지갑',
    icon: Icons.credit_card,
    iconBg: Color(0xFF6BA6E8),
    squareIcon: true,
    items: [
      _Item('모바일 신분증', '주민등록증, 운전면허증, 국가보훈증, 외국인증'),
      _Item('결제', '계좌기반 간편결제, 스타포인트 사용 가능, KBPay'),
      _Item('NFT', '티켓도 디지털로! NFT에 안전보관'),
      _Item('공공알리미(국민비서 · 전자문서)'),
    ],
  ),
  _Section(
    '혜택',
    icon: Icons.card_giftcard,
    iconBg: Color(0xFFF67C7C),
    items: [
      _Item('이벤트'),
      _Item('매일 포인트 받기'),
      _Item('매일 용돈받기'),
      _Item('매일 걷기'),
      _Item('달리자'),
      _Item('퀴즈 풀기'),
      _Item('식물 키우기'),
      _Item('스타드림룰렛'),
      _Item('쿠폰함'),
    ],
  ),
  _Section(
    '생활',
    icon: Icons.add,
    iconBg: Color(0xFF7C5CFF),
    squareIcon: true,
    items: [
      _Item('국민오락실'),
      _Item('운세서비스'),
      _Item('휴양림 예약서비스'),
      _Item('기차표(KTX · SRT) 예매'),
      _Item('여권 재발급 신청'),
      _Item('스마트항공권'),
      _Item('티머니 교통카드 충전'),
      _Item('박물관 · 미술관 무료관람'),
      _Item('한국사 매일 퀴즈'),
      _Item('캠핑/글램핑'),
      _Item('청년정책/장학금 모아보기'),
    ],
  ),
  _Section(
    '모바일 업무지원',
    icon: Icons.phone_iphone,
    iconBg: Color(0xFF8AB4E8),
    squareIcon: true,
    items: [
      _Item('지점안내/번호표발행'),
      _Item('증명서 발급/제출', '정부24 전자증명서, 예금잔액증명서, 금융거래확인서 등'),
      _Item('통장/보안매체 재발급', '지점수령, STM수령, 등기우편수령'),
      _Item('전자영수증', '은행영수증, 구매영수증'),
      _Item('사고신고', '착오송금반환, 분실신고 등'),
    ],
  ),
  _Section(
    '멤버십',
    icon: Icons.star,
    iconBg: Color(0xFFF5B301),
    items: [
      _Item('KB스타클럽'),
      _Item('급여클럽'),
      _Item('KB Youth Club/밀리터리 클럽'),
    ],
  ),
  _Section(
    '테마별서비스',
    icon: Icons.description,
    iconBg: Color(0xFF8AB4E8),
    squareIcon: true,
    items: [
      _Item.inline('부동산', '내 관심 부동산, 분양정보, 시세간편조회'),
      _Item.inline('자동차', '내차팔기, 중고차매물, 차량 시세조회'),
      _Item.inline('여행', '해외여행보험, 여행예약, 해외결제'),
      _Item.inline('통신', '요금제 가입, 나의 통신 이용현황, 리브모바일'),
      _Item.inline('주식', '증권계좌개설, 주식매매, 공모주'),
      _Item.inline('카드', '카드만들기, 이용내역조회, 결제예정금액'),
      _Item.inline('보험', '보험 가입, 보장분석진단, 보험금 청구'),
      _Item.inline('대출', '내게 맞는 대출 찾기, 대출 갈아타기'),
      _Item.inline('기부', '고향사랑기부'),
    ],
  ),
  _Section(
    '사업자',
    icon: Icons.work,
    iconBg: Color(0xFF9C6B4A),
    squareIcon: true,
    items: [
      _Item('사장님+'),
      _Item('사업자 금융상품'),
      _Item('사장님을 위한 서비스'),
    ],
  ),
];

final _chipTitles = [
  for (final s in _sections)
    if (s.hasChip) s.title,
];
