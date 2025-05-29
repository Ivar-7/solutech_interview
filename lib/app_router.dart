import 'package:go_router/go_router.dart';
import 'package:solutech_interview/screens/customer_list_screen.dart';
import 'package:solutech_interview/screens/customer_form_screen.dart';
import 'package:solutech_interview/screens/visit_list_screen.dart';
import 'package:solutech_interview/screens/visit_form_screen.dart';
import 'package:solutech_interview/screens/visit_detail_screen.dart';
import 'package:solutech_interview/screens/visit_stats_screen.dart';
import 'package:solutech_interview/models/visit.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CustomerListScreen(),
      routes: [
        GoRoute(
          path: 'customer/add',
          builder: (context, state) => const CustomerFormScreen(),
        ),
        GoRoute(
          path: 'customer/edit/:id',
          builder: (context, state) {
            // fetch customer by id or pass via extra
            return CustomerFormScreen();
          },
        ),
        GoRoute(
          path: 'visits',
          builder: (context, state) => const VisitListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const VisitFormScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                // fetch visit by id or pass via extra
                return VisitFormScreen();
              },
            ),
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
                // fetch visit by id or pass via extra
                return VisitDetailScreen(
                  visit: Visit(
                    id: 0,
                    customerId: 0,
                    visitDate: DateTime.now(),
                    status: '',
                    location: '',
                    notes: '',
                    activitiesDone: const [],
                    createdAt: DateTime.now(),
                  ),
                  activities: const [],
                );
              },
            ),
            GoRoute(
              path: 'stats',
              builder: (context, state) => const VisitStatsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
