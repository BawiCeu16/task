import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task/util/task_model.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskModel task;
  final Function(String) onSave;

  const EditTaskDialog({Key? key, required this.task, required this.onSave})
    : super(key: key);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _controller;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task Title',
              ),
            ),
            const SizedBox(height: 20),
            _buildDateInfo('Created', widget.task.createDate),
            if (widget.task.editDate != null)
              _buildDateInfo('Last Edited', widget.task.editDate!),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, String dateString) {
    final date = DateTime.tryParse(dateString);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: date != null ? _dateFormat.format(date) : 'Unknown date',
            ),
          ],
        ),
      ),
    );
  }
}
