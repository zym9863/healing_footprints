import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/mood_entry.dart';
import '../../providers/mood_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/loading_indicator.dart';

class MoodStatsScreen extends StatefulWidget {
  const MoodStatsScreen({super.key});

  @override
  State<MoodStatsScreen> createState() => _MoodStatsScreenState();
}

class _MoodStatsScreenState extends State<MoodStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 加载指定日期范围内的数据
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<MoodProvider>(
        context,
        listen: false,
      ).loadEntriesInRange(_startDate, _endDate);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('情绪分析'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '情绪分布'), Tab(text: '情绪趋势')],
          indicatorColor: AppTheme.primaryColor,
          indicatorWeight: 3,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildDateRangeSelector(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildMoodDistributionTab(), _buildMoodTrendTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    final dateFormat = DateFormat('yyyy/MM/dd');
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.smallSpacing,
                  horizontal: AppTheme.spacing,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppTheme.smallBorderRadius,
                  ),
                  border: Border.all(color: AppTheme.secondaryColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '开始日期',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateFormat.format(_startDate),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.smallSpacing,
                  horizontal: AppTheme.spacing,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppTheme.smallBorderRadius,
                  ),
                  border: Border.all(color: AppTheme.secondaryColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '结束日期',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateFormat.format(_endDate),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _refreshData,
              tooltip: '刷新数据',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          // 确保开始日期不晚于结束日期
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = pickedDate;
          // 确保结束日期不早于开始日期
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _refreshData() {
    Provider.of<MoodProvider>(
      context,
      listen: false,
    ).loadEntriesInRange(_startDate, _endDate);
  }

  Widget _buildMoodDistributionTab() {
    return Consumer<MoodProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingIndicator(message: '加载中...');
        }

        if (provider.entries.isEmpty) {
          return const Center(child: Text('所选时间范围内没有情绪记录'));
        }

        final moodStats = provider.getMoodStats();
        final totalEntries = provider.entries.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(AppTheme.spacing),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(moodStats, totalEntries),
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                    centerSpaceColor: Colors.white,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // 可以在这里添加交互效果
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildMoodLegend(moodStats, totalEntries),
              const SizedBox(height: 24),
              _buildMoodInsights(provider),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    Map<MoodLevel, int> moodStats,
    int totalEntries,
  ) {
    return moodStats.entries.map((entry) {
      final moodLevel = entry.key;
      final count = entry.value;
      final percentage = totalEntries > 0 ? count / totalEntries : 0;
      final color = _getMoodColor(moodLevel);

      return PieChartSectionData(
        value: count.toDouble(),
        title: '${(percentage * 100).toStringAsFixed(1)}%',
        radius: 110,
        titlePositionPercentageOffset: 0.55,
        color: color,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        badgeWidget:
            count > 0
                ? Icon(moodLevel.icon, size: 20, color: Colors.white)
                : null,
        badgePositionPercentageOffset: 0.85,
      );
    }).toList();
  }

  Widget _buildMoodLegend(Map<MoodLevel, int> moodStats, int totalEntries) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('情绪分布', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: AppTheme.spacing),
          const Divider(),
          const SizedBox(height: AppTheme.smallSpacing),
          for (final entry in moodStats.entries)
            Builder(
              builder: (context) {
                final moodLevel = entry.key;
                final count = entry.value;
                final percentage = totalEntries > 0 ? count / totalEntries : 0;
                final color = _getMoodColor(moodLevel);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          moodLevel.icon,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        moodLevel.label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count 次 (${(percentage * 100).toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMoodInsights(MoodProvider provider) {
    // 计算主要情绪
    MoodLevel? dominantMood;
    int maxCount = 0;

    final moodStats = provider.getMoodStats();
    for (final entry in moodStats.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominantMood = entry.key;
      }
    }

    // 计算平均能量水平
    double avgEnergyLevel = 0;
    if (provider.entries.isNotEmpty) {
      double sum = 0;
      for (final entry in provider.entries) {
        sum += entry.energyLevel;
      }
      avgEnergyLevel = sum / provider.entries.length;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.insights,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text('情绪洞察', style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
            const SizedBox(height: AppTheme.spacing),
            const Divider(),
            const SizedBox(height: AppTheme.smallSpacing),
            if (dominantMood != null) ...[
              _buildInsightRow(
                icon: dominantMood.icon,
                color: _getMoodColor(dominantMood),
                label: '主要情绪',
                value: dominantMood.label,
              ),
              const SizedBox(height: AppTheme.smallSpacing),
            ],
            _buildInsightRow(
              icon: Icons.battery_charging_full,
              color: AppTheme.primaryColor,
              label: '平均能量水平',
              value: '${(avgEnergyLevel * 100).toStringAsFixed(1)}%',
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            _buildInsightRow(
              icon: Icons.note_alt,
              color: AppTheme.primaryColor,
              label: '记录总数',
              value: '${provider.entries.length}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMoodTrendTab() {
    return Consumer<MoodProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingIndicator(message: '加载中...');
        }

        if (provider.entries.isEmpty) {
          return const Center(child: Text('所选时间范围内没有情绪记录'));
        }

        // 按日期排序
        final sortedEntries = List.of(provider.entries);
        sortedEntries.sort((a, b) => a.date.compareTo(b.date));

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < sortedEntries.length) {
                        final date = sortedEntries[value.toInt()].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MM/dd').format(date),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value >= 1 && value <= 5 && value.toInt() == value) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            MoodLevel.fromValue(value.toInt()).label,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: sortedEntries.length - 1.0,
              minY: 1,
              maxY: 5,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    sortedEntries.length,
                    (index) => FlSpot(
                      index.toDouble(),
                      sortedEntries[index].moodLevel.value.toDouble(),
                    ),
                  ),
                  isCurved: true,
                  color: AppTheme.primaryColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter:
                        (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 5,
                          color: AppTheme.primaryColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppTheme.primaryColor.withAlpha(40),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getMoodColor(MoodLevel level) {
    switch (level) {
      case MoodLevel.terrible:
        return AppTheme.moodTerribleColor;
      case MoodLevel.bad:
        return AppTheme.moodBadColor;
      case MoodLevel.neutral:
        return AppTheme.moodNeutralColor;
      case MoodLevel.good:
        return AppTheme.moodGoodColor;
      case MoodLevel.excellent:
        return AppTheme.moodExcellentColor;
    }
  }
}
