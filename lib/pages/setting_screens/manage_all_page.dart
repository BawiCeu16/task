import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/pages/setting_screens/manage_tasks_page.dart';
import 'package:task/pages/setting_screens/manage_folders_page.dart';
import 'package:task/pages/setting_screens/manage_categories_page.dart';

// 1. Convert to StatefulWidget
class ManageAllPage extends StatefulWidget {
  const ManageAllPage({super.key});

  @override
  State<ManageAllPage> createState() => _ManageAllPageState();
}

class _ManageAllPageState extends State<ManageAllPage> {
  // 2. State variables to manage inline editing
  String? _renamingFolder;
  String? _renamingCategory;
  final _renameController = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();

  // existing _confirm method (unchanged, omitted for brevity)
  Future<bool?> _confirm(BuildContext c, String title, String body) {
    return showDialog<bool>(
      context: c,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        title: Text(title),
        content: Text(body),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(ctx).colorScheme.error,
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // existing _formatDateSafe method (unchanged, omitted for brevity)
  String _formatDateSafe(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return DateFormat.yMMMd().add_jm().format(dt);
    } catch (_) {
      return '-';
    }
  }

  // Helper to exit rename mode
  void _exitRenameMode() {
    setState(() {
      _renamingFolder = null;
      _renamingCategory = null;
      _renameController.clear();
    });
  }

  // Helper to start rename mode
  void _startRenameMode(String name, bool isFolder) {
    _exitRenameMode(); // Ensure any other renaming stops
    setState(() {
      _renameController.text = name;
      if (isFolder) {
        _renamingFolder = name;
      } else {
        _renamingCategory = name;
      }
    });
  }

  // Helper for actual renaming logic
  void _performRename(
    BuildContext context,
    TaskProvider provider,
    String oldName,
    String newName,
    bool isFolder,
  ) {
    if (newName.isEmpty || newName == oldName) {
      _exitRenameMode();
      return;
    }

    try {
      if (isFolder) {
        provider.renameFolder(oldName, newName);
      } else {
        provider.renameCategory(oldName, newName);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Renamed "$oldName" to "$newName"')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error renaming: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      _exitRenameMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final folders = provider.folders;
    final categories = provider.categories;
    final tasks = provider.tasks;

    // ... summary metrics logic (omitted for brevity) ...
    final totalTasks = tasks.length;
    final totalFolders = folders.length;
    final totalCategories = categories.length;
    final completed = tasks.where((t) => (t['isDone'] ?? false) as bool).length;
    final incomplete = totalTasks - completed;
    final withoutFolder = tasks
        .where((t) => (t['folder'] ?? '').toString().isEmpty)
        .length;
    final withoutCategory = tasks
        .where((t) => (t['category'] ?? '').toString().isEmpty)
        .length;

    DateTime? oldest;
    DateTime? newest;
    for (var t in tasks) {
      final iso = (t['createdDate'] ?? '') as String;
      try {
        final dt = DateTime.parse(iso);
        if (oldest == null || dt.isBefore(oldest)) oldest = dt;
        if (newest == null || dt.isAfter(newest)) newest = dt;
      } catch (_) {}
    }

    final oldestStr = oldest == null ? '-' : DateFormat.yMMMd().format(oldest);
    final newestStr = newest == null ? '-' : DateFormat.yMMMd().format(newest);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        children: [
          // --- Summary cards row --- (unchanged)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _StatCard(
                        label: 'Tasks',
                        value: totalTasks.toString(),
                        subtitle: 'Total',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ManageTasksPage(title: 'All Tasks'),
                          ),
                        ),
                      ),
                      _StatCard(
                        label: 'Folders',
                        value: totalFolders.toString(),
                        subtitle: 'Total',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageFoldersPage(),
                          ),
                        ),
                      ),
                      _StatCard(
                        label: 'Categories',
                        value: totalCategories.toString(),
                        subtitle: 'Total',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageCategoriesPage(),
                          ),
                        ),
                      ),
                      _StatCard(
                        label: 'Completed',
                        value: completed.toString(),
                        subtitle: 'Done',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageTasksPage(
                              title: 'Completed Tasks',
                              filter: 'completed',
                            ),
                          ),
                        ),
                      ),
                      _StatCard(
                        label: 'Incomplete',
                        value: incomplete.toString(),
                        subtitle: 'Pending',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageTasksPage(
                              title: 'Pending Tasks',
                              filter: 'incomplete',
                            ),
                          ),
                        ),
                      ),
                      _StatCard(
                        label: 'No Folder',
                        value: withoutFolder.toString(),
                        subtitle: 'Unsorted',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageTasksPage(
                              title: 'Unsorted Tasks',
                              filter: 'no_folder',
                            ),
                          ),
                        ),
                      ),
                      _StatCard(
                        label: 'No Category',
                        value: withoutCategory.toString(),
                        subtitle: 'Uncategorized',
                        width: 160,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageTasksPage(
                              title: 'Uncategorized Tasks',
                              filter: 'no_category',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Text('Oldest: $oldestStr')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Newest: $newestStr',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // --- quick actions ---
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick actions",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 5.0),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Delete all folders button
                      FilledButton.tonal(
                        onPressed: () async {
                          final confirm = await _confirm(
                            context,
                            'Delete all folders',
                            'Delete all folders. This can also remove tasks inside them.',
                          );
                          if (confirm == true) {
                            final deleteTasks = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text('Also delete folder tasks?'),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text(
                                      'Keep tasks (unset folder)',
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete tasks too'),
                                  ),
                                ],
                              ),
                            );

                            // Handle dialog dismissal
                            if (deleteTasks == null) return;

                            try {
                              provider.deleteAllFolders(
                                deleteTasks: deleteTasks,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All folders cleared'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Delete all folders'),
                      ),

                      // Clear folder tags button
                      FilledButton.tonal(
                        onPressed: () async {
                          final confirm = await _confirm(
                            context,
                            'Clear folder tags',
                            'Unset folder tag from all tasks (keeps the tasks).',
                          );
                          if (confirm == true) {
                            try {
                              provider.deleteAllFolders(deleteTasks: false);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Folder tags cleared'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Clear folder tags'),
                      ),
                      // Delete all categories button
                      FilledButton.tonal(
                        onPressed: () async {
                          final confirm = await _confirm(
                            context,
                            'Delete all categories',
                            'Delete all categories. Optionally remove tasks in those categories.',
                          );
                          if (confirm == true) {
                            final deleteTasks = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text(
                                  'Also delete category tasks?',
                                ),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text(
                                      'Keep tasks (unset category)',
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete tasks too'),
                                  ),
                                ],
                              ),
                            );

                            // Handle dialog dismissal
                            if (deleteTasks == null) return;

                            try {
                              provider.deleteAllCategories(
                                deleteTasks: deleteTasks,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All categories cleared'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Delete all categories'),
                      ),
                      // Clear category tags button
                      FilledButton.tonal(
                        onPressed: () async {
                          final confirm = await _confirm(
                            context,
                            'Clear category tags',
                            'Unset category tag from all tasks (keeps the tasks).',
                          );
                          if (confirm == true) {
                            try {
                              provider.deleteAllCategories(deleteTasks: false);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Category tags cleared'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Clear all tasks'),
                      ),

                      // Delete all tasks button
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Clear all tasks?'),
                              content: const Text(
                                'This will permanently delete all tasks. This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Clear All'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            try {
                              await context
                                  .read<TaskProvider>()
                                  .deleteAllTasks();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('All tasks cleared'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Clear all tasks'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final double width;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.width = 140,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
