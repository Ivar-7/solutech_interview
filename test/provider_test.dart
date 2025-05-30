import 'package:flutter_test/flutter_test.dart';
import 'package:solutech_interview/providers/customer_provider.dart';
import 'package:solutech_interview/providers/visit_provider.dart';
import 'package:solutech_interview/providers/activity_provider.dart';

void main() {
  group('CustomerProvider', () {
    test('Initial state', () {
      final provider = CustomerProvider();
      expect(provider.customers, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });
  });

  group('VisitProvider', () {
    test('Initial state', () {
      final provider = VisitProvider();
      expect(provider.visits, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });
  });

  group('ActivityProvider', () {
    test('Initial state', () {
      final provider = ActivityProvider();
      expect(provider.activities, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });
  });
}
