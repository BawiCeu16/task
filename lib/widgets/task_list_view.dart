import 'package:flutter/material.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/list_item.dart';
import 'package:task/widgets/task_bottom_sheet.dart';
import 'package:task/widgets/task_summary_chart.dart';

class TaskListView extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final TaskProvider provider;
  final bool isSliver;
  final bool showChart;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.provider,
    this.isSliver = false,
    this.showChart = false,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      final emptyWidget = const Center(child: Text('No tasks found'));
      return isSliver ? SliverFillRemaining(child: emptyWidget) : emptyWidget;
    }

    // Calculate stats for the chart
    final total = tasks.length;
    final complete = tasks.where((t) => (t['isDone'] ?? false) as bool).length;
    final incomplete = total - complete;

    final builder = (context, index) {
      if (showChart && index == 0) {
        return TaskSummaryChart(
          total: total,
          complete: complete,
          incomplete: incomplete,
        );
      }

      final taskIndex = showChart ? index - 1 : index;
      final task = tasks[taskIndex];
      final id = (task['id'] ?? '') as String;
      final realIndex = provider.tasks.indexWhere((t) => (t['id'] ?? '') == id);
      final title = (task['task'] ?? '') as String;
      final isDone = (task['isDone'] ?? false) as bool;
      final date = (task['createdDate'] ?? '') as String;
      final color = task['color'] as int?;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: MyListItem(
          title: title,
          isDone: isDone,
          date: date,
          color: color,
          onTap: () {
            if (realIndex != -1) {
              provider.toggleIsDone(realIndex);
            }
          },
          onLongPress: () {
            if (realIndex != -1) {
              showModalBottomSheet(
                context: context,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
                builder: (_) => TaskBottomSheet(
                  task: task,
                  realIndex: realIndex,
                  provider: provider,
                ),
              );
            }
          },
        ),
      );
    };

    final count = showChart ? tasks.length + 1 : tasks.length;

    if (isSliver) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(builder, childCount: count),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: count,
      itemBuilder: builder,
    );
  }
}
