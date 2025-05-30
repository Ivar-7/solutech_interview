import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/visit.dart';
import '../services/visit_service.dart';

class VisitProvider extends ChangeNotifier {
  final VisitService _visitService = VisitService();
  List<Visit> _visits = [];
  bool _isLoading = false;
  String? _error;
  bool _isOnline = true;

  List<Visit> get visits => _visits;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;

  VisitProvider() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    final connectivity = Connectivity();
    _isOnline = (await connectivity.checkConnectivity()) != ConnectivityResult.none;
    connectivity.onConnectivityChanged.listen((result) {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;
      if (!wasOnline && _isOnline) {
        syncPendingVisits();
      }
      notifyListeners();
    });
  }

  Future<void> loadVisits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      if (_isOnline) {
        _visits = await _visitService.fetchVisits();
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      } else {
        final local = Hive.box('visits').get('all', defaultValue: []);
        _visits = (local as List).map((e) => Visit.fromJson(Map<String, dynamic>.from(e))).toList();
      }
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
      if (_isOnline) {
        final newVisit = await _visitService.createVisit(visit);
        _visits.add(newVisit);
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      } else {
        // Save to pending
        final pendingBox = Hive.box('pending_visits');
        final pending = pendingBox.get('add', defaultValue: []);
        pendingBox.put('add', [...pending, visit.toJson()]);
        _visits.add(visit);
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      }
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
      if (_isOnline) {
        final updated = await _visitService.updateVisit(visit);
        final idx = _visits.indexWhere((v) => v.id == visit.id);
        if (idx != -1) _visits[idx] = updated;
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      } else {
        // Save to pending
        final pendingBox = Hive.box('pending_visits');
        final pending = pendingBox.get('update', defaultValue: []);
        pendingBox.put('update', [...pending, visit.toJson()]);
        final idx = _visits.indexWhere((v) => v.id == visit.id);
        if (idx != -1) _visits[idx] = visit;
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      }
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
      if (_isOnline) {
        await _visitService.deleteVisit(id);
        _visits.removeWhere((v) => v.id == id);
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      } else {
        // Save to pending
        final pendingBox = Hive.box('pending_visits');
        final pending = pendingBox.get('delete', defaultValue: []);
        pendingBox.put('delete', [...pending, id]);
        _visits.removeWhere((v) => v.id == id);
        await Hive.box('visits').put('all', _visits.map((v) => v.toJson()).toList());
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> syncPendingVisits() async {
    final pendingBox = Hive.box('pending_visits');
    // Sync adds
    final adds = List<Map<String, dynamic>>.from(pendingBox.get('add', defaultValue: []));
    for (final v in adds) {
      try {
        await _visitService.createVisit(Visit.fromJson(v));
      } catch (_) {}
    }
    pendingBox.put('add', []);
    // Sync updates
    final updates = List<Map<String, dynamic>>.from(pendingBox.get('update', defaultValue: []));
    for (final v in updates) {
      try {
        await _visitService.updateVisit(Visit.fromJson(v));
      } catch (_) {}
    }
    pendingBox.put('update', []);
    // Sync deletes
    final deletes = List<int>.from(pendingBox.get('delete', defaultValue: []));
    for (final id in deletes) {
      try {
        await _visitService.deleteVisit(id);
      } catch (_) {}
    }
    pendingBox.put('delete', []);
    await loadVisits();
  }
}
