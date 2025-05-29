import 'package:flutter/material.dart';
import 'package:solutech_interview/models/visit.dart';
import 'package:solutech_interview/models/activity.dart';
import 'package:solutech_interview/models/customer.dart';

class VisitDetailScreen extends StatelessWidget {
  final Visit visit;
  final Customer? customer;
  final List<Activity> activities;
  const VisitDetailScreen({Key? key, required this.visit, this.customer, required this.activities}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Customer'),
              subtitle: Text(customer?.name ?? 'Unknown'),
            ),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(visit.visitDate.toLocal().toString()),
            ),
            ListTile(
              title: const Text('Status'),
              subtitle: Text(visit.status),
            ),
            ListTile(
              title: const Text('Location'),
              subtitle: Text(visit.location),
            ),
            ListTile(
              title: const Text('Notes'),
              subtitle: Text(visit.notes),
            ),
            ListTile(
              title: const Text('Activities Done'),
              subtitle: activityLabels.isEmpty
                  ? const Text('None')
                  : Wrap(
                      spacing: 8,
                      children: activityLabels.map((desc) => Chip(label: Text(desc))).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
