import 'package:flutter/material.dart';

class ModelListScreen extends StatefulWidget {
  const ModelListScreen({Key? key}) : super(key: key);

  @override
  State<ModelListScreen> createState() => _ModelListScreenState();
}

class _ModelListScreenState extends State<ModelListScreen> {
  // 더미 모델 목록
  final List<Map<String, dynamic>> _models = [
    {
      'id': 1,
      'name': 'KoGPT-3',
      'desc': '한국어 GPT-3 기반 LLM',
      'createdAt': '2024-05-01',
    },
    {
      'id': 2,
      'name': 'OpenKoLLM',
      'desc': '오픈소스 한국어 LLM',
      'createdAt': '2024-05-10',
    },
    {
      'id': 3,
      'name': 'HyperCLOVA',
      'desc': '네이버 초대규모 언어모델',
      'createdAt': '2024-05-15',
    },
  ];

  int? _selectedIndex;

  void _showAddModelDialog() {
    String name = '';
    String desc = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모델 추가'),
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
                const SnackBar(content: Text('모델 추가 기능 준비중')),
              );
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showEditModelDialog(Map<String, dynamic> model) {
    String name = model['name'];
    String desc = model['desc'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모델 편집'),
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
                      '모델 목록',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('모델 추가'),
                      onPressed: _showAddModelDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: _models.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final model = _models[idx];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          title: Text(model['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text(model['desc']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(model['createdAt'], style: const TextStyle(color: Colors.grey)),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: '편집',
                                onPressed: () => _showEditModelDialog(model),
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
                ? const Center(child: Text('모델을 선택하세요', style: TextStyle(fontSize: 20, color: Colors.grey)))
                : _buildDetailPanel(_models[_selectedIndex!]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(Map<String, dynamic> model) {
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
                Text(model['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: '편집',
                  onPressed: () => _showEditModelDialog(model),
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
            Text(model['desc'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('등록일: ${model['createdAt']}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 