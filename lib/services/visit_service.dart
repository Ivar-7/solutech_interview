import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visit.dart';
import 'api_service.dart';

class VisitService {
  static String get baseUrl => ApiService.baseUrl;
  static Map<String, String> get headers => ApiService.headers;

  Future<List<Visit>> fetchVisits() async {
    final response = await http.get(Uri.parse('$baseUrl/visits'), headers: headers);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Visit.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load visits');
    }
  }

  Future<Visit> createVisit(Visit visit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/visits'),
      headers: headers,
      body: json.encode(visit.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Visit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create visit');
    }
  }

  Future<Visit> updateVisit(Visit visit) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/visits?id=eq.${visit.id}'),
      headers: headers,
      body: json.encode(visit.toJson()),
    );
    if (response.statusCode == 200) {
      return Visit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update visit');
    }
  }

  Future<void> deleteVisit(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/visits?id=eq.$id'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete visit');
    }
  }
}
