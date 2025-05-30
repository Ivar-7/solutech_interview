import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/models/activity.dart';
import 'package:solutech_interview/models/customer.dart';
import 'package:solutech_interview/providers/activity_provider.dart';
import 'package:solutech_interview/providers/customer_provider.dart';
import 'package:solutech_interview/providers/visit_provider.dart';

class VisitDetailScreen extends StatefulWidget {
  final Visit visit;
  final Customer? customer;
  final List<Activity> activities;
  const VisitDetailScreen({super.key, required this.visit, this.customer, required this.activities});

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
      final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
      if (activityProvider.activities.isEmpty && !activityProvider.isLoading) {
        activityProvider.loadActivities();
      }
      if (customerProvider.customers.isEmpty && !customerProvider.isLoading) {
        customerProvider.loadCustomers();
      }
      _didLoad = true;
    }
  }

  void _deleteVisit() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Visit'),
        content: const Text('Are you sure you want to delete this visit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (!mounted || confirm != true) return;
    
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    
    try {
      await visitProvider.deleteVisit(widget.visit.id);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting visit: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ActivityProvider, CustomerProvider>(
      builder: (context, activityProvider, customerProvider, _) {
        if (activityProvider.isLoading || customerProvider.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Visit Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (activityProvider.error != null || customerProvider.error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Visit Details')),
            body: const Center(child: Text('Error loading data.')),
          );
        }
        final activities = activityProvider.activities;
        final customer = customerProvider.customers.firstWhere(
          (c) => c.id == widget.visit.customerId,
          orElse: () => Customer(id: -1, name: 'Unknown', createdAt: DateTime.now()),
        );
        final activityLabels = activities
            .where((a) => widget.visit.activitiesDone.contains(a.id))
            .map((a) => a.description)
            .toList();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Visit Details'),
            foregroundColor: Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                tooltip: 'Edit',
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/visits/edit/${widget.visit.id}',
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: 'Delete',
                onPressed: _deleteVisit,
              ),
            ],
          ),
          backgroundColor: const Color(0xFFF6F7FB),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 28),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.visit.location,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF22223B)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Date:',
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.visit.visitDate.toLocal().toString().split(' ')[0],
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Status:',
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: widget.visit.status == 'Completed'
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.visit.status,
                                  style: TextStyle(
                                    color: widget.visit.status == 'Completed'
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.person, size: 20, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Customer:',
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                customer.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          if (activityLabels.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Activities Done:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 6),
                                ...activityLabels.map((desc) => Padding(
                                      padding: const EdgeInsets.only(left: 8, bottom: 2),
                                      child: Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 18),
                                          const SizedBox(width: 6),
                                          Flexible(child: Text(desc, style: const TextStyle(fontSize: 15))),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          if (widget.visit.notes.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2E9E4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Notes: ${widget.visit.notes}',
                                style: const TextStyle(fontSize: 15, color: Color(0xFF4A4E69)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
