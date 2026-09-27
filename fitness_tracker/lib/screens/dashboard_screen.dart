import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/activity.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_chart.dart';
import 'add_activity_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = DatabaseHelper.instance;
  final _goals = const DailyGoals();

  List<Activity> _todayActivities = [];
  List<Activity> _weekActivities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  DateTime get _startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final startOfToday = _startOfToday;
    final endOfToday = startOfToday.add(const Duration(days: 1));
    final startOfWeek = startOfToday.subtract(const Duration(days: 6));

    final today = await _db.getActivitiesBetween(startOfToday, endOfToday);
    final week = await _db.getActivitiesBetween(startOfWeek, endOfToday);

    setState(() {
      _todayActivities = today;
      _weekActivities = week;
      _loading = false;
    });
  }

  int get _todaySteps =>
      _todayActivities.fold(0, (sum, a) => sum + a.steps);
  int get _todayCalories =>
      _todayActivities.fold(0, (sum, a) => sum + a.caloriesBurned);
  int get _todayMinutes =>
      _todayActivities.fold(0, (sum, a) => sum + a.durationMinutes);

  /// Buckets the last 7 days of activity into per-day totals for the chart.
  List<double> _weeklySeries(int Function(Activity) selector) {
    final startOfToday = _startOfToday;
    final buckets = List<double>.filled(7, 0);
    for (final activity in _weekActivities) {
      final day = DateTime(
          activity.date.year, activity.date.month, activity.date.day);
      final diff = startOfToday.difference(day).inDays; // 0 = today
      final index = 6 - diff;
      if (index >= 0 && index < 7) {
        buckets[index] += selector(activity);
      }
    }
    return buckets;
  }

  List<String> get _dayLabels {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final startOfToday = _startOfToday;
    return List.generate(7, (i) {
      final day = startOfToday.subtract(Duration(days: 6 - i));
      return names[day.weekday - 1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Fitness Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
              _loadData();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Today',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                    children: [
                      StatCard(
                        title: 'Steps',
                        valueLabel: '$_todaySteps',
                        current: _todaySteps,
                        goal: _goals.stepsGoal,
                        icon: Icons.directions_walk,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: 'Calories',
                        valueLabel: '$_todayCalories kcal',
                        current: _todayCalories,
                        goal: _goals.caloriesGoal,
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                      StatCard(
                        title: 'Active Minutes',
                        valueLabel: '$_todayMinutes min',
                        current: _todayMinutes,
                        goal: _goals.activeMinutesGoal,
                        icon: Icons.timer,
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Workouts',
                        valueLabel: '${_todayActivities.length}',
                        current: _todayActivities.length,
                        goal: 3,
                        icon: Icons.fitness_center,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'This Week · Calories',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: WeeklyChart(
                      dailyValues: _weeklySeries((a) => a.caloriesBurned),
                      dayLabels: _dayLabels,
                      color: Colors.orange,
                      unitSuffix: ' kcal',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'This Week · Steps',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: WeeklyChart(
                      dailyValues: _weeklySeries((a) => a.steps),
                      dayLabels: _dayLabels,
                      color: Colors.blue,
                      unitSuffix: ' steps',
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddActivityScreen()),
          );
          if (added == true) _loadData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Log Activity'),
      ),
    );
  }
}
