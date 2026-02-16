import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/constants/app_constants.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/common/color_picker.dart';
import 'package:task/widgets/common/icon_picker.dart';
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

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.dialogBorderRadius,
      ),
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
            // Icon Picker
            IconPicker(
              selectedIcon: _selectedIcon,
              onIconSelected: (iconVal) {
                setState(() {
                  _selectedIcon = iconVal;
                  _selectedImage = null;
                });
              },
              availableIcons: AppConstants.defaultFolderIcons,
              label: 'Select Icon or Image',
            ),
            const SizedBox(height: 16),
            // Image picker button
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipOval(
                  child: Image.file(
                    File(_selectedImage!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            FilledButton.tonal(
              onPressed: _pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 16),
            // Color Picker
            ColorPicker(
              selectedColor: _selectedColor,
              onColorSelected: (color) =>
                  setState(() => _selectedColor = color),
              availableColors: AppConstants.availableColors,
              label: 'Select Color',
              showLabel: true,
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
            if (name.isNotEmpty) {
              Provider.of<TaskProvider>(context, listen: false).createFolder(
                name,
                icon: _selectedIcon,
                image: _selectedImage,
                color: _selectedColor,
              );
            }
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
}
