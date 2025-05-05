import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class MoodSelector extends StatelessWidget {
  final MoodLevel selectedMood;
  final Function(MoodLevel) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '你现在的心情如何？',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppTheme.spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: MoodLevel.values.map((mood) => _buildMoodOption(context, mood)).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodOption(BuildContext context, MoodLevel mood) {
    final isSelected = selectedMood == mood;
    final color = _getMoodColor(mood);
    
    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.smallSpacing),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
          border: isSelected 
              ? Border.all(color: color, width: 2) 
              : null,
        ),
        child: Column(
          children: [
            Icon(
              mood.icon,
              size: 40,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(height: AppTheme.smallSpacing),
            Text(
              mood.label,
              style: TextStyle(
                color: isSelected ? color : AppTheme.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
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
