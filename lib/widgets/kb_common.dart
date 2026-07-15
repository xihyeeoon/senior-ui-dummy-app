import 'package:flutter/material.dart';

import '../theme/kb_theme.dart';

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
class KbStatusBar extends StatelessWidget {
  const KbStatusBar({super.key});

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
class KbDevBar extends StatelessWidget {
  final String label;
  const KbDevBar({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: KbColors.devBar,
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

/// KB 스타일 큰 버튼 (노랑=주요 / 회색=보조).
class KbButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const KbButton({
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
          color: primary ? KbColors.yellow : KbColors.badge,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: KbText.button.copyWith(
            color: primary ? KbColors.dark : const Color(0xFF3A3A3E),
          ),
        ),
      ),
    );
  }
}
