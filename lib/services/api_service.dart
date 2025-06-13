import '../models/dataset.dart';
import '../models/evaluation.dart';

class ApiService {
  // 싱글턴 패턴
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    // 더미 데이터가 없을 때만 추가
    if (_datasets.isEmpty && _evaluations.isEmpty) {
      // 데이터셋 더미 (10개)
      _datasets.addAll([
        Dataset(id: 1, name: 'KoNLP 데이터셋', desc: '한국어 자연어 처리용 데이터셋', createdAt: '2024-05-01'),
        Dataset(id: 2, name: '영어 QA 데이터셋', desc: '영어 질문-답변 데이터셋', createdAt: '2024-05-02'),
        Dataset(id: 3, name: '감정 분석 데이터', desc: '감정 분류용 데이터셋', createdAt: '2024-05-03'),
        Dataset(id: 4, name: '뉴스 기사 데이터', desc: '뉴스 기사 텍스트 데이터셋', createdAt: '2024-05-04'),
        Dataset(id: 5, name: '챗봇 대화 데이터', desc: '챗봇 대화 시나리오 데이터셋', createdAt: '2024-05-05'),
        Dataset(id: 6, name: '의료 QA 데이터', desc: '의료 분야 질문-답변 데이터셋', createdAt: '2024-05-06'),
        Dataset(id: 7, name: '법률 문서 데이터', desc: '법률 문서 요약 데이터셋', createdAt: '2024-05-07'),
        Dataset(id: 8, name: 'IT 기술 데이터', desc: 'IT 기술 관련 문서 데이터셋', createdAt: '2024-05-08'),
        Dataset(id: 9, name: 'SNS 댓글 데이터', desc: 'SNS 댓글 감정 분석 데이터셋', createdAt: '2024-05-09'),
        Dataset(id: 10, name: '일상 대화 데이터', desc: '일상 대화 문장 데이터셋', createdAt: '2024-05-10'),
      ]);
      // 평가 더미
      _evaluations.addAll([
        Evaluation(id: 'e1', datasetId: 'ds1', modelId: 'm1', startedAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)), finishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)), status: 'done', score: 87.5),
        Evaluation(id: 'e2', datasetId: 'ds2', modelId: 'm2', startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)), finishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)), status: 'done', score: 92.1),
        Evaluation(id: 'e3', datasetId: 'ds1', modelId: 'm2', startedAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)), finishedAt: DateTime.now().subtract(const Duration(days: 3)), status: 'done', score: 85.0),
        Evaluation(id: 'e4', datasetId: 'ds2', modelId: 'm1', startedAt: DateTime.now().subtract(const Duration(days: 4, hours: 2)), finishedAt: DateTime.now().subtract(const Duration(days: 4, hours: 1)), status: 'done', score: 78.3),
        Evaluation(id: 'e5', datasetId: 'ds1', modelId: 'm1', startedAt: DateTime.now().subtract(const Duration(days: 5, hours: 6)), finishedAt: DateTime.now().subtract(const Duration(days: 5, hours: 5)), status: 'done', score: 90.0),
      ]);
    }
  }

  // 임시 데이터 저장소
  final List<Dataset> _datasets = [];
  final List<Evaluation> _evaluations = [];

  // 데이터셋 관련
  List<Dataset> getDatasets() => _datasets;
  void addDataset(Dataset dataset) => _datasets.add(dataset);
  void removeDataset(String id) => _datasets.removeWhere((d) => d.id == id);

  // 평가 관련
  List<Evaluation> getEvaluations() => _evaluations;
  void addEvaluation(Evaluation eval) => _evaluations.add(eval);
  void removeEvaluation(String id) => _evaluations.removeWhere((e) => e.id == id);
} 