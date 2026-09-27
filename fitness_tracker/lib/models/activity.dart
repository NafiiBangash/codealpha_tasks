/// Types of activity a user can log. Keep this small and friendly —
/// it drives the icon + color used throughout the UI.
enum ActivityType { running, walking, cycling, gym, yoga, swimming, other }

extension ActivityTypeX on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.running:
        return 'Running';
      case ActivityType.walking:
        return 'Walking';
      case ActivityType.cycling:
        return 'Cycling';
      case ActivityType.gym:
        return 'Gym / Strength';
      case ActivityType.yoga:
        return 'Yoga';
      case ActivityType.swimming:
        return 'Swimming';
      case ActivityType.other:
        return 'Other';
    }
  }
}

/// A single logged fitness entry. This is the core record stored in SQLite.
class Activity {
  final int? id;
  final ActivityType type;
  final DateTime date;
  final int durationMinutes;
  final int caloriesBurned;
  final int steps;
  final String? notes;

  Activity({
    this.id,
    required this.type,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.steps = 0,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'steps': steps,
      'notes': notes,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int?,
      type: ActivityType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ActivityType.other,
      ),
      date: DateTime.parse(map['date'] as String),
      durationMinutes: map['durationMinutes'] as int,
      caloriesBurned: map['caloriesBurned'] as int,
      steps: (map['steps'] as int?) ?? 0,
      notes: map['notes'] as String?,
    );
  }

  Activity copyWith({
    int? id,
    ActivityType? type,
    DateTime? date,
    int? durationMinutes,
    int? caloriesBurned,
    int? steps,
    String? notes,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      notes: notes ?? this.notes,
    );
  }
}

/// Simple daily goals — kept in one place so the dashboard and settings
/// (future) can share the same numbers.
class DailyGoals {
  final int stepsGoal;
  final int caloriesGoal;
  final int activeMinutesGoal;

  const DailyGoals({
    this.stepsGoal = 8000,
    this.caloriesGoal = 500,
    this.activeMinutesGoal = 45,
  });
}
