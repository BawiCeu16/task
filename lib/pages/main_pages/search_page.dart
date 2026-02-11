import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/widgets/task_list_view.dart';
import 'package:task/pages/main_pages/folder_detail_page.dart';
import 'package:task/pages/main_pages/category_detail_page.dart';

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
                  TaskListView(
                    tasks: allTasks.where((item) {
                      final title = (item['task'] ?? '')
                          .toString()
                          .toLowerCase();
                      final matchesQuery = title.contains(_query.toLowerCase());
                      if (!provider.showCompleted) {
                        return matchesQuery && !(item['isDone'] ?? false);
                      }
                      return matchesQuery;
                    }).toList(),
                    provider: provider,
                  ),
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

    if (type == 'tasks') {
      // Handled directly in TabBarView now, but keeping for structure if needed
      return TaskListView(
        tasks: results.cast<Map<String, dynamic>>(),
        provider: provider,
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];

        if (type == 'folders') {
          final name = (item['name'] ?? '') as String;
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(remixIcon(Icons.folder_outlined)),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FolderDetailPage(folderName: name),
                  ),
                );
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
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailPage(categoryName: name),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
