import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';

class ModelService {
  static const String baseUrl = 'http://localhost:8000/api/models';

  Future<List<Model>> getList() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Model.fromJson(e)).toList();
    } else {
      throw Exception('모델 목록 불러오기 실패');
    }
  }

  Future<Model> getDetail(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return Model.fromJson(json.decode(res.body));
    } else {
      throw Exception('모델 상세 불러오기 실패');
    }
  }

  Future<void> create(Model m) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(m.toJson()),
    );
    if (res.statusCode != 201) {
      throw Exception('모델 생성 실패');
    }
  }

  Future<void> update(Model m) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${m.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(m.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('모델 수정 실패');
    }
  }

  Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 204) {
      throw Exception('모델 삭제 실패');
    }
  }
} 