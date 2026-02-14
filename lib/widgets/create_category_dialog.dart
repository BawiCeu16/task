// lib/widgets/create_category_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/utils/category_icons_helper.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final TextEditingController _controller = TextEditingController();
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateIcon);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateIcon);
    _controller.dispose();
    super.dispose();
  }

  void _updateIcon() {
    final text = _controller.text;
    if (text.isEmpty) {
      if (_selectedIcon != null) {
        setState(() {
          _selectedIcon = null;
        });
      }
      return;
    }

    // Get icon from helper
    final icon = CategoryIconsHelper.getIconForCategory(text);

    // Only update state if icon changed
    if (_selectedIcon != icon) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  void _createCategory() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).createCategory(name, icon: _selectedIcon?.codePoint);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Create Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedIcon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  _selectedIcon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 32,
                ),
              ),
            ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Category name',
              prefixIcon: _selectedIcon == null
                  ? const Icon(Icons.category_outlined)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            autofocus: true,
            onSubmitted: (_) => _createCategory(),
          ),
        ],
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _createCategory, child: const Text('Create')),
      ],
    );
  }
}
