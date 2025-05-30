import 'package:flutter_test/flutter_test.dart';
import 'package:solutech_interview/main.dart';

void main() {
  testWidgets('App renders and shows Visits tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Visits'), findsOneWidget);
    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Activities'), findsOneWidget);
  });
}
