import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import 'api_service.dart';

class CustomerService {
  static String get baseUrl => ApiService.baseUrl;
  static Map<String, String> get headers => ApiService.headers;

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
}
