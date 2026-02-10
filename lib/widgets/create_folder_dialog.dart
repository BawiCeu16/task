import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final TextEditingController _c = TextEditingController();
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
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Create folder'),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(hintText: 'Folder name'),
            ),
            const SizedBox(height: 16),
            const Text('Select Icon or Image'),
            const SizedBox(height: 8),
            // Icons Grid
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
                      child: Icon(remixIcon(e.values.first)),
                    ),
                  );
                }),
                // Pick Image button
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
                        : Icon(remixIcon(Icons.image)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Select Color'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildColorOption(null),
                  _buildColorOption(Colors.red.value),
                  _buildColorOption(Colors.orange.value),
                  _buildColorOption(Colors.yellow.shade700.value),
                  _buildColorOption(Colors.green.value),
                  _buildColorOption(Colors.blue.value),
                  _buildColorOption(Colors.indigo.value),
                  _buildColorOption(Colors.purple.value),
                  _buildColorOption(Colors.pink.value),
                  _buildColorOption(Colors.brown.value),
                  _buildColorOption(Colors.grey.value),
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
            final name = _c.text.trim();
            if (name.isNotEmpty)
              Provider.of<TaskProvider>(context, listen: false).createFolder(
                name,
                icon: _selectedIcon,
                image: _selectedImage,
                color: _selectedColor,
              );
            Navigator.pop(context);
          },
          child: const Text('Create'),
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
                remixIcon(Icons.block),
                size: 16,
                color: Theme.of(context).disabledColor,
              )
            : null,
      ),
    );
  }
}
