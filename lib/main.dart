import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/customer_provider.dart';
import 'providers/visit_provider.dart';
import 'providers/activity_provider.dart';
import 'app_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Visits Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  static const tabs = ['/', '/visits', '/activities'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() => _index = i);
          context.go(tabs[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.event_note), label: 'Visits'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Activities'),
        ],
      ),
    );
  }
}
