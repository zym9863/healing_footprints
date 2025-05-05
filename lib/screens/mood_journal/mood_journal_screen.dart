import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/mood_entry.dart';
import '../../providers/mood_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/mood_entry_card.dart';
import 'mood_entry_screen.dart';
import 'mood_stats_screen.dart';

class MoodJournalScreen extends StatefulWidget {
  const MoodJournalScreen({super.key});

  @override
  State<MoodJournalScreen> createState() => _MoodJournalScreenState();
}

class _MoodJournalScreenState extends State<MoodJournalScreen> {
  @override
  void initState() {
    super.initState();
    // 加载情绪日记数据
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<MoodProvider>(context, listen: false).loadEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('情绪日记'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MoodStatsScreen(),
                ),
              );
            },
            tooltip: '情绪分析',
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<MoodProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: '加载中...');
          }

          if (provider.entries.isEmpty) {
            return EmptyState(
              icon: Icons.mood,
              title: '还没有情绪日记记录',
              subtitle: '记录你的情绪变化，追踪心理健康',
              buttonText: '添加第一条记录',
              onButtonPressed: () => _navigateToEntryScreen(context),
            );
          }

          return ListView.builder(
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return _buildMoodEntryCard(context, entry);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEntryScreen(context),
        tooltip: '添加情绪记录',
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMoodEntryCard(BuildContext context, MoodEntry entry) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _navigateToEntryScreen(context, entry: entry);
            },
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '编辑',
          ),
          SlidableAction(
            onPressed: (context) {
              _confirmDelete(context, entry);
            },
            backgroundColor: AppTheme.moodTerribleColor,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: MoodEntryCard(
        entry: entry,
        onTap: () => _navigateToEntryScreen(context, entry: entry),
        onDelete: () => _confirmDelete(context, entry),
      ),
    );
  }

  void _navigateToEntryScreen(BuildContext context, {MoodEntry? entry}) {
    // 获取provider引用，避免在异步操作中使用BuildContext
    final provider = Provider.of<MoodProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MoodEntryScreen(entry: entry)),
    ).then((_) {
      // 返回时刷新列表
      if (mounted) {
        provider.loadEntries();
      }
    });
  }

  void _confirmDelete(BuildContext context, MoodEntry entry) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('确认删除'),
            content: const Text('确定要删除这条情绪记录吗？此操作不可撤销。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<MoodProvider>(
                    context,
                    listen: false,
                  ).deleteEntry(entry.id!);
                },
                child: const Text('删除'),
              ),
            ],
          ),
    );
  }
}
