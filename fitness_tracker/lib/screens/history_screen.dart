import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/activity.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _db = DatabaseHelper.instance;
  List<Activity> _activities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final all = await _db.getAllActivities();
    setState(() {
      _activities = all;
      _loading = false;
    });
  }

  Future<void> _delete(Activity activity) async {
    await _db.deleteActivity(activity.id!);
    _load();
  }

  IconData _iconFor(ActivityType type) {
    switch (type) {
      case ActivityType.running:
        return Icons.directions_run;
      case ActivityType.walking:
        return Icons.directions_walk;
      case ActivityType.cycling:
        return Icons.directions_bike;
      case ActivityType.gym:
        return Icons.fitness_center;
      case ActivityType.yoga:
        return Icons.self_improvement;
      case ActivityType.swimming:
        return Icons.pool;
      case ActivityType.other:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activities.isEmpty
              ? const Center(
                  child: Text(
                    'No activities logged yet.\nTap "Log Activity" to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _activities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final activity = _activities[index];
                    return Dismissible(
                      key: ValueKey(activity.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _delete(activity),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            child: Icon(_iconFor(activity.type),
                                color: Colors.blue),
                          ),
                          title: Text(activity.type.label),
                          subtitle: Text(
                            '${dateFormat.format(activity.date)} · ${activity.durationMinutes} min · ${activity.caloriesBurned} kcal'
                            '${activity.steps > 0 ? ' · ${activity.steps} steps' : ''}',
                          ),
                          isThreeLine: activity.notes != null,
                          trailing: activity.notes != null
                              ? const Icon(Icons.note_alt_outlined,
                                  color: Colors.grey, size: 18)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
