import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../models/mood_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal() {
    // 初始化sqflite_ffi
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // 初始化FFI
      sqfliteFfiInit();
      // 设置databaseFactory
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mood_journal.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mood_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        moodLevel INTEGER NOT NULL,
        description TEXT NOT NULL,
        triggerEvent TEXT,
        tags TEXT NOT NULL,
        energyLevel REAL NOT NULL
      )
    ''');
  }

  // 插入新的情绪记录
  Future<int> insertMoodEntry(MoodEntry entry) async {
    Database db = await database;
    return await db.insert('mood_entries', entry.toMap());
  }

  // 更新情绪记录
  Future<int> updateMoodEntry(MoodEntry entry) async {
    Database db = await database;
    return await db.update(
      'mood_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // 删除情绪记录
  Future<int> deleteMoodEntry(int id) async {
    Database db = await database;
    return await db.delete(
      'mood_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 获取所有情绪记录
  Future<List<MoodEntry>> getMoodEntries() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mood_entries', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => MoodEntry.fromMap(maps[i]));
  }

  // 获取特定日期范围内的情绪记录
  Future<List<MoodEntry>> getMoodEntriesInRange(DateTime start, DateTime end) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mood_entries',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => MoodEntry.fromMap(maps[i]));
  }

  // 获取单个情绪记录
  Future<MoodEntry?> getMoodEntry(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mood_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MoodEntry.fromMap(maps.first);
    }
    return null;
  }

  // 获取所有使用过的标签
  Future<List<String>> getAllTags() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mood_entries');
    Set<String> tagSet = {};
    
    for (var map in maps) {
      List<String> entryTags = (map['tags'] as String)
          .split(',')
          .where((tag) => tag.isNotEmpty)
          .toList();
      tagSet.addAll(entryTags);
    }
    
    return tagSet.toList();
  }
}