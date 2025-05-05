import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class MoodEntryCard extends StatelessWidget {
  final MoodEntry entry;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const MoodEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy年MM月dd日 HH:mm').format(entry.date);
    final moodColor = _getMoodColor(entry.moodLevel);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing,
        vertical: AppTheme.smallSpacing,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.smallSpacing),
                      decoration: BoxDecoration(
                        color: moodColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
                      ),
                      child: Icon(
                        entry.moodLevel.icon,
                        size: 28,
                        color: moodColor,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.moodLevel.label,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.textLightColor),
                        onPressed: onDelete,
                      ),
                  ],
                ),
                if (entry.description.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacing),
                  Text(
                    entry.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacing),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.tags.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
                if (entry.energyLevel > 0) ...[
                  const SizedBox(height: AppTheme.spacing),
                  Row(
                    children: [
                      const Icon(
                        Icons.battery_charging_full,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '能量水平: ${(entry.energyLevel * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
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
