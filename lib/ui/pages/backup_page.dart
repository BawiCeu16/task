import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/util/task_provider.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Backup & Restore")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                leading: const Icon(Icons.save_alt),
                title: const Text("Backup to App Storage"),
                subtitle: const Text(
                  "Saves tasks to tasks_backup.json in app storage",
                ),
                onTap: () async {
                  await taskProvider.backupTasksToFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Backup saved to app storage"),
                      ),
                    );
                  }
                },
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                leading: const Icon(Icons.restore),
                title: const Text("Restore from App Storage"),
                subtitle: const Text(
                  "Restores tasks from tasks_backup.json in app storage",
                ),
                onTap: () async {
                  await taskProvider.restoreTasksFromFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tasks restored from backup"),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                leading: const Icon(Icons.upload_file),
                title: const Text("Export Backup"),
                subtitle: const Text("Save tasks as JSON to a chosen location"),
                onTap: () async {
                  await taskProvider.exportTasksToPickedFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Backup exported")),
                    );
                  }
                },
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                leading: const Icon(Icons.download),
                title: const Text("Import Backup"),
                subtitle: const Text("Pick a JSON file and restore tasks"),
                onTap: () async {
                  await taskProvider.importTasksFromPickedFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tasks imported successfully"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
