import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/category_list_item.dart';
import 'package:task/widgets/create_category_dialog.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/utils/category_icons_helper.dart';
import 'package:task/pages/main_pages/category_detail_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    // Use categoryList to get access to icon data
    final cats = provider.categoryList;

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
                  final catData = cats[i];
                  final catName = (catData['name'] ?? '').toString();
                  final catIconCode = catData['icon'] as int?;
                  final count = provider.tasksInCategory(catName).length;

                  return CategoryListItem(
                    categoryName: catName,
                    iconCode: catIconCode,
                    taskCount: count,
                    onLongPress: () =>
                        _showCategoryOptions(context, provider, catName),
                  );
                }, childCount: cats.length),
              ),
            ),
        ],
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
              // Auto-update icon on rename
              final newIcon = CategoryIconsHelper.getIconForCategory(newName);
              Provider.of<TaskProvider>(context, listen: false).renameCategory(
                widget.startName,
                newName,
                icon: newIcon.codePoint,
              );
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
