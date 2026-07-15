import 'dart:math';

import 'package:flutter/material.dart';

/// KB(및 한국 은행앱) 스타일 보안 키패드.
/// 숫자가 매번 뒤섞여 배치되고, 재배열·삭제 키를 가진다.
/// 납부번호·비밀번호 입력 화면에서 재사용.
///
/// 실제 KB 키패드 스크린샷을 받으면 배치·색을 더 정밀하게 맞출 예정.
class KbSecurityKeypad extends StatefulWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onDelete;

  const KbSecurityKeypad({
    super.key,
    required this.onDigit,
    required this.onDelete,
  });

  @override
  State<KbSecurityKeypad> createState() => _KbSecurityKeypadState();
}

class _KbSecurityKeypadState extends State<KbSecurityKeypad> {
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
    cells.add(_actionCell('삭제', widget.onDelete));

    return Container(
      color: const Color(0xFF2B2D31),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 60, // 행 높이 고정 → 넓은 화면에서도 안 깨짐
        ),
        itemCount: cells.length,
        itemBuilder: (_, i) => cells[i],
      ),
    );
  }

  Widget _digitCell(String d) {
    return InkWell(
      onTap: () => widget.onDigit(d),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xFF3C3F45)),
            bottom: BorderSide(color: Color(0xFF3C3F45)),
          ),
        ),
        child: Text(
          d,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _actionCell(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        color: const Color(0xFF23252A),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
    );
  }
}
