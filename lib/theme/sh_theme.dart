import 'package:flutter/material.dart';

/// 신한 SOL뱅킹 재현용 디자인 토큰.
/// ⚠️ 현재 값은 아직 KB 시절 값이다(도메인 전환 중). 신한 홈 캡처 기준으로 교체 예정.
///   - bg: 신한 홈은 흰색/연회색 계열 (KB 라벤더 아님)
///   - 신한 주색은 파랑 → `yellow` 필드는 신한 화면 제작 시 정리
/// 모든 화면이 이 값을 공유하도록 하여 색·간격 일관성 유지.
class ShColors {
  static const bg = Color(0xFFE9EDF6); // 임시(KB 라벤더) — 신한은 흰색/연회색
  static const yellow = Color(0xFFFFCC00); // 임시(KB 노랑) — 신한 확정 시 교체
  static const dark = Color(0xFF1C1C1E);
  static const gray = Color(0xFF7A7A7F);
  static const card = Colors.white;
  static const badge = Color(0xFFECEEF2);
  static const darkBar = Color(0xFF4B4B52);
  static const devBar = Color(0xFF44474D);
  static const line = Color(0xFFCFD4DE);
  static const green = Color(0xFF16A34A);
}

/// 신한 SOL뱅킹 팔레트 (캡처 근사 · 신한 화면 공용).
/// A1 일반 홈·A2 쉬운홈이 공유. 아이콘/캐릭터 세부는 v6 §4.5 근사 허용.
class ShPalette {
  static const page = Color(0xFFF4F5F7); // 페이지 배경(연회색)
  static const primary = Color(0xFF2A6BF2); // 신한 파랑 (버튼 텍스트·강조)
  static const pale = Color(0xFFEAF0FF); // 파랑 옅은 버튼 배경
  static const promoFrom = Color(0xFF3D7BF5); // 파란 프로모 그라디언트
  static const promoTo = Color(0xFF5B95F7);
}

/// 자주 쓰는 텍스트 스타일.
class ShText {
  static const name = TextStyle(fontSize: 22, fontWeight: FontWeight.w800);
  static const balance = TextStyle(fontSize: 27, fontWeight: FontWeight.w800);
  static const cardTitle = TextStyle(fontSize: 19, fontWeight: FontWeight.w800);
  static const button = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const body = TextStyle(fontSize: 16, color: ShColors.dark);
  static const sub = TextStyle(fontSize: 14, color: ShColors.gray);
}

/// 공통 간격.
class ShGap {
  static const screenPad = EdgeInsets.symmetric(horizontal: 20);
}
