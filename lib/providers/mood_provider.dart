import 'package:flutter/foundation.dart';
import '../models/mood_entry.dart';
import '../services/database_helper.dart';

class MoodProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<MoodEntry> _entries = [];
  bool _isLoading = false;
  
  List<MoodEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  
  // 初始化加载所有情绪记录
  Future<void> loadEntries() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _entries = await _dbHelper.getMoodEntries();
    } catch (e) {
      debugPrint('加载情绪记录失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // 加载特定日期范围内的情绪记录
  Future<void> loadEntriesInRange(DateTime start, DateTime end) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _entries = await _dbHelper.getMoodEntriesInRange(start, end);
    } catch (e) {
      debugPrint('加载日期范围内的情绪记录失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // 添加新的情绪记录
  Future<void> addEntry(MoodEntry entry) async {
    try {
      final id = await _dbHelper.insertMoodEntry(entry);
      final newEntry = entry.copyWith(id: id);
      _entries.insert(0, newEntry); // 添加到列表开头
      notifyListeners();
    } catch (e) {
      debugPrint('添加情绪记录失败: $e');
      rethrow; // 重新抛出异常以便UI层处理
    }
  }
  
  // 更新情绪记录
  Future<void> updateEntry(MoodEntry entry) async {
    try {
      await _dbHelper.updateMoodEntry(entry);
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('更新情绪记录失败: $e');
      rethrow;
    }
  }
  
  // 删除情绪记录
  Future<void> deleteEntry(int id) async {
    try {
      await _dbHelper.deleteMoodEntry(id);
      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('删除情绪记录失败: $e');
      rethrow;
    }
  }
  
  // 获取所有使用过的标签
  Future<List<String>> getAllTags() async {
    try {
      return await _dbHelper.getAllTags();
    } catch (e) {
      debugPrint('获取标签失败: $e');
      return [];
    }
  }
  
  // 获取情绪统计数据
  Map<MoodLevel, int> getMoodStats() {
    final stats = <MoodLevel, int>{};
    
    // 初始化所有情绪等级的计数为0
    for (var level in MoodLevel.values) {
      stats[level] = 0;
    }
    
    // 统计每种情绪等级的数量
    for (var entry in _entries) {
      stats[entry.moodLevel] = (stats[entry.moodLevel] ?? 0) + 1;
    }
    
    return stats;
  }
}