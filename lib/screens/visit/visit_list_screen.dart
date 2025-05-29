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
        title: const Text('Visits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              context.go('/visits/stats');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
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
            return const Center(child: Text('No visits found.'));
          }
          return ListView.separated(
            itemCount: provider.visits.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final visit = provider.visits[index];
              return ListTile(
                title: Text('Visit #${visit.id} - ${visit.status}'),
                subtitle: Text('Date: ${visit.visitDate.toLocal()}\nLocation: ${visit.location}'),
                onTap: () {
                  context.go('/visits/detail/${visit.id}');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        context.go('/visits/edit/${visit.id}');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Visit'),
                            content: const Text('Are you sure you want to delete this visit?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await Provider.of<VisitProvider>(context, listen: false).deleteVisit(visit.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.go('/visits/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
