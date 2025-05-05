import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EnergyLevelSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const EnergyLevelSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '你的能量水平如何？',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppTheme.smallSpacing),
        Text(
          '记录你当前的精力和活力状态',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppTheme.spacing),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing,
            vertical: AppTheme.smallSpacing,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEnergyLabel(context, '低能量', Icons.battery_0_bar),
                  _buildEnergyLabel(context, '高能量', Icons.battery_full),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.primaryColor,
                  inactiveTrackColor: AppTheme.secondaryColor.withOpacity(0.3),
                  thumbColor: AppTheme.primaryColor,
                  overlayColor: AppTheme.primaryColor.withOpacity(0.2),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0,
                  max: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing,
                        vertical: AppTheme.smallSpacing / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
                      ),
                      child: Text(
                        '${(value * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '100%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyLabel(BuildContext context, String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
