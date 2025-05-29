import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityService _activityService = ActivityService();
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _error;

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadActivities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _activities = await _activityService.fetchActivities();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addActivity(String description) async {
    _isLoading = true;
    notifyListeners();
    try {
      final activity = await _activityService.createActivity(description);
      _activities.add(activity);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateActivity(int id, String description) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updated = await _activityService.updateActivity(id, description);
      final index = _activities.indexWhere((a) => a.id == id);
      if (index != -1) {
        _activities[index] = updated;
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteActivity(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _activityService.deleteActivity(id);
      _activities.removeWhere((a) => a.id == id);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
