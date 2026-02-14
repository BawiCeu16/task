import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/utils/category_icons_helper.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  String? _renamingCategory;
  final _renameController = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();

  void _exitRenameMode() {
    setState(() {
      _renamingCategory = null;
      _renameController.clear();
    });
  }

  void _startRenameMode(String name) {
    setState(() {
      _renameController.text = name;
      _renamingCategory = name;
    });
  }

  void _performRename(TaskProvider provider, String oldName, String newName) {
    if (newName.isEmpty || newName == oldName) {
      _exitRenameMode();
      return;
    }
    try {
      // Auto-update icon on rename
      final newIcon = CategoryIconsHelper.getIconForCategory(newName);
      provider.renameCategory(oldName, newName, icon: newIcon.codePoint);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Renamed "$oldName" to "$newName"')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      _exitRenameMode();
    }
  }

  Future<bool?> _confirm(String title, String body) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    // Use categoryList to get access to icon data
    final categories = provider.categoryList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        centerTitle: true,
        actions: [
          if (categories.isNotEmpty)
            IconButton(
              icon: Icon(remixIcon(Icons.delete_sweep_outlined)),
              tooltip: 'Delete all categories',
              onPressed: () async {
                final confirm = await _confirm(
                  'Delete all categories',
                  'This will remove all categories. Do you also want to delete tasks inside them?',
                );
                if (confirm == true) {
                  final deleteTasks = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => SimpleDialog(
                      title: const Text('Also delete category tasks?'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Keep tasks (unset category)'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete tasks too'),
                        ),
                      ],
                    ),
                  );

                  if (deleteTasks == null) return;

                  try {
                    provider.deleteAllCategories(deleteTasks: deleteTasks);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All categories cleared')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                }
              },
            ),
        ],
      ),
      body: categories.isEmpty
          ? Center(
              child: Text(
                'No categories',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final catData = categories[index];
                  final categoryName = (catData['name'] ?? '').toString();
                  final catIconCode =
                      catData['icon']
                          as int?; // Kept for backward compatibility

                  // Use CategoryIconsHelper to get const icon based on category name
                  final iconData = CategoryIconsHelper.getIconForCategory(
                    categoryName,
                  );

                  final isRenaming = _renamingCategory == categoryName;
                  final count = provider.tasksInCategory(categoryName).length;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: isRenaming
                        ? Form(
                            key: _renameFormKey,
                            child: ListTile(
                              title: TextFormField(
                                controller: _renameController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                                onFieldSubmitted: (v) => _performRename(
                                  provider,
                                  categoryName,
                                  v.trim(),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Cannot be empty'
                                    : null,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(remixIcon(Icons.check)),
                                    onPressed: () {
                                      if (_renameFormKey.currentState!
                                          .validate()) {
                                        _performRename(
                                          provider,
                                          categoryName,
                                          _renameController.text.trim(),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(remixIcon(Icons.close)),
                                    onPressed: _exitRenameMode,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListTile(
                            leading: Icon(
                              iconData,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(categoryName),
                            subtitle: Text(
                              '$count task${count == 1 ? '' : 's'}',
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (v) async {
                                if (v == 'rename') {
                                  _startRenameMode(categoryName);
                                } else if (v == 'delete') {
                                  final ok = await _confirm(
                                    'Delete Category',
                                    'Delete "$categoryName" and unset it from tasks?',
                                  );
                                  if (ok == true) {
                                    try {
                                      provider.deleteCategory(categoryName);
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    }
                                  }
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'rename',
                                  child: Text('Rename'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
    );
  }
}
