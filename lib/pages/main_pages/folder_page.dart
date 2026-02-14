import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/create_folder_dialog.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:task/pages/main_pages/folder_detail_page.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final folders = provider.folderList;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('Folders'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const CreateFolderDialog(),
                ),
                icon: Icon(remixIcon(Icons.create_new_folder)),
              ),
            ],
            floating: true,
            snap: true,
            scrolledUnderElevation: 0,
          ),
          if (folders.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("There's No Folders"),
                    const SizedBox(height: 10),
                    FilledButton(
                      child: const Text("Add New Folder"),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const CreateFolderDialog(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 800
                      ? 7
                      : MediaQuery.of(context).size.width > 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final folderData = folders[i];
                  final folderName = (folderData['name'] ?? '') as String;
                  final taskCount = provider.tasksInFolder(folderName).length;
                  final iconCode = folderData['icon'] as int?;
                  final imagePath = folderData['image'] as String?;
                  final colorVal = folderData['color'] as int?;

                  return Card(
                    elevation: 0,
                    color: colorVal != null ? Color(colorVal) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FolderDetailPage(folderName: folderName),
                          ),
                        );
                      },
                      onLongPress: () => _showFolderOptions(
                        context,
                        provider,
                        folderName,
                        folderData,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (imagePath != null)
                            ClipOval(
                              child: Image.file(
                                File(imagePath),
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Icon(
                              iconCode != null
                                  ? IconData(
                                      iconCode,
                                      fontFamily: 'MaterialIcons',
                                    )
                                  : Icons.folder,
                              size: 44,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            folderName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$taskCount tasks',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: folders.length),
              ),
            ),
        ],
      ),
    );
  }

  void _showFolderOptions(
    BuildContext context,
    TaskProvider provider,
    String folder,
    Map<String, dynamic> folderData,
  ) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: [
              ListTile(
                title: Text(folder),
                subtitle: Text(
                  '${provider.tasksInFolder(folder).length} tasks inside',
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
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Folder'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => _EditFolderDialog(
                        startName: folder,
                        startIcon: folderData['icon'] as int?,
                        startImage: folderData['image'] as String?,
                        startColor: folderData['color'] as int?,
                      ),
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
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: const Text('Delete Folder'),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Delete Folder?'),
                        content: Text(
                          'Are you sure you want to delete "$folder"?',
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
                      provider.deleteFolder(folder);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deleted "$folder"')),
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

class _EditFolderDialog extends StatefulWidget {
  final String startName;
  final int? startIcon;
  final String? startImage;
  final int? startColor;

  const _EditFolderDialog({
    required this.startName,
    this.startIcon,
    this.startImage,
    this.startColor,
  });

  @override
  State<_EditFolderDialog> createState() => _EditFolderDialogState();
}

class _EditFolderDialogState extends State<_EditFolderDialog> {
  late TextEditingController _c;
  int? _selectedIcon;
  String? _selectedImage;
  int? _selectedColor;

  final List<Map<String, IconData>> _icons = [
    {'Folder': Icons.folder},
    {'Work': Icons.work},
    {'Home': Icons.home},
    {'Person': Icons.person},
    {'Settings': Icons.settings},
    {'Heart': Icons.favorite},
    {'Star': Icons.star},
    {'Music': Icons.music_note},
  ];

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.startName);
    _selectedIcon = widget.startIcon;
    _selectedImage = widget.startImage;
    _selectedColor = widget.startColor;
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
      title: const Text('Edit Folder'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _c,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Folder name'),
            ),
            const SizedBox(height: 16),
            const Text('Select Icon or Image'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._icons.map((e) {
                  final iconVal = e.values.first.codePoint;
                  final isSelected =
                      _selectedIcon == iconVal && _selectedImage == null;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconVal;
                        _selectedImage = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(e.values.first),
                    ),
                  );
                }),
                InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: _selectedImage != null
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              File(_selectedImage!),
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.image),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Select Color'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildColorOption(null),
                  _buildColorOption(Colors.red.toARGB32()),
                  _buildColorOption(Colors.orange.toARGB32()),
                  _buildColorOption(Colors.yellow.shade700.toARGB32()),
                  _buildColorOption(Colors.green.toARGB32()),
                  _buildColorOption(Colors.blue.toARGB32()),
                  _buildColorOption(Colors.indigo.toARGB32()),
                  _buildColorOption(Colors.purple.toARGB32()),
                  _buildColorOption(Colors.pink.toARGB32()),
                  _buildColorOption(Colors.brown.toARGB32()),
                  _buildColorOption(Colors.grey.toARGB32()),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final newName = _c.text.trim();
            if (newName.isNotEmpty) {
              Provider.of<TaskProvider>(context, listen: false).editFolder(
                widget.startName,
                newName: newName,
                icon: _selectedIcon,
                image: _selectedImage,
                color: _selectedColor,
              );
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          _selectedImage = result.files.single.path;
          _selectedIcon = null;
        });
      }
    }
  }

  Widget _buildColorOption(int? color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color != null ? Color(color) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).disabledColor,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: color == null
            ? Icon(
                Icons.block,
                size: 16,
                color: Theme.of(context).disabledColor,
              )
            : null,
      ),
    );
  }
}
