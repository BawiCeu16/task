import 'package:flutter/material.dart';
import 'package:task/constants/app_constants.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/create_dialog.dart';
import 'package:task/widgets/common/index.dart';

class TaskBottomSheet extends StatelessWidget {
  final Map<String, dynamic> task;
  final int realIndex;
  final TaskProvider provider;

  const TaskBottomSheet({
    super.key,
    required this.task,
    required this.realIndex,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (realIndex == -1) return const SizedBox.shrink();
    final taskTitle = (task['task'] ?? '') as String;
    final isDone = (task['isDone'] ?? false) as bool;
    final date = (task['createdDate'] ?? '') as String;
    final folder = (task['folder'] ?? AppConstants.labelNone) as String;
    final category = (task['category'] ?? AppConstants.labelNone) as String;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
        child: Wrap(
          children: [
            // Header with title and date
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(taskTitle),
              subtitle: _buildFormattedDate(date),
            ),

            // Done toggle
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusRound,
                ),
              ),
              child: SwitchListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusRound,
                  ),
                ),
                title: const Text('Done'),
                value: isDone,
                onChanged: (_) {
                  provider.toggleIsDone(realIndex);
                  Navigator.pop(context);
                },
              ),
            ),

            // Action buttons using BottomSheetActionGroup
            BottomSheetActionGroup(
              actions: [
                (
                  icon: AppConstants.iconTaskEdit,
                  title: 'Edit',
                  onTap: () => _handleEdit(context, taskTitle, isDone),
                  isDestructive: false,
                  subtitle: null,
                ),
                (
                  icon: AppConstants.iconInfo,
                  title: 'Info',
                  onTap: () => _handleInfo(
                    context,
                    taskTitle,
                    date,
                    folder,
                    category,
                    isDone,
                  ),
                  isDestructive: false,
                  subtitle: null,
                ),
                (
                  icon: AppConstants.iconTaskDelete,
                  title: 'Delete',
                  onTap: () => _handleDelete(context, taskTitle),
                  isDestructive: true,
                  subtitle: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFormattedDate(String date) {
    if (date.isEmpty) return null;
    try {
      final dt = DateTime.parse(date).toLocal();
      final formatted =
          "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} | ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}.${dt.second.toString().padLeft(2, '0')}";
      return Text(formatted);
    } catch (_) {
      return Text(date);
    }
  }

  void _handleEdit(BuildContext context, String title, bool isDone) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => MyCreateDialog(
        initialText: title,
        initialFolder: task['folder'] as String?,
        initialCategory: task['category'] as String?,
        initialIsDone: isDone,
        initialColor: task['color'] as int?,
        onTapSave: (taskName, isDone, folder, category, color) {
          provider.editTask(
            realIndex,
            taskName,
            isDone: isDone,
            folder: folder,
            category: category,
            color: color,
          );
        },
      ),
    );
  }

  void _handleInfo(
    BuildContext context,
    String taskTitle,
    String date,
    String folder,
    String category,
    bool isDone,
  ) {
    Navigator.pop(context);
    showInfoDetailsDialog(
      context: context,
      title: 'Info',
      details: [
        "Task: $taskTitle",
        "Date: $date",
        "Folder: $folder",
        "Category: $category",
        "Is Done: $isDone",
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context, String taskTitle) async {
    bool shouldDelete = true;

    if (provider.confirmDelete) {
      shouldDelete =
          await showConfirmationDialog(
            context: context,
            title: 'Delete task?',
            content: 'Delete "$taskTitle"?',
            confirmText: AppConstants.buttonDelete,
            isDestructive: true,
          ) ??
          false;
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (shouldDelete) {
      provider.deleteTask(realIndex);
    }
  }
}
