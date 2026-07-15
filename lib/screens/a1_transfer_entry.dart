import 'package:flutter/material.dart';

import '../data/kb_dummy.dart';
import '../theme/kb_theme.dart';
import '../widgets/kb_common.dart';
import 'a1_transfer_amount.dart';

/// A1 · 이체 (진입 — 받는 사람 선택)
/// 근거: docs/screenshots/a1/transfer/기본_이체(1).png
///
/// 계좌번호 직접 입력 또는 하단 시트의 [최근] 목록에서 선택.
/// 과제 경로: 최근 목록의 더미 상대를 탭 → 금액 입력.
class A1TransferEntry extends StatelessWidget {
  const A1TransferEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const KbDevBar(label: 'A1 · 이체 · 더미'),
          const KbStatusBar(),
          const KbAppBar(title: '이체'),
          _head(context),
          Expanded(child: _sheet(context)),
        ],
      ),
    );
  }

  Widget _head(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('누구에게 보낼까요?',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              OutOfScope(
                label: '여러 건 이체',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: KbColors.line),
                  ),
                  child: const Text('여러 건 이체', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          OutOfScope(
            label: '계좌번호 직접 입력',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('계좌번호',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9A9EA6))),
                const SizedBox(height: 8),
                Container(height: 1.6, color: const Color(0xFF8B7A55)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutOfScope(
                label: '촬영이체',
                child: Row(
                  children: const [
                    Icon(Icons.photo_camera_outlined, size: 24, color: Color(0xFF4A4A4F)),
                    SizedBox(width: 7),
                    Text('촬영이체', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('|', style: TextStyle(color: Color(0xFFCFD4DE))),
              ),
              OutOfScope(
                label: '연락처이체',
                child: Row(
                  children: const [
                    Icon(Icons.person_outline, size: 24, color: Color(0xFF4A4A4F)),
                    SizedBox(width: 7),
                    Text('연락처이체', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 하단 시트: 최근 / 자주쓰는 / 빠른 / 내계좌 ----
  Widget _sheet(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Color(0x11000000), blurRadius: 14, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabs(context),
          _listEdit(context),
          _payeeRow(context),
        ],
      ),
    );
  }

  Widget _tabs(BuildContext context) {
    Widget tab(String label, {bool active = false}) {
      final text = Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          color: active ? KbColors.dark : const Color(0xFF9A9EA6),
        ),
      );
      return Padding(
        padding: const EdgeInsets.only(right: 26),
        child: active
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  text,
                  const SizedBox(height: 8),
                  Container(width: 44, height: 3, color: KbColors.dark),
                ],
              )
            : OutOfScope(label: label, child: text),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Row(
        children: [
          tab('최근', active: true),
          tab('자주쓰는'),
          tab('빠른'),
          tab('내계좌'),
          const Spacer(),
          OutOfScope(
            label: '검색',
            child: const Icon(Icons.search, size: 26, color: KbColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _listEdit(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutOfScope(
            label: '목록편집',
            child: Row(
              children: const [
                Icon(Icons.edit_outlined, size: 20, color: Color(0xFF6A6A6F)),
                SizedBox(width: 6),
                Text('목록편집',
                    style: TextStyle(fontSize: 17, color: Color(0xFF4A4A4F))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 과제 경로: 이 행을 탭하면 금액 입력으로 넘어간다.
  Widget _payeeRow(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const A1TransferAmount()),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEDEEF1))),
        ),
        child: Row(
          children: [
            // 타행 로고 자리 — 실제 앱은 은행 CI. 더미에서는 이니셜 원으로 대체.
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF0046FF),
                shape: BoxShape.circle,
              ),
              child: const Text('신한',
                  style: TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(KbDummy.payeeName,
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  const Text(
                      '${KbDummy.payeeBank} ${KbDummy.payeeAccountNo}',
                      style: TextStyle(fontSize: 18, color: Color(0xFF8A8A8F))),
                ],
              ),
            ),
            OutOfScope(
              label: '즐겨찾기',
              child: const Icon(Icons.star_border, size: 26, color: Color(0xFF9A9EA6)),
            ),
          ],
        ),
      ),
    );
  }
}
