import 'package:flutter/material.dart';

import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import 'a1_bill_input.dart';

/// A1 · 공과금 납부/조회 (메인)
/// 근거: docs/screenshots/a1/02_bill_type/기본_공과금-메인(1~2).png
///
/// 전체메뉴 > 공과금 > 공과금 납부/조회 로 진입하는 화면.
/// '공과금 종류 선택'은 별도 화면이 아니라 이 화면의 [세금]/[생활공과금] 그리드다.
///
/// 개인정보: 캡처의 실명은 더미(홍길동님)로 치환 (연구 원칙: 실거래·실제 금융정보 0).
class A1BillMain extends StatelessWidget {
  const A1BillMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: 'A1 · 공과금 납부/조회 · 더미'),
          const ShStatusBar(),
          const ShAppBar(title: '공과금 납부/조회'),
          _tabs(context),
          Expanded(
            child: ListView(
              key: const ValueKey('billMainList'),
              padding: EdgeInsets.zero,
              children: [
                _taxSummary(context),
                _grid(context, '세금', _taxItems),
                _grid(context, '생활공과금', _lifeItems, trailing: '자주쓰는 지로관리'),
                _cameraButton(context),
                _autoButtons(context),
                _banner(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- [납부하기] | [납부 내역 조회] ----
  Widget _tabs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBEF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text('납부하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
          Expanded(
            child: OutOfScope(
              label: '납부 내역 조회',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                child: const Text('납부 내역 조회',
                    style: TextStyle(fontSize: 18, color: Color(0xFF6A6A6F))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- 납부할 세금 요약 (국세/지방세 조회) ----
  Widget _taxSummary(BuildContext context) {
    Widget row(String label) => OutOfScope(
          label: '$label 조회',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w600)),
                ),
                const Text('조회',
                    style: TextStyle(fontSize: 17, color: Color(0xFF9A9A9F))),
                const Icon(Icons.chevron_right, size: 22, color: Color(0xFF9A9A9F)),
              ],
            ),
          ),
        );

    return Container(
      color: const Color(0xFFF5F6F8),
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('홍길동님, 납부할 세금을 확인해보세요',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('2026.07.16. 00:34 기준',
              style: TextStyle(fontSize: 16, color: Color(0xFF8A8A8F))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                row('국세'),
                row('지방세'),
                const Divider(height: 1, color: Color(0xFFEDEEF1)),
                OutOfScope(
                  label: '더보기',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('더보기',
                            style: TextStyle(fontSize: 17, color: Color(0xFF6A6A6F))),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            size: 22, color: Color(0xFF9A9A9F)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.info, size: 20, color: Color(0xFF9A9A9F)),
              SizedBox(width: 8),
              Expanded(
                child: Text('주민등록번호 기준으로 조회되는 내역만 보여드려요.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6A6A6F))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 세금 / 생활공과금 그리드 (2열) ----
  Widget _grid(BuildContext context, String title, List<_Bill> items,
      {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              if (trailing != null)
                OutOfScope(
                  label: trailing,
                  child: Row(
                    children: [
                      Text(trailing,
                          style: const TextStyle(
                              fontSize: 17, color: Color(0xFF8A8A8F))),
                      const Icon(Icons.chevron_right,
                          size: 20, color: Color(0xFF9A9A9F)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3.5,
            children: [for (final b in items) _tile(context, b)],
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, _Bill b) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 과제 경로: 생활공과금 > 전기/TV 만 실제 화면으로 연결.
        // 나머지 종류는 캡처가 없어 추측 재현을 하지 않는다.
        if (b.label == '전기/TV') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const A1BillInput()),
          );
          return;
        }
        showOutOfScope(context, b.label);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: b.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(b.icon, size: 24, color: b.fg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(b.label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 고지서 촬영으로 간편 납부 ----
  Widget _cameraButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: OutOfScope(
        label: '고지서 촬영으로 간편 납부',
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 17),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ShColors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.crop_free, size: 22, color: Color(0xFF4A4A4F)),
              SizedBox(width: 8),
              Text('고지서 촬영으로 간편 납부', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _autoButtons(BuildContext context) {
    Widget btn(String label) => Expanded(
          child: OutOfScope(
            label: label,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 17),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ShColors.line),
              ),
              child: Text(label, style: const TextStyle(fontSize: 18)),
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          btn('자동납부'),
          const SizedBox(width: 12),
          btn('예약납부'),
        ],
      ),
    );
  }

  Widget _banner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: OutOfScope(
        label: '지방세·세외수입 알림',
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('자동차세, 재산세 등',
                        style: TextStyle(fontSize: 16, color: Color(0xFF7A8A86))),
                    SizedBox(height: 4),
                    Text('지방세·세외수입 알림 받으세요',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF2FB79B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('TAX',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- 데이터 (캡처 기준) ----

class _Bill {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  const _Bill(this.label, this.icon, this.bg, this.fg);
}

const _taxItems = <_Bill>[
  _Bill('국세', Icons.description, Color(0xFFEDF1F7), Color(0xFF4A6FA5)),
  _Bill('지방세', Icons.receipt_long, Color(0xFFE6F5F1), Color(0xFF2FB79B)),
  _Bill('관세', Icons.paid, Color(0xFFEDF1F7), Color(0xFF4A6FA5)),
  _Bill('기금/국고', Icons.savings, Color(0xFFEAF0FA), Color(0xFF5B8DEF)),
  _Bill('세외수입', Icons.account_balance_wallet, Color(0xFFE9F5EC), Color(0xFF3FA65C)),
  _Bill('환경개선부담금', Icons.eco, Color(0xFFE9F5EC), Color(0xFF3FA65C)),
  _Bill('교통범칙금', Icons.directions_car, Color(0xFFEAF0FA), Color(0xFF5B8DEF)),
  _Bill('검찰청벌과금', Icons.gavel, Color(0xFFEDF1F7), Color(0xFF6A7A95)),
  _Bill('4대보험료', Icons.work, Color(0xFFF3EDE7), Color(0xFF9C6B4A)),
];

const _lifeItems = <_Bill>[
  _Bill('지로', Icons.subject, Color(0xFFEDF1F7), Color(0xFF6A7A95)),
  _Bill('KT통신', Icons.smartphone, Color(0xFFEDF1F7), Color(0xFF4A6FA5)),
  // 과제 경로 — 유일하게 실제 입력 화면 캡처가 있는 종류.
  _Bill('전기/TV', Icons.bolt, Color(0xFFFFF6DE), Color(0xFFF5B301)),
  _Bill('상하수도', Icons.water_drop, Color(0xFFEAF4FD), Color(0xFF3B9EE0)),
  _Bill('관리비', Icons.apartment, Color(0xFFEEEDFB), Color(0xFF7C7BE8)),
  _Bill('등록금', Icons.school, Color(0xFFEAF0FA), Color(0xFF4A6FA5)),
];
