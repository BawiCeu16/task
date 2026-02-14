import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/widgets/task_list_view.dart';
import 'package:task/pages/main_pages/folder_detail_page.dart';
import 'package:task/widgets/category_list_item.dart';

class SearchPage extends StatefulWidget {
  final Function(bool)? onScrollDirectionChanged;
  const SearchPage({super.key, this.onScrollDirectionChanged});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

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
    final allCategories = provider.categoryList;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // SliverAppBar with SearchBar - hides on scroll
              SliverAppBar(
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                floating: true,
                snap: true,
                pinned: false,
                toolbarHeight: 80,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
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
              ),
              // TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    tabs: const [
                      Tab(text: 'Tasks'),
                      Tab(text: 'Folders'),
                      Tab(text: 'Categories'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Tasks Tab
              TaskListView(
                tasks: allTasks.where((item) {
                  final title = (item['task'] ?? '').toString().toLowerCase();
                  final matchesQuery = title.contains(_query.toLowerCase());
                  if (!provider.showCompleted) {
                    return matchesQuery && !(item['isDone'] ?? false);
                  }
                  return matchesQuery;
                }).toList(),
                provider: provider,
              ),
              // Folders Tab
              _buildResults(_query, allFolders, 'folders', provider),
              // Categories Tab
              _buildResults(_query, allCategories, 'categories', provider),
            ],
          ),
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
        // categories - now a map with 'name' and 'icon'
        title = (item['name'] ?? '').toString().toLowerCase();
      }
      return title.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(child: Text('No matching $type found'));
    }

    if (type == 'tasks') {
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
          final taskCount = provider.tasksInFolder(name).length;

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(remixIcon(Icons.folder_outlined)),
              title: Text(name),
              subtitle: Text('$taskCount task${taskCount == 1 ? '' : 's'}'),
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
          final catData = item as Map<String, dynamic>;
          final name = (catData['name'] ?? '').toString();
          final catIconCode = catData['icon'] as int?;
          final taskCount = provider.tasksInCategory(name).length;

          return CategoryListItem(
            categoryName: name,
            iconCode: catIconCode,
            taskCount: taskCount,
          );
        }
      },
    );
  }
}

// Custom SliverPersistentHeaderDelegate for TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
