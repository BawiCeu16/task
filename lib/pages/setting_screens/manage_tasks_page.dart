import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:intl/intl.dart';

class ManageTasksPage extends StatelessWidget {
  final String title;
  final String? filter;

  const ManageTasksPage({super.key, required this.title, this.filter});

  List<Map<String, dynamic>> _getFilteredTasks(TaskProvider provider) {
    var tasks = provider.tasks;
    if (filter == 'completed') {
      return tasks.where((t) => (t['isDone'] ?? false) == true).toList();
    } else if (filter == 'incomplete') {
      return tasks.where((t) => (t['isDone'] ?? false) == false).toList();
    } else if (filter == 'no_folder') {
      return tasks
          .where((t) => (t['folder'] ?? '').toString().isEmpty)
          .toList();
    } else if (filter == 'no_category') {
      return tasks
          .where((t) => (t['category'] ?? '').toString().isEmpty)
          .toList();
    }
    return tasks;
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return DateFormat.yMMMd().format(dt);
    } catch (_) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = _getFilteredTasks(provider);

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    remixIcon(Icons.assignment_turned_in_outlined),
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final isDone = (task['isDone'] ?? false) as bool;
                  final taskText = (task['task'] ?? '').toString();
                  final createdDate = (task['createdDate'] ?? '') as String;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.3),
                    child: ListTile(
                      leading: Checkbox(
                        value: isDone,
                        onChanged: (val) {
                          try {
                            final fullListIndex = provider.tasks.indexOf(task);
                            if (fullListIndex != -1) {
                              provider.toggleIsDone(fullListIndex);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                      title: Text(
                        taskText,
                        style: TextStyle(
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: isDone
                              ? Theme.of(context).colorScheme.outline
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        'Created: ${_formatDate(createdDate)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: IconButton(
                        icon: Icon(remixIcon(Icons.delete_outline)),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                'Are you sure you want to delete this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              final fullListIndex = provider.tasks.indexOf(
                                task,
                              );
                              if (fullListIndex != -1) {
                                provider.deleteTask(fullListIndex);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
