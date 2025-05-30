import 'package:flutter/material.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/models/activity.dart';
import 'package:solutech_interview/models/customer.dart';

class VisitDetailScreen extends StatelessWidget {
  final Visit visit;
  final Customer? customer;
  final List<Activity> activities;
  const VisitDetailScreen({super.key, required this.visit, this.customer, required this.activities});

  @override
  Widget build(BuildContext context) {
    final activityLabels = activities
        .where((a) => visit.activitiesDone.contains(a.id))
        .map((a) => a.description)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(visit.location, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('Date: ${visit.visitDate.toLocal().toString().split(' ')[0]}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('Status: ${visit.status}'),
                    ],
                  ),
                  if (visit.notes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(child: Text('Notes: ${visit.notes}')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.checklist, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      const Text('Activities Completed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (activityLabels.isEmpty)
                    const Text('No activities recorded.')
                  else
                    Wrap(
                      spacing: 8,
                      children: activityLabels.map((desc) => Chip(label: Text(desc))).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
