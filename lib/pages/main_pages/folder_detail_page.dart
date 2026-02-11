import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/task_list_view.dart';

class FolderDetailPage extends StatelessWidget {
  final String folderName;

  const FolderDetailPage({super.key, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final folderTasks = provider.tasksInFolder(folderName);
        return Scaffold(
          appBar: AppBar(
            title: Text(folderName),
            scrolledUnderElevation: 0,
            centerTitle: true,
          ),
          body: TaskListView(tasks: folderTasks, provider: provider),
        );
      },
    );
  }
}
