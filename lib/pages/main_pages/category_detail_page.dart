import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/task_list_view.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final categoryTasks = provider.tasksInCategory(categoryName);
        return Scaffold(
          appBar: AppBar(
            title: Text(categoryName),
            scrolledUnderElevation: 0,
            centerTitle: true,
          ),
          body: TaskListView(tasks: categoryTasks, provider: provider),
        );
      },
    );
  }
}
