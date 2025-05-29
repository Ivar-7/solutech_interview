import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';
import 'api_service.dart';

class ActivityService {
  static String get baseUrl => ApiService.baseUrl;
  static Map<String, String> get headers => ApiService.headers;

  Future<List<Activity>> fetchActivities() async {
    final response = await http.get(Uri.parse('$baseUrl/activities'), headers: headers);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Activity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<Activity> createActivity(String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/activities'),
      headers: headers,
      body: json.encode({'description': description}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Activity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create activity');
    }
  }

  Future<Activity> updateActivity(int id, String description) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/activities?id=eq.$id'),
      headers: headers,
      body: json.encode({'description': description}),
    );
    if (response.statusCode == 200) {
      return Activity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update activity');
    }
  }

  Future<void> deleteActivity(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/activities?id=eq.$id'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete activity');
    }
  }
}
