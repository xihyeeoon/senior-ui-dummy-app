import 'package:flutter/material.dart';

import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_transfer_account.dart';

/// 신한 이체 ①-A: 받는 사람 선택 ("누구에게 보낼까요?")
/// 근거: docs/screenshots/04_이체/이체 버튼 클릭 시.png
///
/// 계좌번호 직접 입력(→ 키패드 입력 화면) + 자주쓰는/내/최근 계좌 섹션.
/// 연구용 더미: 자주쓰는·내·최근 계좌 목록은 모두 공란(0개)으로 비운다.
/// A1 일반 홈·A2 쉬운홈이 공유하는 이체 진입점.
class A1TransferEntry extends StatelessWidget {
  const A1TransferEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: '이체 · 신한 받는사람 선택 · 더미'),
          const ShStatusBar(),
          _topBar(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _title(),
                _directInput(context),
                const SizedBox(height: 8),
                _sectionHeader('자주쓰는 계좌', '0개', editable: true),
                _sectionHeader('내 계좌', '0개'),
                _sectionHeader('최근', '0개'),
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
            label: '다건이체',
            child: const Text('다건이체',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: ShPalette.primary)),
          ),
          const SizedBox(width: 18),
          OutOfScope(
            label: '받는 사람 관리',
            child: const Icon(Icons.person_add_alt, size: 26, color: ShColors.dark),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.close, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      child: Row(
        children: [
          const Expanded(
            child: Text('누구에게 보낼까요?',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
          ),
          OutOfScope(
            label: '검색',
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEFF3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.search, size: 24, color: Color(0xFF4A4A4F)),
            ),
          ),
        ],
      ),
    );
  }

  /// 계좌번호 직접 입력 → 키패드 입력 화면(Screen B).
  Widget _directInput(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const A1TransferAccount())),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE3E5EA))),
        ),
        child: Row(
          children: const [
            Expanded(
              child: Text('계좌번호 직접 입력',
                  style: TextStyle(fontSize: 21, color: Color(0xFF9A9EA6))),
            ),
            Icon(Icons.photo_camera_outlined, size: 26, color: Color(0xFF4A4A4F)),
          ],
        ),
      ),
    );
  }

  /// 접이식 섹션 헤더. 목록은 비어 있어 0개로 표시한다.
  Widget _sectionHeader(String label, String count, {bool editable = false}) {
    return OutOfScope(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            if (editable) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEFF3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('편집',
                    style: TextStyle(fontSize: 15, color: Color(0xFF6A6A6F))),
              ),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: ShColors.line),
              ),
              child: Row(
                children: [
                  Text(count, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 20, color: Color(0xFF6A6A6F)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
