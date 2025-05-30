import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solutech_interview/providers/activity_provider.dart';
import 'package:solutech_interview/providers/customer_provider.dart';
import 'package:solutech_interview/providers/visit_provider.dart';
import 'package:solutech_interview/screens/customer/customer_list_screen.dart';
import 'package:solutech_interview/screens/customer/customer_form_screen.dart';
import 'package:solutech_interview/screens/visit/visit_list_screen.dart';
import 'package:solutech_interview/screens/visit/visit_form_screen.dart';
import 'package:solutech_interview/screens/visit/visit_detail_screen.dart';
import 'package:solutech_interview/screens/visit/visit_stats_screen.dart';
import 'package:solutech_interview/screens/activity/activity_list_screen.dart';
import 'package:solutech_interview/screens/activity/activity_form_screen.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/models/customer.dart';
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
                final visitId = int.parse(state.pathParameters['id']!);
                final visitProvider = Provider.of<VisitProvider>(context);
                final customerProvider = Provider.of<CustomerProvider>(context);
                final activityProvider = Provider.of<ActivityProvider>(context);

                // Get the visit, customer, and activities from providers (assume loaded by list screen)
                final visit = visitProvider.visits.firstWhere(
                  (v) => v.id == visitId,
                  orElse: () => Visit(
                    id: -1,
                    customerId: -1,
                    visitDate: DateTime.now(),
                    status: '',
                    location: '',
                    notes: '',
                    activitiesDone: const [],
                    createdAt: DateTime.now(),
                  ),
                );
                final customer = customerProvider.customers.firstWhere(
                  (c) => c.id == visit.customerId,
                  orElse: () => Customer(id: -1, name: 'Unknown', createdAt: DateTime.now()),
                );
                final activities = activityProvider.activities;

                return VisitDetailScreen(
                  visit: visit,
                  customer: customer,
                  activities: activities,
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
