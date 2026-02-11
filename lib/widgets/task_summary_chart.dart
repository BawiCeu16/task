import 'package:flutter/material.dart';
import 'package:task/pages/setting_screens/manage_all_page.dart';

class TaskSummaryChart extends StatelessWidget {
  final int total;
  final int complete;
  final int incomplete;

  const TaskSummaryChart({
    super.key,
    required this.total,
    required this.complete,
    required this.incomplete,
  });

  @override
  Widget build(BuildContext context) {
    final completionRate = total == 0 ? 0.0 : complete / total;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(10), // Adjust margin to fit list style
      // specific color or default card color
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageAllPage()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              // Circular Indicator with Gradient
              SizedBox(
                height: 70,
                width: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: CircularProgressIndicator(
                        value: completionRate,
                        strokeWidth: 6,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(completionRate * 100).toInt()}%',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Progress",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      context,
                      'Complete',
                      complete,
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    _buildStatRow(
                      context,
                      'Incomplete',
                      incomplete,
                      Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
