import 'package:flutter/material.dart';

import '../widgets/sh_common.dart';
import 'a1_bill_pay_info.dart';

/// 공과금 납부 ①: 고지서 촬영(OCR) — 카메라 모크
/// 근거: docs/screenshots/03_공과금납부/납부하기/0~2.png
///
/// 실제 앱은 지로/고지서를 카메라로 촬영해 OCR한다. 더미에선 촬영 화면만
/// 재현하고, 셔터를 누르면 납부정보로 진행한다(§4.5 근사).
class A1BillPayCamera extends StatelessWidget {
  const A1BillPayCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: Column(
        children: [
          const ShDevBar(label: '공과금 · 고지서 촬영(모크) · 더미'),
          Expanded(
            child: Stack(
              children: [
                // 촬영 안내
                Positioned(
                  left: 24,
                  right: 24,
                  top: 60,
                  child: Column(
                    children: const [
                      Text('지로번호가 잘 보이게\n준비해주세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 1.35)),
                    ],
                  ),
                ),
                // 촬영 프레임
                Center(
                  child: Container(
                    width: 300,
                    height: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white70, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text('고지서를 사각형에 맞춰\n촬영해주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 16, height: 1.4)),
                  ),
                ),
                // 하단 셔터(촬영 → 납부정보)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 40,
                  child: Center(
                    child: GestureDetector(
                      key: const ValueKey('billShutter'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const A1BillPayInfo()),
                      ),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFB8BDC7), width: 4),
                        ),
                      ),
                    ),
                  ),
                ),
                // 닫기
                Positioned(
                  right: 24,
                  bottom: 63,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.close, size: 30, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
