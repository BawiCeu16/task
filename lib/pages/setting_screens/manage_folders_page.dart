import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/constants/app_constants.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/services/index.dart';
import 'package:task/widgets/icon_mapper.dart';

class ManageFoldersPage extends StatefulWidget {
  const ManageFoldersPage({super.key});

  @override
  State<ManageFoldersPage> createState() => _ManageFoldersPageState();
}

class _ManageFoldersPageState extends State<ManageFoldersPage>
    with ConfirmationMixin, SnackBarMixin {
  String? _renamingFolder;
  final _renameController = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();

  void _exitRenameMode() {
    setState(() {
      _renamingFolder = null;
      _renameController.clear();
    });
  }

  void _startRenameMode(String name) {
    setState(() {
      _renameController.text = name;
      _renamingFolder = name;
    });
  }

  void _performRename(TaskProvider provider, String oldName, String newName) {
    if (newName.isEmpty || newName == oldName) {
      _exitRenameMode();
      return;
    }
    try {
      provider.renameFolder(oldName, newName);
      if (mounted) {
        showSuccessSnackBar(context, 'Renamed "$oldName" to "$newName"');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Error: $e');
      }
    } finally {
      _exitRenameMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final folders = provider.folders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Folders'),
        centerTitle: true,
        actions: [
          if (folders.isNotEmpty)
            IconButton(
              icon: Icon(remixIcon(Icons.delete_sweep_outlined)),
              tooltip: 'Delete all folders',
              onPressed: () async {
                final confirm = await showConfirmation(
                  context,
                  title: AppConstants.confirmDeleteAllFolders,
                  content: 'Do you also want to delete tasks inside them?',
                );
                if (confirm == true) {
                  final deleteTasks = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => SimpleDialog(
                      title: const Text('Also delete folder tasks?'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Keep tasks (unset folder)'),
                        ),
                        SimpleDialogOption(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete tasks too'),
                        ),
                      ],
                    ),
                  );

                  if (deleteTasks == null) return;

                  try {
                    provider.deleteAllFolders(deleteTasks: deleteTasks);
                    if (mounted) {
                      showSuccessSnackBar(context, 'All folders cleared');
                    }
                  } catch (e) {
                    if (mounted) {
                      showErrorSnackBar(context, 'Error: $e');
                    }
                  }
                }
              },
            ),
        ],
      ),
      body: folders.isEmpty
          ? Center(
              child: Text(
                'No folders',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  final isRenaming = _renamingFolder == folder;
                  final count = provider.tasksInFolder(folder).length;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: isRenaming
                        ? Form(
                            key: _renameFormKey,
                            child: ListTile(
                              title: TextFormField(
                                controller: _renameController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                                onFieldSubmitted: (v) =>
                                    _performRename(provider, folder, v.trim()),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Cannot be empty'
                                    : null,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(remixIcon(Icons.check)),
                                    onPressed: () {
                                      if (_renameFormKey.currentState!
                                          .validate()) {
                                        _performRename(
                                          provider,
                                          folder,
                                          _renameController.text.trim(),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(remixIcon(Icons.close)),
                                    onPressed: _exitRenameMode,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListTile(
                            title: Text(folder),
                            subtitle: Text(
                              '$count task${count == 1 ? '' : 's'}',
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (v) async {
                                if (v == 'rename') {
                                  _startRenameMode(folder);
                                } else if (v == 'delete') {
                                  final ok = await showConfirmation(
                                    context,
                                    title: 'Delete Folder',
                                    content: 'Delete "$folder" and its tasks?',
                                  );
                                  if (ok == true) {
                                    try {
                                      provider.deleteFolder(folder);
                                    } catch (e) {
                                      if (mounted) {
                                        showErrorSnackBar(context, 'Error: $e');
                                      }
                                    }
                                  }
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'rename',
                                  child: Text('Rename'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
    );
  }
}
