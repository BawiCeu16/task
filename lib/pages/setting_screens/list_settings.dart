import 'package:flutter/material.dart';
import 'package:task/provider/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:task/widgets/icon_mapper.dart';

class ListSettings extends StatelessWidget {
  const ListSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // Only rebuild when the sort option changes
    final currentSort = context.select<TaskProvider, SortOption>(
      (p) => p.currentSortOption,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("List"),
        centerTitle: true,
        animateColor: true,
        scrolledUnderElevation: 0,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'Sort',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,

                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            // --- Sort menu tile ---
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Builder(
                builder: (tileContext) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: const Text('Order'),
                    subtitle: Text(_labelForSortOption(currentSort)),
                    trailing: Icon(remixIcon(Icons.arrow_drop_down)),
                    onTap: () async {
                      final selected = await showMenu<SortOption>(
                        elevation: 0.0,
                        context: tileContext,
                        position: const RelativeRect.fromLTRB(200, 250, 16, 0),
                        items: SortOption.values.map((opt) {
                          return PopupMenuItem<SortOption>(
                            value: opt,
                            child: Row(
                              children: [
                                if (opt == currentSort) ...[
                                  Icon(remixIcon(Icons.check), size: 18),
                                  const SizedBox(width: 8),
                                ] else
                                  const SizedBox(width: 26),
                                Text(_labelForSortOption(opt)),
                              ],
                            ),
                          );
                        }).toList(),
                      );

                      if (selected != null) {
                        context.read<TaskProvider>().setSortOption(selected);
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'View',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 1.5),

                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: SwitchListTile(
                    title: const Text('Show completed tasks'),
                    subtitle: const Text('Display tasks marked as done'),
                    value:
                        context.watch<TaskProvider>().currentFilter !=
                        TaskFilter.incomplete,
                    onChanged: (val) {
                      context.read<TaskProvider>().setTaskFilter(
                        val ? TaskFilter.all : TaskFilter.incomplete,
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(3),
                        bottomRight: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(top: 1.5),

                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: SwitchListTile(
                    title: const Text('Confirm on delete'),
                    subtitle: const Text('Ask before removing a task'),
                    value: context.watch<TaskProvider>().confirmDelete,
                    onChanged: (val) {
                      context.read<TaskProvider>().setConfirmDelete(val);
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _labelForSortOption(SortOption s) {
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
}
