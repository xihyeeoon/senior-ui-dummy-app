import 'package:flutter/material.dart';

import '../data/sh_bank_data.dart';
import '../theme/sh_theme.dart';
import 'sh_common.dart';

/// 이체 · "은행 또는 증권사 선택" 바텀시트.
/// 근거: docs/screenshots/04_이체/…_01~04.png
///
/// [은행]/[증권사] 탭 + 3열 로고 그리드. 항목 탭 → 선택한 이름을 pop으로 반환.
Future<String?> showShBankSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _ShBankSheet(),
  );
}

class _ShBankSheet extends StatefulWidget {
  const _ShBankSheet();

  @override
  State<_ShBankSheet> createState() => _ShBankSheetState();
}

class _ShBankSheetState extends State<_ShBankSheet> {
  bool _brokerTab = false;

  @override
  Widget build(BuildContext context) {
    final items = _brokerTab ? ShBankData.brokers : ShBankData.banks;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.86,
      child: Column(
        children: [
          _header(),
          _tabs(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.92,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _cell(items[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text('은행 또는 증권사 선택',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 27, color: ShColors.dark),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    Widget tab(String label, bool active, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: active ? ShColors.dark : const Color(0xFFE3E5EA),
                  width: active ? 2.4 : 1,
                ),
              ),
            ),
            child: Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  color: active ? ShColors.dark : const Color(0xFF9A9EA6),
                )),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('은행', !_brokerTab, () => setState(() => _brokerTab = false)),
        tab('증권사', _brokerTab, () => setState(() => _brokerTab = true)),
      ],
    );
  }

  Widget _cell(String name) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(name),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShBankMark(name, size: 52),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
