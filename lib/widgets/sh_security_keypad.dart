import 'dart:math';

import 'package:flutter/material.dart';

/// 한국 은행앱 스타일 보안 키패드.
/// 숫자가 매번 뒤섞여 배치되고, 재배열·삭제 키를 가진다.
/// 납부번호·비밀번호 입력 화면에서 재사용.
///
/// 두 가지 룩을 지원한다(v6 §4.5 근사):
///  - 기본(어두운 회색, 칸 테두리, '삭제' 텍스트) — KB 계열
///  - 신한 계좌 비밀번호(파란 배경, 테두리 없음, 백스페이스 아이콘) → [ShSecurityKeypad.shinhan]
class ShSecurityKeypad extends StatefulWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onDelete;

  final Color background;
  final Color actionBackground;
  final Color textColor;
  final bool borders;
  final bool deleteAsIcon;

  const ShSecurityKeypad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.background = const Color(0xFF2B2D31),
    this.actionBackground = const Color(0xFF23252A),
    this.textColor = Colors.white,
    this.borders = true,
    this.deleteAsIcon = false,
  });

  /// 신한 계좌 비밀번호 키패드(파란 배경).
  const ShSecurityKeypad.shinhan({
    super.key,
    required this.onDigit,
    required this.onDelete,
  })  : background = const Color(0xFF0F62FE),
        actionBackground = const Color(0xFF0F62FE),
        textColor = Colors.white,
        borders = false,
        deleteAsIcon = true;

  @override
  State<ShSecurityKeypad> createState() => _KbSecurityKeypadState();
}

class _KbSecurityKeypadState extends State<ShSecurityKeypad> {
  late List<String> _digits;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    final list = List.generate(10, (i) => i.toString());
    list.shuffle(Random());
    _digits = list;
  }

  @override
  Widget build(BuildContext context) {
    // 3열 x 4행: 숫자 10칸 + [재배열] + [삭제]
    final cells = <Widget>[];
    for (var i = 0; i < 9; i++) {
      cells.add(_digitCell(_digits[i]));
    }
    cells.add(_actionCell('재배열', () => setState(_shuffle)));
    cells.add(_digitCell(_digits[9]));
    cells.add(_actionCell('삭제', widget.onDelete, isDelete: true));

    return Container(
      color: widget.background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 72,
        ),
        itemCount: cells.length,
        itemBuilder: (_, i) => cells[i],
      ),
    );
  }

  BoxDecoration? get _cellBorder => widget.borders
      ? const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xFF3C3F45)),
            bottom: BorderSide(color: Color(0xFF3C3F45)),
          ),
        )
      : null;

  Widget _digitCell(String d) {
    return InkWell(
      onTap: () => widget.onDigit(d),
      child: Container(
        alignment: Alignment.center,
        decoration: _cellBorder,
        child: Text(
          d,
          style: TextStyle(
            color: widget.textColor,
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _actionCell(String label, VoidCallback onTap, {bool isDelete = false}) {
    Widget child;
    if (isDelete && widget.deleteAsIcon) {
      child = Icon(Icons.backspace_outlined, color: widget.textColor, size: 26);
    } else {
      child = Text(
        label,
        style: TextStyle(color: widget.textColor.withValues(alpha: 0.85), fontSize: 17),
      );
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        color: widget.borders ? widget.actionBackground : null,
        decoration: widget.borders ? null : _cellBorder,
        child: child,
      ),
    );
  }
}
