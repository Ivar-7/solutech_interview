import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solutech_interview/models/customer.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/models/activity.dart';

class ApiService {
  static const String baseUrl = 'https://kqgbftwsodpttpqgqnbh.supabase.co/rest/v1';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxZ2JmdHdzb2RwdHRwcWdxbmJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5ODk5OTksImV4cCI6MjA2MTU2NTk5OX0.rwJSY4bJaNdB8jDn3YJJu_gKtznzm-dUKQb4OvRtP6c';

  static Map<String, String> get headers => {
    'apikey': apiKey,
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Customers CRUD
  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'), headers: headers);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Customer.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: headers,
      body: json.encode({'name': name}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Customer> updateCustomer(int id, String name) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/customers?id=eq.$id'),
      headers: headers,
      body: json.encode({'name': name}),
    );
    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<void> deleteCustomer(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/customers?id=eq.$id'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer');
    }
  }

  // Activities CRUD
  Future<List<Activity>> fetchActivities() async {
    final response = await http.get(Uri.parse('$baseUrl/activities'), headers: headers);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Activity.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  // Visits CRUD
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
