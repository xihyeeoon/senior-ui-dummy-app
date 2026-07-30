import 'package:flutter/material.dart';

import '../data/sh_bank_data.dart';
import '../theme/sh_theme.dart';

/// 조건(A1/A2) 홈 라우트 이름. 랜딩에서 홈을 push할 때 부여한다(main.dart).
const kConditionHomeRoute = 'condition-home';

/// 신한 스타일 오류 팝업 (에러코드 + 안내 + 파란 [확인]).
/// 근거: 이체 확인 화면의 ETA00325/ELB00016 다이얼로그.
void showShErrorDialog(BuildContext context,
    {required String code, required String message}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(code,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE0433B))),
            const SizedBox(height: 12),
            Text(message,
                style: const TextStyle(fontSize: 18, height: 1.4, color: ShColors.dark)),
            const SizedBox(height: 22),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(ctx).pop(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 17),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B64F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('확인',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// 이체 완료/닫기 시 랜딩(첫 화면)이 아니라 시작한 조건 홈으로 되돌린다.
/// 홈 라우트를 못 찾으면 첫 화면까지만 pop(안전장치).
void popToConditionHome(BuildContext context) {
  Navigator.of(context)
      .popUntil((r) => r.settings.name == kConditionHomeRoute || r.isFirst);
}

/// 실험 범위 밖 탭 처리.
/// 참가자가 과제와 무관한 요소를 눌러도 앱이 안 깨지게 가벼운 피드백만 준다.
/// (실제 실험 빌드에서는 조용한 no-op으로 바꿀 수 있음.)
void showOutOfScope(BuildContext context, [String? label]) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          label == null ? '실험 범위에 포함되지 않은 기능입니다.' : '"$label" — 실험 범위 밖',
        ),
        duration: const Duration(milliseconds: 1100),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

/// 안 만든 요소를 감싸 범위 밖 피드백을 주는 헬퍼.
class OutOfScope extends StatelessWidget {
  final Widget child;
  final String? label;
  const OutOfScope({super.key, required this.child, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showOutOfScope(context, label),
      child: child,
    );
  }
}

/// 상단 상태바 (4:31 / 신호 / 배터리) — 재현용.
class ShStatusBar extends StatelessWidget {
  const ShStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// 개발용 상단 바 (뒤로가기 + 라벨). 실제 실험 빌드에서는 제거.
class ShDevBar extends StatelessWidget {
  final String label;
  const ShDevBar({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ShColors.devBar,
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
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// KB 내부 화면 공통 앱바: `‹ 제목            🏠 ☰`
/// 근거: 공과금 납부/조회·촬영납부·전기요금 납부 화면 캡처에서 동일 패턴.
class ShAppBar extends StatelessWidget {
  final String title;
  const ShAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.arrow_back_ios_new, size: 22, color: ShColors.dark),
            ),
          ),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          ),
          OutOfScope(
            label: '홈',
            child: const Icon(Icons.home_outlined, size: 27, color: ShColors.dark),
          ),
          const SizedBox(width: 16),
          OutOfScope(
            label: '메뉴',
            child: const Icon(Icons.menu, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }
}

/// 은행 로고 자리 — 실제 앱은 각 은행 CI. 더미에서는 은행별 색 원 + 이니셜로
/// 근사한다(v6 §4.5 아이콘 근사 허용). 이체 목록·확인 화면 공용.
class ShBankMark extends StatelessWidget {
  final String bank;
  final double size;
  const ShBankMark(this.bank, {super.key, this.size = 44});

  static const _map = {
    '카카오뱅크': [Color(0xFFFFE300), Color(0xFF2B2B2B), '카'],
    '신한': [Color(0xFF0046D6), Colors.white, '신'],
    '신한투자증권': [Color(0xFF0046D6), Colors.white, '신'],
    '제주': [Color(0xFF0046D6), Colors.white, '제'],
    '농협': [Color(0xFF1F8B3F), Colors.white, 'N'],
    '토스뱅크': [Color(0xFF3182F6), Colors.white, 'T'],
    '토스증권': [Color(0xFF3182F6), Colors.white, 'T'],
    '국민': [Color(0xFF6A5B3E), Color(0xFFFFCC00), 'K'],
    'KB국민': [Color(0xFFFFCC00), Color(0xFF2B2B2B), 'K'],
    'KB증권': [Color(0xFF6A5B3E), Color(0xFFFFCC00), 'K'],
  };

  /// 미매핑 은행은 이름 해시로 색을 결정(그리드가 밋밋해지지 않게).
  static const _palette = [
    Color(0xFF2A6BF2), Color(0xFF1F8B3F), Color(0xFFE8506B), Color(0xFF6A5AE0),
    Color(0xFFE8802B), Color(0xFF2FA7A0), Color(0xFFB8455F), Color(0xFF3B6FB0),
  ];

  /// 로고 에셋 개수(은행목록 38개 전부; 관세=국고금과 동일 태극 아이콘 b37).
  /// 파일명은 웹 URL 인코딩 문제를 피하려 ASCII 인덱스(b0.png…b37.png)로 둔다.
  static const _logoCount = 38;

  @override
  Widget build(BuildContext context) {
    // 실제 로고가 있으면 사용(A1 충실도↑). 없으면 색원 근사.
    // 은행: b0..b36(관세 제외), 증권사: s0..s28.
    final bIdx = ShBankData.banks.indexOf(bank);
    if (bIdx >= 0 && bIdx < _logoCount) return _asset('b$bIdx');
    final sIdx = ShBankData.brokers.indexOf(bank);
    if (sIdx >= 0) return _asset('s$sIdx');
    return _circle();
  }

  Widget _asset(String name) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/bank_logos/$name.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => _circle()),
    );
  }

  Widget _circle() {
    final spec = _map[bank];
    final hash = bank.codeUnits.fold<int>(0, (a, b) => a + b);
    final bg = (spec?[0] as Color?) ?? _palette[hash % _palette.length];
    final fg = (spec?[1] as Color?) ?? Colors.white;
    final label = (spec?[2] as String?) ?? (bank.isNotEmpty ? bank[0] : '·');
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: size * 0.42, fontWeight: FontWeight.w800)),
    );
  }
}

/// KB 스타일 큰 버튼 (노랑=주요 / 회색=보조).
class ShButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const ShButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? ShColors.yellow : ShColors.badge,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: ShText.button.copyWith(
            color: primary ? ShColors.dark : const Color(0xFF3A3A3E),
          ),
        ),
      ),
    );
  }
}
