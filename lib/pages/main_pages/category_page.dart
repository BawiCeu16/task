import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/create_category_dialog.dart';
import 'package:task/widgets/list_item.dart';
import 'package:task/widgets/create_dialog.dart';
import 'package:task/widgets/icon_mapper.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final cats = provider.categories;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('Categories'),
            actions: [
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const CreateCategoryDialog(),
                ),
                icon: Icon(remixIcon(Icons.add)),
              ),
            ],
            centerTitle: true,
            floating: true,
            snap: true,
            scrolledUnderElevation: 0,
          ),
          if (cats.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("There's No Categories"),
                    const SizedBox(height: 10),
                    FilledButton(
                      child: const Text("Add New Categories"),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const CreateCategoryDialog(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final cat = cats[i];
                  final tasks = provider.tasksInCategory(cat);
                  final count = tasks.length;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          cat,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('$count task${count == 1 ? "" : "s"}'),
                        trailing: Icon(remixIcon(Icons.chevron_right)),
                        onTap: () => _openCategoryPage(context, provider, cat),
                        onLongPress: () =>
                            _showCategoryOptions(context, provider, cat),
                      ),
                    ),
                  );
                }, childCount: cats.length),
              ),
            ),
        ],
      ),
    );
  }

  //This is example dialog not usable!
  // void _showCreateCategoryDialog(BuildContext context) {
  //   final controller = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: const Text('Create Category'),
  //       content: TextField(
  //         controller: controller,
  //         decoration: const InputDecoration(hintText: 'Category name'),
  //         autofocus: true,
  //       ),
  //       actions: [
  //         FilledButton.tonal(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Cancel'),
  //         ),
  //         FilledButton(
  //           onPressed: () {
  //             final name = controller.text.trim();
  //             if (name.isNotEmpty) {
  //               Provider.of<TaskProvider>(
  //                 context,
  //                 listen: false,
  //               ).createCategory(name);
  //             }
  //             Navigator.pop(ctx);
  //           },
  //           child: const Text('Create'),
  //         ),
  //       ],
  //     ),
  //   ).then((_) => controller.dispose());
  // }

  void _openCategoryPage(
    BuildContext context,
    TaskProvider provider,
    String cat,
  ) {
    // Push a page that reads tasks from provider dynamically using Consumer.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Consumer<TaskProvider>(
          builder: (c, prov, _) {
            final categoryTasks = prov.tasksInCategory(cat);
            return Scaffold(
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    title: Text(cat),
                    floating: true,
                    snap: true,
                    scrolledUnderElevation: 0,
                  ),
                  if (categoryTasks.isEmpty)
                    SliverFillRemaining(
                      child: Center(child: Text('No tasks in "$cat"')),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final task = categoryTasks[index];
                          final id = (task['id'] ?? '') as String;
                          final realIndex = prov.tasks.indexWhere(
                            (t) => (t['id'] ?? '') == id,
                          );
                          final title = (task['task'] ?? '') as String;
                          final isDone = (task['isDone'] ?? false) as bool;
                          final date = (task['createdDate'] ?? '') as String;
                          final color = task['color'] as int?;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: MyListItem(
                              title: title,
                              isDone: isDone,
                              date: date,
                              color: color,
                              onTap: () {
                                if (realIndex != -1) {
                                  prov.toggleIsDone(realIndex);
                                }
                              },
                              onLongPress: () =>
                                  _showTaskBottom(c, prov, realIndex, task),
                            ),
                          );
                        }, childCount: categoryTasks.length),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTaskBottom(
    BuildContext context,
    TaskProvider provider,
    int idx,
    Map<String, dynamic> task,
  ) {
    if (idx == -1) return;
    final title = (task['task'] ?? '') as String;
    final isDone = (task['isDone'] ?? false) as bool;
    final date = (task['createdDate'] ?? '') as String;
    final folder = (task['folder'] ?? '') as String;
    final category = (task['category'] ?? '') as String;

    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (_) => Padding(
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
                  borderRadius: BorderRadiusGeometry.circular(100),
                ),
                child: SwitchListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100),
                  ),
                  title: const Text('Done'),
                  value: isDone,
                  onChanged: (_) {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).toggleIsDone(idx);
                    Navigator.pop(context);
                  },
                ),
              ),

              //Edit ListItem
              Card(
                elevation: 0,

                margin: const EdgeInsets.only(
                  top: 0,
                  bottom: 1.5,
                  left: 0,
                  right: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
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
                          Provider.of<TaskProvider>(
                            context,
                            listen: false,
                          ).editTask(
                            idx,
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

              //Edit ListItem
              Card(
                elevation: 0,

                margin: const EdgeInsets.only(
                  top: 1.5,
                  bottom: 1.5,
                  left: 0,
                  right: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
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
                            Text(
                              "Task: $title",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "Date: $date",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "Folder: $folder",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "Category: $category",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "Is Done: ${isDone.toString()}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                        title: const Text('Info'),
                      ),
                    );
                  },
                ),
              ),

              //Delete ListItem
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(
                  top: 1.5,

                  bottom: 0,
                  left: 0,
                  right: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
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
                                  onPressed: () =>
                                      Navigator.pop(context, false),
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

                    Navigator.pop(context);
                    if (confirm) provider.deleteTask(idx);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryOptions(
    BuildContext context,
    TaskProvider provider,
    String cat,
  ) {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: [
              ListTile(
                title: Text(cat),
                subtitle: Text(
                  '${provider.tasksInCategory(cat).length} tasks inside',
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 0, bottom: 1.5),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  leading: Icon(remixIcon(Icons.edit)),
                  title: const Text('Edit Category'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => _EditCategoryDialog(startName: cat),
                    );
                  },
                ),
              ),

              Card(
                margin: EdgeInsets.only(top: 1.5, bottom: 0),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),

                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),

                  leading: Icon(
                    remixIcon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: const Text('Delete Category'),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Category?'),
                        content: Text(
                          'Delete category "$cat"? This will remove the category tag from tasks.',
                        ),
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
                    );
                    Navigator.pop(context);
                    if (confirm == true) {
                      provider.deleteCategory(cat);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deleted category "$cat"')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditCategoryDialog extends StatefulWidget {
  final String startName;
  const _EditCategoryDialog({required this.startName});

  @override
  State<_EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<_EditCategoryDialog> {
  late TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.startName);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Edit Category'),
      content: TextField(
        controller: _c,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Category name'),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final newName = _c.text.trim();
            if (newName.isNotEmpty && newName != widget.startName) {
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).renameCategory(widget.startName, newName);
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
