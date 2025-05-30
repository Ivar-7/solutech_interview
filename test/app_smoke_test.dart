import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:solutech_interview/main.dart';
import 'package:solutech_interview/providers/customer_provider.dart';
import 'package:solutech_interview/providers/visit_provider.dart';
import 'package:solutech_interview/providers/activity_provider.dart';

void main() {
  testWidgets('App renders and shows Visits tab', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CustomerProvider()),
          ChangeNotifierProvider(create: (_) => VisitProvider()),
          ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Visits'), findsOneWidget);
    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Activities'), findsOneWidget);
  });
}
