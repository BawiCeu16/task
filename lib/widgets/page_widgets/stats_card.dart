/// Reusable stats card widget for displaying metrics
import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';

class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final double? maxValue;
  final String? unit;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.maxValue,
    this.unit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.cardBorderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppConstants.cardBorderRadius,
        child: Padding(
          padding: AppConstants.paddingLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 4),
                    Text(unit!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
              if (maxValue != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  child: LinearProgressIndicator(
                    value: double.tryParse(value) != null
                        ? (double.parse(value) / maxValue!).clamp(0.0, 1.0)
                        : 0,
                    minHeight: 4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
