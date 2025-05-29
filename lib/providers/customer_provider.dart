import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _error;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCustomers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _customers = await _customerService.fetchCustomers();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCustomer(String name) async {
    _isLoading = true;
    notifyListeners();
    try {
      final customer = await _customerService.createCustomer(name);
      _customers.add(customer);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCustomer(int id, String name) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updated = await _customerService.updateCustomer(id, name);
      final index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = updated;
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCustomer(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _customerService.deleteCustomer(id);
      _customers.removeWhere((c) => c.id == id);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
