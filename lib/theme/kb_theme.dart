import 'package:flutter/material.dart';

/// KB스타뱅킹 재현용 디자인 토큰.
/// 모든 화면이 이 값을 공유하도록 하여 색·간격 일관성 유지.
class KbColors {
  static const bg = Color(0xFFE9EDF6); // 연한 라벤더 배경
  static const yellow = Color(0xFFFFCC00); // KB 노랑
  static const dark = Color(0xFF1C1C1E);
  static const gray = Color(0xFF7A7A7F);
  static const card = Colors.white;
  static const badge = Color(0xFFECEEF2);
  static const darkBar = Color(0xFF4B4B52);
  static const devBar = Color(0xFF44474D);
  static const line = Color(0xFFCFD4DE);
  static const green = Color(0xFF16A34A);
}

/// 자주 쓰는 텍스트 스타일.
class KbText {
  static const name = TextStyle(fontSize: 22, fontWeight: FontWeight.w800);
  static const balance = TextStyle(fontSize: 27, fontWeight: FontWeight.w800);
  static const cardTitle = TextStyle(fontSize: 19, fontWeight: FontWeight.w800);
  static const button = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const body = TextStyle(fontSize: 16, color: KbColors.dark);
  static const sub = TextStyle(fontSize: 14, color: KbColors.gray);
}

/// 공통 간격.
class KbGap {
  static const screenPad = EdgeInsets.symmetric(horizontal: 20);
}
