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
  String _search = '';
  String _statusFilter = 'All';

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
            tooltip: 'Reload Visits',
            onPressed: () {
              Provider.of<VisitProvider>(context, listen: false).loadVisits();
            },
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
          final visits =
              provider.visits.where((v) {
                final matchesSearch =
                    _search.isEmpty ||
                    v.location.toLowerCase().contains(_search.toLowerCase()) ||
                    v.notes.toLowerCase().contains(_search.toLowerCase());
                final matchesStatus =
                    _statusFilter == 'All' || v.status == _statusFilter;
                return matchesSearch && matchesStatus;
              }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by location or notes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) => setState(() => _search = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _statusFilter == 'All',
                        onSelected:
                            (_) => setState(() => _statusFilter = 'All'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Pending'),
                        selected: _statusFilter == 'Pending',
                        onSelected:
                            (_) => setState(() => _statusFilter = 'Pending'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Completed'),
                        selected: _statusFilter == 'Completed',
                        onSelected:
                            (_) => setState(() => _statusFilter = 'Completed'),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Cancelled'),
                        selected: _statusFilter == 'Cancelled',
                        onSelected:
                            (_) => setState(() => _statusFilter = 'Cancelled'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    visits.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No visits found.',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add Visit'),
                                onPressed: () => context.go('/visits/add'),
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: visits.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final visit = visits[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 2,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      visit.status == 'Completed'
                                          ? Colors.green
                                          : visit.status == 'Pending'
                                          ? Colors.orange
                                          : Colors.red,
                                  child: Icon(
                                    Icons.event_note,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  visit.location,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date: ${visit.visitDate.toLocal().toString().split(' ')[0]}',
                                      softWrap: true,
                                    ),
                                    Text(
                                      'Status: ${visit.status}',
                                      softWrap: true,
                                    ),
                                    if (visit.notes.isNotEmpty)
                                      Text(
                                        'Notes: ${visit.notes}',
                                        softWrap: true,
                                      ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onTap: () {
                                  context.go('/visits/detail/${visit.id}');
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
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
