import 'package:flutter/material.dart';

/// A1 · KB스타뱅킹 홈 (원본 재현)
/// 레이아웃·색·텍스트·상호작용은 실제 앱을 충실히 재현.
/// 개인·금융정보(이름/계좌/잔액)는 더미로 치환 (연구 원칙: 실거래정보 0).
class A1KbHome extends StatelessWidget {
  const A1KbHome({super.key});

  static const Color _bg = Color(0xFFE9EDF6);
  static const Color _yellow = Color(0xFFFFCC00);
  static const Color _dark = Color(0xFF1C1C1E);
  static const Color _gray = Color(0xFF7A7A7F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _devBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statusBar(),
                  _header(),
                  _userRow(),
                  _accountCard(),
                  _repRow(),
                  _banner(),
                  _txnRow(),
                  const SizedBox(height: 8),
                  _darkBar(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  /// 개발용 상단 바 (실제 실험 빌드에서는 제거)
  Widget _devBar(BuildContext context) {
    return Material(
      color: const Color(0xFF44474D),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 34,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const Text(
                'A1 · 원본 재현 (계좌 데이터는 더미)',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 10, 22, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('4:31', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16),
              SizedBox(width: 4),
              Text('67', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('간편홈', style: TextStyle(fontSize: 17)),
              const SizedBox(width: 8),
              // ON 토글
              Container(
                width: 54,
                height: 28,
                decoration: BoxDecoration(
                  color: _yellow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 9,
                      top: 6,
                      child: Text(
                        'ON',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A5A00),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 3,
                      top: 3,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Text('알림', style: TextStyle(fontSize: 16, color: Color(0xFF2A2A2E))),
              SizedBox(width: 18),
              Text('상담', style: TextStyle(fontSize: 16, color: Color(0xFF2A2A2E))),
              SizedBox(width: 18),
              Text('검색', style: TextStyle(fontSize: 16, color: Color(0xFF2A2A2E))),
              SizedBox(width: 18),
              Text('메뉴', style: TextStyle(fontSize: 16, color: Color(0xFF2A2A2E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 아바타 + 체크
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
                        color: _yellow,
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
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: _bg, width: 2),
                        ),
                        child: const Icon(Icons.check, size: 9, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Text('홍길동님',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              const Text('›', style: TextStyle(fontSize: 18, color: _gray)),
            ],
          ),
          // 패밀리 배지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFCFD4DE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
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

  Widget _accountCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  color: Color(0xFF6B5B4A),
                  shape: BoxShape.circle,
                ),
                child: const Text('★',
                    style: TextStyle(
                        color: _yellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEEF2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('한도제한계좌',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF55585F),
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('KB마이핏통장',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              ),
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
              const Text('12,500원',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFCFD4DE)),
                ),
                child: const Text('숨김',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6F))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _cardButton('이체', _yellow, _dark)),
              const SizedBox(width: 12),
              Expanded(
                  child: _cardButton('전용화면', const Color(0xFFECEEF2),
                      const Color(0xFF3A3A3E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardButton(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _repRow() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, size: 18, color: Color(0xFF4A4A4F)),
              SizedBox(width: 8),
              Text('대표계좌 설정',
                  style: TextStyle(fontSize: 17, color: Color(0xFF4A4A4F))),
            ],
          ),
          const Positioned(
            right: 4,
            child: Text('1 / 4',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2A2A2E))),
          ),
        ],
      ),
    );
  }

  Widget _banner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
                Text('번호표 미리 뽑기',
                    style: TextStyle(fontSize: 14, color: _gray)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
        ],
      ),
    );
  }

  Widget _txnRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  color: Color(0xFFF5B301),
                  shape: BoxShape.circle,
                ),
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
                  color: const Color(0xFF4B4B52),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('매일 랜덤P',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _darkBar() {
    return Container(
      color: const Color(0xFF4B4B52),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: const Row(
        children: [
          Expanded(
            child: Center(
              child: Text('▢ KB Pay',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(
            height: 20,
            child: VerticalDivider(color: Color(0xFF6A6A72), width: 1),
          ),
          Expanded(
            child: Center(
              child: Text('🪪 국민지갑(신분증)',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(it.$1,
                    size: 24, color: active ? _dark : const Color(0xFF6A6A6F)),
                const SizedBox(height: 3),
                Text(it.$2,
                    style: TextStyle(
                        fontSize: 12,
                        color: active ? _dark : const Color(0xFF6A6A6F))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
