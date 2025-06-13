import 'package:flutter/material.dart';
import '../../models/evaluation.dart';
import '../../models/model.dart';
import '../../models/dataset.dart';
import '../../services/api_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final evaluations = ApiService().getEvaluations();
    final models = {for (var m in ApiService().getModels()) m.id: m};
    final datasets = {for (var d in ApiService().getDatasets()) d.id: d};
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '최근 평가 내역',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('날짜')),
                          DataColumn(label: Text('모델명')),
                          DataColumn(label: Text('평가셋 이름')),
                          DataColumn(label: Text('평균 점수')),
                        ],
                        rows: evaluations.map((eval) {
                          final modelName = models[eval.modelId]?.name ?? '-';
                          final datasetName = datasets[eval.datasetId]?.name ?? '-';
                          final dateStr = dateFormat.format(eval.startedAt);
                          final scoreStr = eval.score?.toStringAsFixed(2) ?? '-';
                          return DataRow(cells: [
                            DataCell(Text(dateStr)),
                            DataCell(Text(modelName)),
                            DataCell(Text(datasetName)),
                            DataCell(Text(scoreStr)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 