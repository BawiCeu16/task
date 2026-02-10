import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task/pages/main_pages/category_page.dart';
import 'package:task/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/create_dialog.dart';
import 'package:task/pages/main_pages/folder_page.dart';
import 'package:task/widgets/list_item.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/pages/main_pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final displayedTasks = provider.getSortedTasks();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >= 800; // threshold for desktop layout

        // content area (we need to pass tasks into _MainPage)
        final pages = <Widget>[
          _MainPage(tasks: displayedTasks),
          const SearchPage(),
          const FolderPage(),
          const CategoryPage(),
        ];

        // When wide: show NavigationRail at left and content to the right
        if (isWide) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (i) =>
                        setState(() => _selectedIndex = i),
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(remixIcon(Icons.list_outlined)),
                        selectedIcon: Icon(remixIcon(Icons.list)),
                        label: const Text('Tasks'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(remixIcon(Icons.search_outlined)),
                        selectedIcon: Icon(remixIcon(Icons.search)),
                        label: const Text('Search'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(remixIcon(Icons.folder_open_outlined)),
                        selectedIcon: Icon(remixIcon(Icons.folder)),
                        label: const Text('Folders'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(remixIcon(Icons.label_outline)),
                        selectedIcon: Icon(remixIcon(Icons.label)),
                        label: const Text('Categories'),
                      ),
                    ],
                    labelType: NavigationRailLabelType.selected,
                    trailingAtBottom: true,
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton.filledTonal(
                          icon: Icon(remixIcon(Icons.settings)),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => const SettingsPage(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  // Vertical divider between rail and content
                  const VerticalDivider(width: 1),

                  // Main content
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: pages[_selectedIndex],
                    ),
                  ),
                ],
              ),
            ),

            // FloatingActionButton stays, positioned at bottom-right for desktop
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateDialog(context),
              child: Icon(remixIcon(Icons.add)),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        }

        // Mobile / narrow: use original Scaffold with bottom navigation
        return Scaffold(
          extendBody:
              true, // This allows the body to hide COMPLETELY behind the nav bar
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final ScrollDirection direction = notification.direction;
                if (direction == ScrollDirection.reverse) {
                  if (_isVisible) setState(() => _isVisible = false);
                } else if (direction == ScrollDirection.forward) {
                  if (!_isVisible) setState(() => _isVisible = true);
                }
                return true;
              },
              child: Padding(
                // Add bottom padding only when nav bar is visible or enough to see content
                padding: EdgeInsets.only(bottom: _isVisible ? 80 : 0),
                child: IndexedStack(index: _selectedIndex, children: pages),
              ),
            ),
          ),
          floatingActionButton: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: _isVisible ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isVisible ? 1.0 : 0.0,
              child: FloatingActionButton.extended(
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                highlightElevation: 0,
                onPressed: () => _showCreateDialog(context),
                icon: Icon(remixIcon(Icons.add)),
                label: const Text("Create Task"),
              ),
            ),
          ),
          bottomNavigationBar: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: _isVisible ? Offset.zero : const Offset(0, 1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isVisible ? 1.0 : 0.0,
              child: NavigationBar(
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (i) =>
                    setState(() => _selectedIndex = i),
                destinations: [
                  NavigationDestination(
                    icon: Icon(remixIcon(Icons.list_alt_outlined)),
                    selectedIcon: Icon(remixIcon(Icons.list_alt)),
                    label: 'Tasks',
                  ),
                  NavigationDestination(
                    icon: Icon(remixIcon(Icons.search_outlined)),
                    selectedIcon: Icon(remixIcon(Icons.search)),
                    label: 'Search',
                  ),
                  NavigationDestination(
                    icon: Icon(remixIcon(Icons.folder_outlined)),
                    selectedIcon: Icon(remixIcon(Icons.folder)),
                    label: 'Folders',
                  ),
                  NavigationDestination(
                    icon: Icon(remixIcon(Icons.toc_outlined)),
                    selectedIcon: Icon(remixIcon(Icons.toc)),
                    label: 'Categories',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MyCreateDialog(
        onTapSave: (taskName, isDone, folder, category, color) {
          final provider = Provider.of<TaskProvider>(context, listen: false);
          provider.createTask(
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
}

/// Main page implementation that was previously inside home_screen.
/// Accepts tasks list so it can be reused in both mobile and desktop layout.
class _MainPage extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  const _MainPage({required this.tasks});

  String _labelForSortOption(SortOption s) {
    switch (s) {
      case SortOption.newestFirst:
        return 'Newest first';
      case SortOption.oldestFirst:
        return 'Oldest first';
      case SortOption.alphaAsc:
        return 'A → Z';
      case SortOption.alphaDesc:
        return 'Z → A';
      case SortOption.completedFirst:
        return 'Completed first';
      case SortOption.incompleteFirst:
        return 'Incomplete first';
      case SortOption.color:
        return 'Color';
      case SortOption.folder:
        return 'Folder';
      case SortOption.category:
        return 'Category';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: const Text('Tasks'),
          centerTitle: true,
          actions: _buildActions(context, provider),
          floating: true,
          snap: true,
          scrolledUnderElevation: 0,
        ),
        if (tasks.isEmpty)
          const SliverFillRemaining(child: Center(child: Text('No tasks')))
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = tasks[index];
                final title = (task['task'] ?? '') as String;
                final isDone = (task['isDone'] ?? false) as bool;
                final date = (task['createdDate'] ?? '') as String;
                final id = (task['id'] ?? '') as String;
                final color = task['color'] as int?;
                final realIndex = Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).tasks.indexWhere((t) => (t['id'] ?? '') == id);

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
                        Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        ).toggleIsDone(realIndex);
                      }
                    },
                    onLongPress: () {
                      if (realIndex != -1) {
                        _showTaskBottomSheet(
                          context,
                          provider,
                          realIndex,
                          task,
                        );
                      }
                    },
                  ),
                );
              }, childCount: tasks.length),
            ),
          ),
      ],
    );
  }

  // list / content area (removed as it's now integrated above)

  void _showTaskBottomSheet(
    BuildContext context,
    TaskProvider provider,
    int realIndex,
    Map<String, dynamic> task,
  ) {
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
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SwitchListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  title: const Text('Done'),
                  value: isDone,
                  onChanged: (_) {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).toggleIsDone(realIndex);
                    Navigator.pop(context);
                  },
                ),
              ),
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
                          Provider.of<TaskProvider>(
                            context,
                            listen: false,
                          ).editTask(
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
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 1.5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                            Text("Is Done: $isDone"),
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
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 1.5),
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
                    if (confirm) provider.deleteTask(realIndex);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _labelForFilter(TaskFilter f) {
    switch (f) {
      case TaskFilter.all:
        return 'All tasks';
      case TaskFilter.complete:
        return 'Completed';
      case TaskFilter.incomplete:
        return 'Incomplete';
    }
  }

  // common actions for appBar (sort, filter, settings)
  List<Widget> _buildActions(BuildContext context, TaskProvider provider) {
    return [
      // Filter menu
      PopupMenuButton<TaskFilter>(
        elevation: 0,
        icon: Icon(remixIcon(Icons.filter_list)),
        tooltip: 'Filter',
        onSelected: (filter) => provider.setTaskFilter(filter),
        itemBuilder: (ctx) => TaskFilter.values.map((f) {
          final isSelected = provider.currentFilter == f;
          IconData icon;
          switch (f) {
            case TaskFilter.all:
              icon = Icons.list;
              break;
            case TaskFilter.complete:
              icon = Icons.check_circle_outline;
              break;
            case TaskFilter.incomplete:
              icon = Icons.circle_outlined;
              break;
          }
          return PopupMenuItem<TaskFilter>(
            value: f,
            child: Row(
              children: [
                Icon(remixIcon(icon), size: 18),
                const SizedBox(width: 12),
                Expanded(child: Text(_labelForFilter(f))),
                if (isSelected) Icon(remixIcon(Icons.check), size: 16),
              ],
            ),
          );
        }).toList(),
      ),
      // Sort menu
      PopupMenuButton<SortOption>(
        elevation: 0,
        icon: Icon(remixIcon(Icons.sort)),
        tooltip: 'Sort',
        onSelected: (opt) => provider.setSortOption(opt),
        itemBuilder: (ctx) => SortOption.values.map((opt) {
          final isSelected = provider.currentSortOption == opt;
          return PopupMenuItem<SortOption>(
            value: opt,
            child: Row(
              children: [
                if (isSelected)
                  Icon(remixIcon(Icons.check), size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(_labelForSortOption(opt)),
              ],
            ),
          );
        }).toList(),
      ),
      IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        ),
        icon: Icon(remixIcon(Icons.settings)),
      ),
    ];
  }
}
