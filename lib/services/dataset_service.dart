import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dataset.dart';

class DatasetService {
  static const String baseUrl = 'http://localhost:8000/api/datasets';

  Future<List<Dataset>> getList() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Dataset.fromJson(e)).toList();
    } else {
      throw Exception('데이터셋 목록 불러오기 실패');
    }
  }

  Future<Dataset> getDetail(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return Dataset.fromJson(json.decode(res.body));
    } else {
      throw Exception('데이터셋 상세 불러오기 실패');
    }
  }

  Future<void> create(Dataset ds) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ds.toJson()),
    );
    if (res.statusCode != 201) {
      throw Exception('데이터셋 생성 실패');
    }
  }

  Future<void> update(Dataset ds) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${ds.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ds.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('데이터셋 수정 실패');
    }
  }

  Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 204) {
      throw Exception('데이터셋 삭제 실패');
    }
  }
} 