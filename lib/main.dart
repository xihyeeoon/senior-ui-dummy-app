import 'package:flutter/material.dart';

import 'screens/a1_home.dart';
import 'screens/a2_home.dart';
import 'widgets/sh_common.dart';

void main() => runApp(const DummyApp());

/// 고령자 UI 연구 — 실험용 더미 앱 (A1/A2/C 클릭 목업)
class DummyApp extends StatelessWidget {
  const DummyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '고령자 UI 연구 목업',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const LandingPage(),
    );
  }
}

/// 개발용 진입 화면: 조건(A1/A2/C) 선택.
/// 실제 실험에서는 참가자를 특정 조건 화면으로 바로 진입시킨다.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF0F3),
      appBar: AppBar(
        title: const Text('실험용 더미 앱 · 조건 선택 (개발용)'),
        titleTextStyle: const TextStyle(color: Color(0xFF44474D), fontSize: 15),
        backgroundColor: const Color(0xFFEEF0F3),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _conditionCard(
            context,
            tag: 'A1',
            title: '원본 재현 · 신한 일반 홈',
            desc: '신한 SOL뱅킹 일반 홈 충실 재현 (바닥 baseline)',
            page: const A1Home(),
          ),
          _conditionCard(
            context,
            tag: 'A2',
            title: '쉬운홈(고령자 모드)',
            desc: '신한 쉬운홈 = 배포된 고령자 모드 (배포 현실 baseline · 구현 전)',
            page: const A2Home(),
          ),
          _conditionCard(
            context,
            tag: 'C',
            title: '도구 재설계',
            desc: '엔진이 생성한 재설계안 프로토타입 (처치)',
            page: const _Placeholder(title: 'C · 도구 재설계'),
          ),
        ],
      ),
    );
  }

  Widget _conditionCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String desc,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
            // 조건 홈 라우트에 이름을 붙여, 이체 완료/닫기 시 랜딩이 아니라
            // 이 홈으로 돌아오게 한다([popToConditionHome]).
            settings: const RouteSettings(name: kConditionHomeRoute),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF44474D),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6A6A6F),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9A9A9F)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text('아직 구현 전', style: TextStyle(color: Colors.grey, fontSize: 16)),
      ),
    );
  }
}
