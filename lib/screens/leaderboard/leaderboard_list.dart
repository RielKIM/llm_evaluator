import 'package:flutter/material.dart';

class LeaderboardListScreen extends StatefulWidget {
  const LeaderboardListScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardListScreen> createState() => _LeaderboardListScreenState();
}

class _LeaderboardListScreenState extends State<LeaderboardListScreen> {
  final List<Map<String, dynamic>> _leaderboard = [
    {'rank': 1, 'model': 'KoGPT-3', 'score': 92.1, 'desc': '한국어 GPT-3 기반 LLM'},
    {'rank': 2, 'model': 'HyperCLOVA', 'score': 90.7, 'desc': '네이버 초대규모 언어모델'},
    {'rank': 3, 'model': 'OpenKoLLM', 'score': 88.5, 'desc': '오픈소스 한국어 LLM'},
  ];

  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // 왼쪽: 랭킹 테이블
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '리더보드',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('새로고침'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('새로고침 기능 준비중')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: _leaderboard.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final row = _leaderboard[idx];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: _selectedIndex == idx ? Colors.deepPurple.shade50 : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Text(row['rank'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          title: Text(row['model'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('점수: ${row['score']}'),
                          onTap: () {
                            setState(() {
                              _selectedIndex = idx;
                            });
                          },
                          selected: _selectedIndex == idx,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // 오른쪽: 상세 정보
          Expanded(
            flex: 3,
            child: _selectedIndex == null
                ? const Center(child: Text('모델을 선택하세요', style: TextStyle(fontSize: 20, color: Colors.grey)))
                : _buildDetailPanel(_leaderboard[_selectedIndex!]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(Map<String, dynamic> row) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(row['model'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('순위: ${row['rank']}', style: const TextStyle(fontSize: 18, color: Colors.deepPurple)),
              ],
            ),
            const SizedBox(height: 16),
            Text(row['desc'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('점수: ${row['score']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('최근 평가 이력 (예시)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('2024-05-20: 92.1점\n2024-05-13: 91.8점\n2024-05-01: 90.5점'),
            ),
          ],
        ),
      ),
    );
  }
} 