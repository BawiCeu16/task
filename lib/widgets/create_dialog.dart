import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/widgets/create_folder_dialog.dart';
import 'package:task/widgets/icon_mapper.dart';

/// onTapSave: (String taskName, bool isDone, String? folder, String? category)
class MyCreateDialog extends StatefulWidget {
  final String? initialText;
  final String? initialFolder;
  final String? initialCategory;
  final bool? initialIsDone;
  final int? initialColor;
  final void Function(String, bool, String?, String?, int?) onTapSave;

  const MyCreateDialog({
    super.key,
    required this.onTapSave,
    this.initialText,
    this.initialFolder,
    this.initialCategory,
    this.initialIsDone,
    this.initialColor,
  });

  @override
  State<MyCreateDialog> createState() => _MyCreateDialogState();
}

class _MyCreateDialogState extends State<MyCreateDialog> {
  late final TextEditingController _controller;
  String? _folder;
  String? _category;
  late bool _isDone;
  int? _color;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
    _folder = widget.initialFolder;
    _category = widget.initialCategory;
    _isDone = widget.initialIsDone ?? false;
    _color = widget.initialColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final folders = provider.folders;
    final categories = provider.categories;
    final isEditing =
        (widget.initialText != null && widget.initialText!.isNotEmpty);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(isEditing ? 'Edit Task' : 'Create Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Task title input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Enter task'),
              autofocus: true,
            ),
            const SizedBox(height: 12),

            // Folder selector + create folder button
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    elevation: 0,
                    value: _folder,
                    items: <DropdownMenuItem<String?>>[
                      DropdownMenuItem<String?>(
                        value: null,
                        child: const Text('No folder'),
                      ),
                      ...folders.map<DropdownMenuItem<String?>>(
                        (f) =>
                            DropdownMenuItem<String?>(value: f, child: Text(f)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _folder = v),
                    decoration: const InputDecoration(labelText: 'Folder'),
                  ),
                ),
                IconButton(
                  icon: Icon(remixIcon(Icons.create_new_folder)),
                  tooltip: 'Create folder',
                  onPressed: () => _showCreateFolder(context),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Category selector + create category button
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    elevation: 0,
                    value: _category,
                    items: <DropdownMenuItem<String?>>[
                      DropdownMenuItem<String?>(
                        value: null,
                        child: const Text('No category'),
                      ),
                      ...categories.map<DropdownMenuItem<String?>>(
                        (c) =>
                            DropdownMenuItem<String?>(value: c, child: Text(c)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _category = v),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                ),
                IconButton(
                  icon: Icon(remixIcon(Icons.add)),
                  tooltip: 'Create category',
                  onPressed: () => _showCreateCategory(context),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Mark as done checkbox
            Card(
              elevation: 0,
              margin: EdgeInsets.only(top: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(100),
              ),
              child: CheckboxListTile(
                title: const Text('Mark as done'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(100),
                ),
                value: _isDone,
                onChanged: (v) => setState(() => _isDone = v ?? false),
              ),
            ),
            const SizedBox(height: 12),
            // Color picker
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
            final text = _controller.text.trim();
            if (text.isEmpty) return;

            widget.onTapSave(text, _isDone, _folder, _category, _color);
            Navigator.pop(context);
          },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  // Create folder dialog (updates provider and refreshes dropdown)
  void _showCreateFolder(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (dctx) => const CreateFolderDialog(),
    );
    if (mounted) setState(() {}); // refresh dropdown items after creating
  }

  // Create category dialog (updates provider and refreshes dropdown)
  void _showCreateCategory(BuildContext ctx) async {
    final c = TextEditingController();
    await showDialog(
      context: ctx,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create category'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = c.text.trim();
              if (name.isNotEmpty) {
                Provider.of<TaskProvider>(
                  ctx,
                  listen: false,
                ).createCategory(name);
              }
              Navigator.pop(dctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (mounted) setState(() {}); // refresh dropdown items after creating
  }

  Widget _buildColorOption(int? color) {
    final isSelected = _color == color;
    return GestureDetector(
      onTap: () => setState(() => _color = color),
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
