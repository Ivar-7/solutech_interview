import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:solutech_interview/providers/visit_provider.dart';

class VisitListScreen extends StatefulWidget {
  const VisitListScreen({super.key});

  @override
  State<VisitListScreen> createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitProvider>(context, listen: false).loadVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Visits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'View Visit Statistics',
            onPressed: () {
              context.go('/visits/stats');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => Provider.of<VisitProvider>(context, listen: false).loadVisits(),
          ),
        ],
      ),
      body: Consumer<VisitProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.visits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No visits yet. Start by adding your first visit!', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Visit'),
                    onPressed: () => context.go('/visits/add'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemCount: provider.visits.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final visit = provider.visits[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text('Visit #${visit.id} - ${visit.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Date: ${visit.visitDate.toLocal().toString().split(' ')[0]}\nLocation: ${visit.location}'),
                  onTap: () {
                    context.go('/visits/detail/${visit.id}');
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit Visit',
                    onPressed: () => context.go('/visits/edit/${visit.id}'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/visits/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Visit'),
      ),
    );
  }
}
