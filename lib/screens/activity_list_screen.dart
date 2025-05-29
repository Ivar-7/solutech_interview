import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import 'activity_form_screen.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActivityProvider>(context, listen: false).loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<ActivityProvider>(context, listen: false).loadActivities(),
          ),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.activities.isEmpty) {
            return const Center(child: Text('No activities found.'));
          }
          return ListView.separated(
            itemCount: provider.activities.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final activity = provider.activities[index];
              return ListTile(
                title: Text(activity.description),
                subtitle: Text('Created: ${activity.createdAt.toLocal()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActivityFormScreen(activity: activity),
                          ),
                        );
                        if (result == true) {
                          Provider.of<ActivityProvider>(context, listen: false).loadActivities();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Activity'),
                            content: const Text('Are you sure you want to delete this activity?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await Provider.of<ActivityProvider>(context, listen: false).deleteActivity(activity.id);
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ActivityFormScreen(),
            ),
          );
          if (result == true) {
            Provider.of<ActivityProvider>(context, listen: false).loadActivities();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
