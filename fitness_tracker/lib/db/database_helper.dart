import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/activity.dart';

/// Thin wrapper around sqflite. Everything the app needs to persist
/// (activities) goes through this single table for simplicity — the
/// app can grow into more tables (goals, user profile) later without
/// touching the UI layer.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_tracker.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            durationMinutes INTEGER NOT NULL,
            caloriesBurned INTEGER NOT NULL,
            steps INTEGER NOT NULL DEFAULT 0,
            notes TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return db.insert('activities', activity.toMap()..remove('id'));
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await database;
    return db.update(
      'activities',
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Activity>> getAllActivities() async {
    final db = await database;
    final rows = await db.query('activities', orderBy: 'date DESC');
    return rows.map(Activity.fromMap).toList();
  }

  /// Activities between [start] (inclusive) and [end] (exclusive) — used
  /// for both "today" and "this week" queries by the dashboard.
  Future<List<Activity>> getActivitiesBetween(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final rows = await db.query(
      'activities',
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return rows.map(Activity.fromMap).toList();
  }
}
