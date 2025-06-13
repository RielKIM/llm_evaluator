import 'package:flutter/material.dart';
import '../../models/dataset.dart';
import '../../services/dataset_service.dart';

const kBg = Color(0xFFF8F9FA);
const kPrimary = Color(0xFF6B46C1);
const kPrimaryDark = Color(0xFF5A3AA8);
const kCard = Color(0xFFFFFFFF);
const kBorder = Color(0xFFE0E0E0);
const kText = Color(0xFF333333);
const kSubText = Color(0xFF6C757D);
const kDanger = Color(0xFFDC3545);
const kMetaBg = Color(0xFFF8F9FA);

class DatasetListScreen extends StatefulWidget {
  const DatasetListScreen({Key? key}) : super(key: key);

  @override
  State<DatasetListScreen> createState() => _DatasetListScreenState();
}

class _DatasetListScreenState extends State<DatasetListScreen> {
  int? _selectedIndex;
  bool _showAddEditModal = false;
  bool _isEdit = false;
  Dataset? _editingDataset;
  bool _showDeleteModal = false;
  bool _isLoading = false;
  bool _showSuccess = false;
  bool _showError = false;
  String _toastMsg = '';
  late Future<List<Dataset>> _futureDatasets;

  @override
  void initState() {
    super.initState();
    _futureDatasets = DatasetService().getList();
  }

  void _refresh() {
    setState(() {
      _futureDatasets = DatasetService().getList();
      _selectedIndex = null;
    });
  }

  // 더미 raw data
  final List<Map<String, dynamic>> _rawData = List.generate(25, (i) => {
    'id': i + 1,
    'text': '샘플 데이터 ${i + 1}',
    'value': (i + 1) * 10,
  });

  // 모달용 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _fileType = 'CSV';
  int _descLen = 0;

  // 더미 데이터셋 목록
  final List<Map<String, dynamic>> _datasets = [
    {
      'id': 1,
      'name': 'KoQuAD v1.0',
      'desc': '한국어 기계독해 데이터셋',
      'createdAt': '2024-05-01',
    },
    {
      'id': 2,
      'name': 'KorNLI',
      'desc': '한국어 자연어 추론 데이터셋',
      'createdAt': '2024-05-10',
    },
    {
      'id': 3,
      'name': 'AIHub 감정분류',
      'desc': '감정 분류용 문장 데이터',
      'createdAt': '2024-05-15',
    },
  ];

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
                      '데이터셋 목록',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: '새로고침',
                      onPressed: _refresh,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('데이터셋 추가'),
                      onPressed: () {
                        _showAddEditDialog();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: FutureBuilder<List<Dataset>>(
                    future: _futureDatasets,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('에러: \\${snapshot.error}', style: TextStyle(color: Colors.red, fontSize: 16)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('데이터셋이 없습니다.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        );
                      }
                      final datasets = snapshot.data!;
                      return ListView.separated(
                        itemCount: datasets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, idx) {
                          final ds = datasets[idx];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              title: Text(ds.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              subtitle: Text(ds.desc),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(ds.createdAt, style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: '편집',
                                    onPressed: () => _showAddEditDialog(ds),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: '삭제',
                                    onPressed: () => _showDeleteDialog(ds),
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
            child: FutureBuilder<List<Dataset>>(
              future: _futureDatasets,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData || _selectedIndex == null) {
                  return const Center(child: Text('데이터셋을 선택하세요', style: TextStyle(fontSize: 20, color: Colors.grey)));
                }
                final ds = snapshot.data![_selectedIndex!];
                return _buildDetailPanel(ds);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(Dataset ds) {
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
                Text(ds.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: '편집',
                  onPressed: () => _showAddEditDialog(ds),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '삭제',
                  onPressed: () => _showDeleteDialog(ds),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(ds.desc, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('생성일: \\${ds.createdAt}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 0,
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) return kPrimaryDark;
            return null;
          }),
        ),
        onPressed: () {
          setState(() {
            _isEdit = false;
            _showAddEditModal = true;
            _nameController.clear();
            _descController.clear();
            _fileType = 'CSV';
            _descLen = 0;
          });
        },
        child: const Text('+ 새 데이터셋', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDatasetCard(Dataset ds, int idx, bool selected) {
    bool hovered = false;
    return StatefulBuilder(
      builder: (context, setState) => MouseRegion(
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        child: GestureDetector(
          onTap: () {
            this.setState(() {
              _selectedIndex = idx;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF8F5FF) : kCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? kPrimary : kBorder, width: selected ? 2 : 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(hovered || selected ? 0.15 : 0.1),
                  blurRadius: hovered || selected ? 16 : 8,
                  offset: Offset(0, hovered || selected ? 4 : 2),
                ),
              ],
            ),
            transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ds.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: kText)),
                const SizedBox(height: 6),
                Text(ds.desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kSubText, fontSize: 14)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.list_alt, size: 16, color: kSubText),
                        const SizedBox(width: 4),
                        const Text('1000', style: TextStyle(fontSize: 13, color: kSubText)),
                        const SizedBox(width: 12),
                        Icon(Icons.storage, size: 16, color: kSubText),
                        const SizedBox(width: 4),
                        const Text('1.2MB', style: TextStyle(fontSize: 13, color: kSubText)),
                      ],
                    ),
                    const Spacer(),
                    Tooltip(
                      message: '편집',
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                      textStyle: const TextStyle(color: Colors.white),
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: kPrimary),
                        onPressed: () => _showAddEditDialog(ds),
                      ),
                    ),
                    Tooltip(
                      message: '삭제',
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                      textStyle: const TextStyle(color: Colors.white),
                      child: IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: kDanger),
                        onPressed: () => _showDeleteDialog(ds),
                      ),
                    ),
                    Tooltip(
                      message: '더보기',
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                      textStyle: const TextStyle(color: Colors.white),
                      child: IconButton(
                        icon: const Icon(Icons.more_horiz, size: 20, color: kSubText),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(Dataset ds) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20)],
      ),
      padding: const EdgeInsets.all(32),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(ds.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: kText)),
                ),
                _buildDetailAction(Icons.visibility, 'View', kSubText, outlined: true),
                const SizedBox(width: 8),
                _buildDetailAction(Icons.edit, 'Edit', kPrimary, outlined: true),
                const SizedBox(width: 8),
                _buildDetailAction(Icons.delete, 'Delete', kDanger, outlined: false),
              ],
            ),
            const SizedBox(height: 8),
            Text(ds.desc, style: const TextStyle(color: kSubText, fontSize: 16)),
            const SizedBox(height: 24),
            TabBar(
              labelColor: kPrimary,
              unselectedLabelColor: kSubText,
              indicatorColor: kPrimary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Data View'),
                Tab(text: 'Statistics'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(child: _buildOverview(ds)),
                  _buildDataView(),
                  SingleChildScrollView(child: _buildStatistics()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailAction(IconData icon, String label, Color color, {bool outlined = false}) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: outlined ? BorderSide(color: color) : BorderSide.none,
        backgroundColor: outlined ? Colors.transparent : color.withOpacity(0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildOverview(Dataset ds) {
    // 2x3 그리드
    final meta = [
      {'icon': Icons.calendar_today, 'label': '생성일', 'value': ds.createdAt.toString().substring(0, 10)},
      {'icon': Icons.update, 'label': '수정일', 'value': ds.createdAt.toString().substring(0, 10)},
      {'icon': Icons.list_alt, 'label': '데이터 개수', 'value': '1000'},
      {'icon': Icons.storage, 'label': '파일 크기', 'value': '1.2MB'},
      {'icon': Icons.insert_drive_file, 'label': '형식', 'value': 'CSV'},
      {'icon': Icons.info_outline, 'label': '기타', 'value': '-'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kMetaBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
          ),
          child: SizedBox(
            height: 150,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              children: meta.map((m) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(m['icon'] as IconData, color: kPrimary, size: 28),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['label'] as String, style: const TextStyle(color: kSubText, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(m['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text('설명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(ds.desc, style: const TextStyle(color: kSubText, fontSize: 15)),
      ],
    );
  }

  Widget _buildDataView() {
    return Stack(
      children: [
        // 테이블 전체 화면 확장
        Positioned.fill(
          child: Column(
            children: [
              // 테이블 영역 (가로/세로 모두 확장)
              Expanded(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(kMetaBg),
                  columns: const [
                    DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Text', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.w600))),
                  ],
                  rows: _rawData.map((row) => DataRow(
                    cells: [
                      DataCell(Text(row['id'].toString())),
                      DataCell(Text(row['text'].toString(), overflow: TextOverflow.ellipsis)),
                      DataCell(Text(row['value'].toString())),
                    ],
                  )).toList(),
                ),
              ),
              const SizedBox(height: 60), // 페이징 하단 공간 확보
            ],
          ),
        ),
        // 페이지네이션: 화면 맨 아래 오른쪽
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
                ...List.generate(5, (i) => TextButton(
                  onPressed: () {},
                  child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                )),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    // 차트/그래프는 패키지(fl_chart 등)로 추가 가능, 여기선 placeholder
    return Card(
      color: kCard,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('통계 차트 영역 (예시)', style: TextStyle(color: kSubText)),
        ),
      ),
    );
  }

  void _showAddEditDialog([Dataset? ds]) {
    final isEdit = ds != null;
    _nameController.text = ds?.name ?? '';
    _descController.text = ds?.desc ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? '데이터셋 편집' : '데이터셋 추가'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: '설명'),
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
            onPressed: () async {
              final name = _nameController.text.trim();
              final desc = _descController.text.trim();
              if (name.isEmpty || desc.isEmpty) return;
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                if (isEdit) {
                  await DatasetService().update(Dataset(
                    id: ds!.id,
                    name: name,
                    desc: desc,
                    createdAt: ds.createdAt,
                  ));
                } else {
                  await DatasetService().create(Dataset(
                    id: DateTime.now().millisecondsSinceEpoch, // 임시 ID
                    name: name,
                    desc: desc,
                    createdAt: DateTime.now().toString().substring(0, 10),
                  ));
                }
                _refresh();
                setState(() {
                  _showSuccess = true;
                  _toastMsg = isEdit ? '수정 완료' : '추가 완료';
                });
              } catch (e) {
                setState(() {
                  _showError = true;
                  _toastMsg = '저장 실패: $e';
                });
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: Text(isEdit ? '저장' : '추가'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog([Dataset? ds]) {
    if (ds == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터셋 삭제'),
        content: Text('정말 삭제하시겠습니까? (${ds.name})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                await DatasetService().delete(ds.id);
                _refresh();
                setState(() {
                  _showSuccess = true;
                  _toastMsg = '삭제 완료';
                });
              } catch (e) {
                setState(() {
                  _showError = true;
                  _toastMsg = '삭제 실패: $e';
                });
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  Widget _buildToast(bool success, String msg) {
    return Positioned(
      top: 40,
      right: 40,
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: success ? const Color(0xFF10B981) : kDanger,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16)],
          ),
          child: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(color: kPrimary),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, idx) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(width: 80, height: 16, color: kMetaBg),
            const SizedBox(width: 16),
            Expanded(child: Container(height: 16, color: kMetaBg)),
          ],
        ),
      ),
    );
  }
}

// 점선 박스(파일 업로드 영역)
class DottedBorderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 1, style: BorderStyle.solid),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.upload_file, color: kPrimary),
            SizedBox(width: 8),
            Text('파일을 드래그하거나 클릭하여 업로드', style: TextStyle(color: kSubText)),
          ],
        ),
      ),
    );
  }
} 