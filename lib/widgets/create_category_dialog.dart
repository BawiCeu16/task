// lib/widgets/create_category_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createCategory() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      Provider.of<TaskProvider>(context, listen: false).createCategory(name);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Create Category'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Category name'),
        autofocus: true,
        onSubmitted: (_) => _createCategory(),
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
