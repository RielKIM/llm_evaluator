import 'package:flutter/material.dart';

class MetricListScreen extends StatefulWidget {
  const MetricListScreen({Key? key}) : super(key: key);

  @override
  State<MetricListScreen> createState() => _MetricListScreenState();
}

class _MetricListScreenState extends State<MetricListScreen> {
  // 더미 지표 목록
  final List<Map<String, dynamic>> _metrics = [
    {
      'id': 1,
      'name': '정확도(Accuracy)',
      'desc': '정답 비율',
      'type': '정량',
    },
    {
      'id': 2,
      'name': 'BLEU',
      'desc': '기계번역 품질 지표',
      'type': '정량',
    },
    {
      'id': 3,
      'name': '주관적 평가',
      'desc': '사람이 직접 평가',
      'type': '정성',
    },
  ];

  int? _selectedIndex;

  void _showAddMetricDialog() {
    String name = '';
    String desc = '';
    String type = '정량';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지표 추가'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '이름'),
                onChanged: (v) => name = v,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '설명'),
                onChanged: (v) => desc = v,
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: '정량', child: Text('정량')),
                  DropdownMenuItem(value: '정성', child: Text('정성')),
                ],
                onChanged: (v) => type = v ?? '정량',
                decoration: const InputDecoration(labelText: '타입'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 실제 추가 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('지표 추가 기능 준비중')),
              );
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showEditMetricDialog(Map<String, dynamic> metric) {
    String name = metric['name'];
    String desc = metric['desc'];
    String type = metric['type'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지표 편집'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '이름'),
                controller: TextEditingController(text: name),
                onChanged: (v) => name = v,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '설명'),
                controller: TextEditingController(text: desc),
                onChanged: (v) => desc = v,
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: '정량', child: Text('정량')),
                  DropdownMenuItem(value: '정성', child: Text('정성')),
                ],
                onChanged: (v) => type = v ?? '정량',
                decoration: const InputDecoration(labelText: '타입'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 실제 편집 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('편집 기능 준비중')),
              );
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // 왼쪽: 리스트
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '지표 목록',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('지표 추가'),
                      onPressed: _showAddMetricDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: _metrics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final metric = _metrics[idx];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          title: Text(metric['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text('${metric['desc']} (${metric['type']})'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: '편집',
                                onPressed: () => _showEditMetricDialog(metric),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                tooltip: '삭제',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('삭제 기능 준비중')),
                                  );
                                },
                              ),
                            ],
                          ),
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
                ? const Center(child: Text('지표를 선택하세요', style: TextStyle(fontSize: 20, color: Colors.grey)))
                : _buildDetailPanel(_metrics[_selectedIndex!]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(Map<String, dynamic> metric) {
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
                Text(metric['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: '편집',
                  onPressed: () => _showEditMetricDialog(metric),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '삭제',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('삭제 기능 준비중')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(metric['desc'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('타입: ${metric['type']}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 