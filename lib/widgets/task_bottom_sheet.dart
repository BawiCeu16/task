import 'package:flutter/material.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/create_dialog.dart';
import 'package:task/widgets/icon_mapper.dart';

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
    final title = (task['task'] ?? '') as String;
    final isDone = (task['isDone'] ?? false) as bool;
    final date = (task['createdDate'] ?? '') as String;
    final folder = (task['folder'] ?? 'None') as String;
    final category = (task['category'] ?? 'None') as String;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
        child: Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(title),
              subtitle: Builder(
                builder: (context) {
                  String formattedDate = date;
                  try {
                    final dt = DateTime.parse(date).toLocal();
                    formattedDate =
                        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} | ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}.${dt.second.toString().padLeft(2, '0')}";
                  } catch (_) {}
                  return Text(formattedDate);
                },
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: SwitchListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                title: const Text('Done'),
                value: isDone,
                onChanged: (_) {
                  provider.toggleIsDone(realIndex);
                  Navigator.pop(context);
                },
              ),
            ),

            // Edit ListItem
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(top: 0, bottom: 1.5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                leading: Icon(remixIcon(Icons.edit)),
                title: const Text('Edit'),
                onTap: () {
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
                },
              ),
            ),

            // Info ListItem
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(top: 1.5, bottom: 1.5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                leading: Icon(remixIcon(Icons.info)),
                title: const Text('Info'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Task: $title"),
                          Text("Date: $date"),
                          Text("Folder: $folder"),
                          Text("Category: $category"),
                          Text("Is Done: ${isDone.toString()}"),
                        ],
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                      title: const Text('Info'),
                    ),
                  );
                },
              ),
            ),

            // Delete ListItem
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(top: 1.5, bottom: 0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                leading: Icon(
                  remixIcon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('Delete'),
                onTap: () async {
                  bool confirm = true;
                  if (provider.confirmDelete) {
                    confirm =
                        await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete task?'),
                            content: Text('Delete "$title"?'),
                            actions: [
                              FilledButton.tonal(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  }

                  if (context.mounted) {
                    Navigator.pop(context); // Pop bottom sheet
                  }
                  if (confirm) {
                    provider.deleteTask(realIndex);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
