import 'package:flutter/material.dart';
import '../models/visit.dart';
import '../services/visit_service.dart';

class VisitProvider extends ChangeNotifier {
  final VisitService _visitService = VisitService();
  List<Visit> _visits = [];
  bool _isLoading = false;
  String? _error;

  List<Visit> get visits => _visits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadVisits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _visits = await _visitService.fetchVisits();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addVisit(Visit visit) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newVisit = await _visitService.createVisit(visit);
      _visits.add(newVisit);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateVisit(Visit visit) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updated = await _visitService.updateVisit(visit);
      final idx = _visits.indexWhere((v) => v.id == visit.id);
      if (idx != -1) _visits[idx] = updated;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteVisit(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _visitService.deleteVisit(id);
      _visits.removeWhere((v) => v.id == id);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
