import 'package:flutter_test/flutter_test.dart';
import 'package:solutech_interview/models/customer.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/models/activity.dart';

void main() {
  group('Customer Model', () {
    test('fromJson and toJson', () {
      final customer = Customer.fromJson({
        'id': 1,
        'name': 'Test Customer',
        'created_at': DateTime.now().toIso8601String(),
      });
      final json = customer.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Test Customer');
      expect(json['created_at'], isNotNull);
    });
  });

  group('Visit Model', () {
    test('fromJson and toJson', () {
      final visit = Visit.fromJson({
        'id': 1,
        'customer_id': 2,
        'visit_date': DateTime.now().toIso8601String(),
        'status': 'Completed',
        'location': 'Office',
        'notes': 'All good',
        'activities_done': [1, 2],
        'created_at': DateTime.now().toIso8601String(),
      });
      final json = visit.toJson();
      expect(json['id'], 1);
      expect(json['customer_id'], 2);
      expect(json['status'], 'Completed');
      expect(json['location'], 'Office');
      expect(json['notes'], 'All good');
      expect(json['activities_done'], isA<List<String>>());
    });
  });

  group('Activity Model', () {
    test('fromJson and toJson', () {
      final activity = Activity.fromJson({
        'id': 1,
        'description': 'Test Activity',
        'created_at': DateTime.now().toIso8601String(),
      });
      final json = activity.toJson();
      expect(json['id'], 1);
      expect(json['description'], 'Test Activity');
      expect(json['created_at'], isNotNull);
    });
  });
}
