import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/list_item.dart';
import 'package:task/widgets/create_dialog.dart';
import 'package:task/widgets/icon_mapper.dart';

class SearchPage extends StatefulWidget {
  final Function(bool)? onScrollDirectionChanged;
  const SearchPage({super.key, this.onScrollDirectionChanged});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isAppBarVisible = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final allTasks = provider.tasks;
    final allFolders = provider.folderList;
    final allCategories = provider.categories;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                controller: _searchController,
                hintText: 'Search...',
                leading: Icon(remixIcon(Icons.search)),
                onChanged: (val) {
                  setState(() {
                    _query = val;
                  });
                },
                trailing: [
                  if (_query.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        icon: Icon(remixIcon(Icons.clear)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Tasks'),
                Tab(text: 'Folders'),
                Tab(text: 'Categories'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildResults(_query, allTasks, 'tasks', provider),
                  _buildResults(_query, allFolders, 'folders', provider),
                  _buildResults(_query, allCategories, 'categories', provider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(
    String query,
    List<dynamic> allData,
    String type,
    TaskProvider provider,
  ) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              remixIcon(Icons.search),
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Type to search $type',
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ],
        ),
      );
    }

    final List<dynamic> results = allData.where((item) {
      String title = '';
      if (type == 'tasks') {
        title = (item['task'] ?? '').toString().toLowerCase();
        final matchesQuery = title.contains(query.toLowerCase());
        if (!provider.showCompleted) {
          return matchesQuery && !(item['isDone'] ?? false);
        }
        return matchesQuery;
      } else if (type == 'folders') {
        title = (item['name'] ?? '').toString().toLowerCase();
      } else {
        // categories
        title = item.toString().toLowerCase();
      }
      return title.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(child: Text('No matching $type found'));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];

        if (type == 'tasks') {
          final id = (item['id'] ?? '') as String;
          final realIndex = provider.tasks.indexWhere(
            (t) => (t['id'] ?? '') == id,
          );
          final title = (item['task'] ?? '') as String;
          final isDone = (item['isDone'] ?? false) as bool;
          final date = (item['createdDate'] ?? '') as String;
          final color = item['color'] as int?;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
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
                  _showTaskBottomSheet(context, provider, realIndex, item);
                }
              },
            ),
          );
        } else if (type == 'folders') {
          final name = (item['name'] ?? '') as String;
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(remixIcon(Icons.folder_outlined)),
              title: Text(name),
              onTap: () {
                // Future: navigate to folder search results or home filtered by folder
              },
            ),
          );
        } else {
          // categories
          final name = item as String;
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(remixIcon(Icons.label_outline)),
              title: Text(name),
              onTap: () {
                // Future: navigate to category search results or home filtered by category
              },
            ),
          );
        }
      },
    );
  }

  void _showTaskBottomSheet(
    BuildContext context,
    TaskProvider provider,
    int idx,
    Map<String, dynamic> task,
  ) {
    if (idx == -1) return;
    final title = (task['task'] ?? '') as String;
    final isDone = (task['isDone'] ?? false) as bool;
    final date = (task['createdDate'] ?? '') as String;
    final folder = (task['folder'] ?? 'None') as String;
    final category = (task['category'] ?? 'None') as String;

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
                    provider.toggleIsDone(idx);
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
                          provider.editTask(
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
}
