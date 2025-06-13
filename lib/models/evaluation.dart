class Evaluation {
  final String id;
  final String datasetId;
  final String modelId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String status; // 예: 'pending', 'running', 'done'
  final double? score;

  Evaluation({
    required this.id,
    required this.datasetId,
    required this.modelId,
    required this.startedAt,
    this.finishedAt,
    required this.status,
    this.score,
  });
} 