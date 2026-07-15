import 'package:flutter/material.dart';

import '../theme/kb_theme.dart';

/// KB 일반 숫자 키패드 (배열 고정 · 섞이지 않음).
/// 근거: docs/screenshots/a1/transfer/기본_이체(2).png — 이체 금액 입력.
///
///   [전액] [100만] [10만] [5만] [1만]   ← quickAmounts (선택)
///     1     2     3
///     4     5     6
///     7     8     9
///    00     0     ←
///
/// 비밀번호가 아닌 숫자 입력(금액·전자납부번호)에 쓴다.
/// 숫자가 매번 섞이는 [KbSecurityKeypad]와 달리 배열이 고정이라
/// 고령자 입력 난이도가 크게 다르다 — 둘을 혼동하지 말 것.
class KbNumberKeypad extends StatelessWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onDelete;

  /// 이체 금액용 빠른 입력 칩. null이면 표시하지 않는다(공과금 등).
  final List<String>? quickAmounts;
  final void Function(String label)? onQuickAmount;

  /// 하단 노란 확정 버튼. null이면 표시하지 않는다.
  final String? confirmLabel;
  final VoidCallback? onConfirm;

  const KbNumberKeypad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.quickAmounts,
    this.onQuickAmount,
    this.confirmLabel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (quickAmounts != null) _quickRow(),
          _keys(),
          if (confirmLabel != null) _confirm(),
        ],
      ),
    );
  }

  Widget _quickRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final label in quickAmounts!)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onQuickAmount?.call(label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: KbColors.line),
                    ),
                    child: Text(label,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF3A3A3E))),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _keys() {
    // 캡처 배열: 1~9 / 00 · 0 · 삭제
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['00', '0', '←'],
    ];
    return Column(
      children: [
        for (final row in rows)
          Row(
            children: [
              for (final key in row)
                Expanded(
                  child: InkWell(
                    onTap: () => key == '←' ? onDelete() : onDigit(key),
                    child: SizedBox(
                      height: 62,
                      child: Center(
                        child: key == '←'
                            ? const Icon(Icons.arrow_back,
                                size: 26, color: KbColors.dark)
                            : Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                  color: KbColors.dark,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _confirm() {
    final enabled = onConfirm != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onConfirm,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        color: enabled ? KbColors.yellow : const Color(0xFFE4E7EB),
        child: Text(
          confirmLabel!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: enabled ? KbColors.dark : const Color(0xFF9A9EA6),
          ),
        ),
      ),
    );
  }
}
