// lib/pages/setting_screens/backup_page.dart
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task/widgets/setting_widgets/bottom_list_tile.dart';
import 'package:task/widgets/setting_widgets/top_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:task/provider/task_provider.dart';
import 'package:task/provider/theme_provider.dart';
import 'package:task/widgets/icon_mapper.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Backup & Restore'),
            centerTitle: true,
            animateColor: true,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    'Export & Import',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TopListTile(
                    title: "Backup (Export)",
                    subtitle: "Full backup (Tasks + Theme).",
                    trailing: SizedBox(
                      width: 140,
                      child: FilledButton.icon(
                        icon: Icon(remixIcon(Icons.save)),
                        label: const Text('Export Backup'),
                        onPressed: _isLoading
                            ? null
                            : () => _export(provider, themeProvider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  BottomListTile(
                    title: "Restore (Import)",
                    subtitle: "Restore from backup JSON.",
                    trailing: SizedBox(
                      width: 140,
                      child: FilledButton.icon(
                        icon: Icon(remixIcon(Icons.upload)),
                        label: const Text('Import Backup'),
                        onPressed: _isLoading
                            ? null
                            : () => _import(provider, themeProvider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '- Export includes tasks, folders, categories, and appearance settings.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '- Import offers to either Merge with current data or Overwrite it entirely.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '- "Merge" keeps existing tasks and adds new ones from backup.',
                          ),
                          Text(
                            '- "Overwrite" deletes everything first then restores from backup.',
                          ),
                          Text(
                            '- Backups are plain JSON. Keep your files in a safe location.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black12,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Future<void> _export(
    TaskProvider provider,
    ThemeProvider themeProvider,
  ) async {
    setState(() => _isLoading = true);
    try {
      final themeData = themeProvider.exportThemeData();
      final data = await provider.exportData(extraData: {'theme': themeData});

      if (data.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No data to export')));
        return;
      }

      final bytes = Uint8List.fromList(utf8.encode(data));
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save backup file',
        fileName: 'task_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        bytes: bytes,
      );

      if (savedPath == null) return; // cancelled

      if (!kIsWeb) {
        final file = File(savedPath);
        if (!(await file.exists()) || await file.length() == 0) {
          await file.writeAsBytes(bytes);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exported to $savedPath')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _import(
    TaskProvider provider,
    ThemeProvider themeProvider,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return;

      final PlatformFile picked = result.files.single;

      String content;
      if (kIsWeb) {
        final bytes = picked.bytes;
        if (bytes == null) throw 'Failed to read file bytes';
        content = utf8.decode(bytes);
      } else {
        final path = picked.path;
        if (path == null) throw 'Selected file path is null';
        content = await File(path).readAsString();
      }

      if (!mounted) return;

      // Ask user: Merge or Overwrite?
      final choice = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Restore Backup'),
          content: const Text(
            'Do you want to Merge the backup with your current tasks, or Overwrite everything?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: const Text('Cancel'),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.pop(ctx, 'merge'),
              child: const Text('Merge'),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.error,
                ),
              ),
              onPressed: () => Navigator.pop(ctx, 'overwrite'),
              child: const Text('Overwrite'),
            ),
          ],
        ),
      );

      if (choice == null || choice == 'cancel') return;

      setState(() => _isLoading = true);

      final importedMap = await provider.importData(
        content,
        clearFirst: choice == 'overwrite',
      );

      // Handle theme data if present
      if (importedMap.containsKey('theme')) {
        final themeData = importedMap['theme'] as Map<String, dynamic>;
        await themeProvider.importThemeData(themeData);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            choice == 'overwrite'
                ? 'Backup restored (Overwritten)'
                : 'Backup restored (Merged)',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to import: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
