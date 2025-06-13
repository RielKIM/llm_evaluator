import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/model.dart';
import '../../models/dataset.dart';
import '../../services/api_service.dart';

const Color kPrimary = Color(0xFF6366F1);
const Color kPrimaryDark = Color(0xFF8B5CF6);
const Color kBackground = Color(0xFFF9FAFB);
const Color kCardBg = Color(0xFFFFFFFF);
const Color kCardShadow = Color(0x1A000000); // 10% opacity
const Color kBorder = Color(0xFFE5E7EB);
const Color kCheckedBg = Color(0xFFEEF2FF);
const Color kLogBg = Color(0xFF1F2937);
const Color kLogSuccess = Color(0xFF10B981);
const Color kLogError = Color(0xFFEF4444);
const Color kLogNormal = Color(0xFFF9FAFB);
const Color kDisabled = Color(0xFF9CA3AF);

class EvaluationListScreen extends StatefulWidget {
  const EvaluationListScreen({Key? key}) : super(key: key);

  @override
  State<EvaluationListScreen> createState() => _EvaluationListScreenState();
}

class _EvaluationListScreenState extends State<EvaluationListScreen> {
  String? _selectedModelId;
  final Set<String> _selectedDatasetIds = {};
  double _progress = 0.0;
  bool _isEvaluating = false;
  final List<String> _logs = [];
  String _description = '';
  final ScrollController _logScrollController = ScrollController();

  // 더미 평가 목록
  final List<Map<String, dynamic>> _evaluations = [
    {
      'id': 1,
      'name': 'KoGPT-3 vs KoQuAD',
      'model': 'KoGPT-3',
      'dataset': 'KoQuAD v1.0',
      'date': '2024-05-20',
    },
    {
      'id': 2,
      'name': 'HyperCLOVA 감정분류',
      'model': 'HyperCLOVA',
      'dataset': 'AIHub 감정분류',
      'date': '2024-05-21',
    },
  ];

  int? _selectedIndex;

  void _startEvaluation() async {
    if (_selectedModelId == null || _selectedDatasetIds.isEmpty) return;
    setState(() {
      _isEvaluating = true;
      _progress = 0.0;
      _logs.clear();
    });
    final total = _selectedDatasetIds.length;
    int count = 0;
    for (final dsId in _selectedDatasetIds) {
      await Future.delayed(const Duration(seconds: 1)); // 더미 평가 시간
      setState(() {
        count++;
        _progress = count / total;
        _logs.add('[$count/$total] "${ApiService().getModels().firstWhere((m) => m.id == _selectedModelId!).name}" 모델로 "${ApiService().getDatasets().firstWhere((d) => d.id == dsId).name}" 평가셋 평가 완료');
      });
      // 자동 스크롤
      await Future.delayed(const Duration(milliseconds: 100));
      _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent);
    }
    setState(() {
      _isEvaluating = false;
      _logs.add('평가가 모두 완료되었습니다.');
    });
    await Future.delayed(const Duration(milliseconds: 100));
    _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent);
  }

  void _showRunEvaluationDialog() {
    String name = '';
    String model = '';
    String dataset = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('평가 실행'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '평가명'),
                onChanged: (v) => name = v,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '모델명'),
                onChanged: (v) => model = v,
              ),
              TextField(
                decoration: const InputDecoration(labelText: '데이터셋'),
                onChanged: (v) => dataset = v,
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
              // TODO: 실제 실행 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('평가 실행 기능 준비중')),
              );
            },
            child: const Text('실행'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(Map<String, dynamic> eval) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('평가 상세 - ${eval['name']}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('모델명: ${eval['model']}'),
              const SizedBox(height: 8),
              Text('데이터셋: ${eval['dataset']}'),
              const SizedBox(height: 8),
              Text('날짜: ${eval['date']}'),
              const SizedBox(height: 16),
              const Text('평가 결과: (예시) 89.2점', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final models = ApiService().getModels();
    final datasets = ApiService().getDatasets();
    final selectedDatasets = datasets.where((ds) => _selectedDatasetIds.contains(ds.id)).toList();
    final percent = (_isEvaluating && _selectedDatasetIds.isNotEmpty)
        ? (_progress * 100).toStringAsFixed(0) + '%'
        : '';
    final datasetIcons = {
      'KoNLP': '🔤',
      'QA': '❓',
      '감정': '😊',
      '뉴스': '📰',
      '챗봇': '💬',
      '의료': '🩺',
      '법률': '⚖️',
      'IT': '💻',
      'SNS': '💬',
      '일상': '🏠',
    };
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
                      '평가 목록',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('평가 실행'),
                      onPressed: _showRunEvaluationDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: _evaluations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final eval = _evaluations[idx];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          title: Text(eval['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text('모델: ${eval['model']}  |  데이터셋: ${eval['dataset']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(eval['date'], style: const TextStyle(color: Colors.grey)),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                tooltip: '상세',
                                onPressed: () => _showDetailDialog(eval),
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
                ? const Center(child: Text('평가를 선택하세요', style: TextStyle(fontSize: 20, color: Colors.grey)))
                : _buildDetailPanel(_evaluations[_selectedIndex!]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(Map<String, dynamic> eval) {
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
                Text(eval['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: '상세',
                  onPressed: () => _showDetailDialog(eval),
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
            Text('모델명: ${eval['model']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('데이터셋: ${eval['dataset']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('날짜: ${eval['date']}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 