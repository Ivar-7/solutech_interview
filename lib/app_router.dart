import 'package:go_router/go_router.dart';
import 'package:solutech_interview/screens/customer/customer_list_screen.dart';
import 'package:solutech_interview/screens/customer/customer_form_screen.dart';
import 'package:solutech_interview/screens/visit/visit_list_screen.dart';
import 'package:solutech_interview/screens/visit/visit_form_screen.dart';
import 'package:solutech_interview/screens/visit/visit_detail_screen.dart';
import 'package:solutech_interview/screens/visit/visit_stats_screen.dart';
import 'package:solutech_interview/screens/activity/activity_list_screen.dart';
import 'package:solutech_interview/screens/activity/activity_form_screen.dart';
import 'package:solutech_interview/models/visit.dart';
import 'main.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const VisitListScreen(),
        ),
        GoRoute(
          path: '/visits',
          builder: (context, state) => const VisitListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const VisitFormScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                return VisitFormScreen();
              },
            ),
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) {
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
        GoRoute(
          path: '/customer',
          builder: (context, state) => const CustomerListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const CustomerFormScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                return CustomerFormScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: '/activities',
          builder: (context, state) => const ActivityListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const ActivityFormScreen(),
            ),
            GoRoute(
              path: 'edit/:id',
              builder: (context, state) {
                return ActivityFormScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
