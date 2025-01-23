import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    final path = join(appDir.path, 'eduplanner.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await _createProjectsTable(db);
      await _createSchedulesTable(db);
      await _createRemindersTable(db);
    });
  }

  Future<void> _createProjectsTable(Database db) async {
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectName TEXT,
        description TEXT,
        date TEXT,
        status TEXT
      )
    ''');
  }

  Future<void> _createSchedulesTable(Database db) async {
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseName TEXT,
        classRoom TEXT,
        time TEXT,
        date TEXT
      )
    ''');
  }

  Future<void> _createRemindersTable(Database db) async {
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dateTime TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> fetchProjectsByStatus(
      String status) async {
    final db = await database;
    return await db.query('projects', where: 'status = ?', whereArgs: [status]);
  }

  Future<int> addProject(
      String name, String description, String date, String status) async {
    final db = await database;
    return await db.insert('projects', {
      'projectName': name,
      'description': description,
      'date': date,
      'status': status,
    });
  }

  Future<int> updateProjectStatus(int id, String newStatus) async {
    final db = await database;
    return await db.update(
      'projects',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProject(int id) async {
    final db = await database;
    return await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchSchedules() async {
    final db = await database;
    return await db.query('schedules');
  }

  Future<int> addSchedule(
      String courseName, String classRoom, String time, String date) async {
    final db = await database;
    return await db.insert('schedules', {
      'courseName': courseName,
      'classRoom': classRoom,
      'time': time,
      'date': date,
    });
  }

  Future<int> deleteSchedule(int id) async {
    final db = await database;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchReminders() async {
    final db = await database;
    return await db.query('reminders');
  }

  Future<int> addReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder);
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
