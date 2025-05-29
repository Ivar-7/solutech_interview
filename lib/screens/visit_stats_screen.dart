import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solutech_interview/providers/visit_provider.dart';

class VisitStatsScreen extends StatelessWidget {
  const VisitStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visits = Provider.of<VisitProvider>(context).visits;
    final completed = visits.where((v) => v.status == 'Completed').length;
    final pending = visits.where((v) => v.status == 'Pending').length;
    final cancelled = visits.where((v) => v.status == 'Cancelled').length;
    return Scaffold(
      appBar: AppBar(title: const Text('Visit Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Total Visits'),
                trailing: Text('${visits.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Completed'),
                trailing: Text('$completed', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Pending'),
                trailing: Text('$pending', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Cancelled'),
                trailing: Text('$cancelled', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
