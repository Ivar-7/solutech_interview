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
            const Text('Your Visit Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatCard(label: 'Total', value: visits.length, color: Colors.blue),
                  _StatCard(label: 'Completed', value: completed, color: Colors.green),
                  _StatCard(label: 'Pending', value: pending, color: Colors.orange),
                  _StatCard(label: 'Cancelled', value: cancelled, color: Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Optionally add more charts or breakdowns here
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      // ignore: deprecated_member_use
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$value', style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
