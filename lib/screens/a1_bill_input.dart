import 'package:flutter/material.dart';

import '../theme/sh_theme.dart';
import '../widgets/sh_common.dart';
import '../widgets/sh_number_keypad.dart';

/// A1 · 전기요금/TV수신료 납부 — 전자납부번호 입력
/// 근거: docs/screenshots/a1/02_bill_type/기본_공과금-세부(1).png
///
/// 공과금 납부/조회 > 생활공과금 > 전기/TV 로 진입하는 화면.
///
/// [미확인 — 캡처 대기]
/// 1. 입력란을 탭했을 때 뜨는 키패드를 직접 캡처하지 못했다(캡처는 키패드가 닫힌 상태만).
///    다만 같은 성격의 숫자 입력인 이체 금액 화면(transfer/기본_이체(2).png)이
///    **배열이 고정된 일반 키패드**를 쓰므로 [ShNumberKeypad]를 채택한다.
///    전자납부번호는 비밀번호가 아니라 보안 키패드(숫자 섞임)를 쓸 이유가 없다.
///    → 근거는 있으나 이 화면 자체의 캡처는 아니므로 확인 시 정정할 것.
/// 2. [조회] 버튼의 **활성** 상태 색을 알 수 없다(캡처는 비활성만). KB 주색인 노랑으로 둔다.
/// 3. [조회] 이후 화면(내역 확인 → 인증 → 완료)은 실제 고지서가 없어 캡처하지 못했다.
///    추측 재현을 하지 않고, 누르면 안내만 띄운다.
class A1BillInput extends StatefulWidget {
  const A1BillInput({super.key});

  @override
  State<A1BillInput> createState() => _A1BillInputState();
}

class _A1BillInputState extends State<A1BillInput> {
  static const _maxLen = 10; // 캡처: "숫자 10자리"

  String _value = '';
  bool _keypadOpen = false;

  bool get _canQuery => _value.length == _maxLen;

  void _onDigit(String d) {
    // '00' 키가 있어 길이를 넘길 수 있으므로 입력 길이까지 함께 본다.
    if (_value.length + d.length > _maxLen) return;
    setState(() => _value += d);
  }

  void _onDelete() {
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ShDevBar(label: 'A1 · 전기요금/TV수신료 납부 · 더미'),
          const ShStatusBar(),
          const ShAppBar(title: '전기요금/TV수신료 납부'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              children: [
                _field(),
                const SizedBox(height: 22),
                _queryButton(),
                const SizedBox(height: 30),
                _notice(),
              ],
            ),
          ),
          if (_keypadOpen)
            ShNumberKeypad(onDigit: _onDigit, onDelete: _onDelete),
        ],
      ),
    );
  }

  // ---- 전자납부번호 입력란 (라벨 + 값 + 밑줄) ----
  Widget _field() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _keypadOpen = true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('전자납부번호',
              style: TextStyle(fontSize: 17, color: Color(0xFF8A8A8F))),
          const SizedBox(height: 10),
          Text(
            _value.isEmpty ? '숫자 10자리' : _value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: _value.isEmpty ? 0 : 1.5,
              color: _value.isEmpty ? const Color(0xFF9A9EA6) : ShColors.dark,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1.6, color: const Color(0xFF8B7A55)),
        ],
      ),
    );
  }

  // ---- [조회] ----
  Widget _queryButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _canQuery
          ? () => showOutOfScope(context, '조회 이후 화면은 아직 재현 전')
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 19),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _canQuery ? ShColors.yellow : const Color(0xFFE4E7EB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '조회',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: _canQuery ? ShColors.dark : const Color(0xFF9A9EA6),
          ),
        ),
      ),
    );
  }

  // ---- ⓘ 알려드립니다 ----
  Widget _notice() {
    Widget bullet(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8, right: 8),
                child: SizedBox(
                  width: 3,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color(0xFF6A6A6F), shape: BoxShape.circle),
                  ),
                ),
              ),
              Expanded(
                child: Text(text,
                    style: const TextStyle(fontSize: 17, height: 1.45)),
              ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Color(0xFF5A5A5F), shape: BoxShape.circle),
              child: const Text('i',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('알려드립니다',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            const Icon(Icons.keyboard_arrow_up, size: 26, color: Color(0xFF6A6A6F)),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFFEDEEF1)),
        const SizedBox(height: 16),
        bullet('지점에서 이미 납부한 내역은 이중납부 될 수 있으므로, 반드시 납부내역을 확인해 주십시오.'),
        bullet('납부 가능시간 : 00:30~23:30(토요일/공휴일 가능)'),
        bullet('금융결제원 시스템 점검시간인 매월 두번째 토요일 23:30 ~ 익일 07:00까지 거래불가'),
      ],
    );
  }
}
