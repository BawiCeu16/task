// lib/provider/task_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/utils/category_icons_helper.dart';

enum SortOption {
  newestFirst,
  oldestFirst,
  alphaAsc,
  alphaDesc,
  completedFirst,
  incompleteFirst,
  color,
  folder,
  category,
}

enum TaskFilter { all, complete, incomplete }

class TaskProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _folders = [];
  // Changed from List<String> to List<Map<String, dynamic>>
  // Format: {'name': 'CategoryName', 'icon': 12345}
  final List<Map<String, dynamic>> _categories = [];

  SortOption _sortOption = SortOption.newestFirst;
  TaskFilter _taskFilter = TaskFilter.all;
  bool _confirmDelete = true;

  List<Map<String, dynamic>> get tasks => List.unmodifiable(_tasks);

  List<String> get folders =>
      List.unmodifiable(_folders.map((e) => (e['name'] ?? '').toString()));
  List<Map<String, dynamic>> get folderList => List.unmodifiable(_folders);

  // Backward compatibility: returning names only
  List<String> get categories =>
      List.unmodifiable(_categories.map((e) => (e['name'] ?? '').toString()));

  // New getter for full category objects
  List<Map<String, dynamic>> get categoryList => List.unmodifiable(_categories);

  SortOption get currentSortOption => _sortOption;
  TaskFilter get currentFilter => _taskFilter;
  bool get showCompleted => _taskFilter != TaskFilter.incomplete;
  bool get confirmDelete => _confirmDelete;

  static const String _prefsKey = 'ft_data_v1';

  // ------------------ Load / Save ------------------
  Future<void> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) {
        _tasks.clear();
        _folders.clear();
        _categories.clear();
        _sortOption = SortOption.newestFirst;
        notifyListeners();
        return;
      }
      final obj = jsonDecode(raw) as Map<String, dynamic>;
      final t = (obj['tasks'] as List<dynamic>?) ?? [];
      final f = (obj['folders'] as List<dynamic>?) ?? [];
      final c = (obj['categories'] as List<dynamic>?) ?? [];
      final sortRaw = (obj['sortOption'] ?? '') as String?;
      final filterRaw = (obj['filter'] ?? '') as String?;
      _taskFilter = TaskFilter.values.firstWhere(
        (f) => f.toString().split('.').last == filterRaw,
        orElse: () => TaskFilter.all,
      );
      _confirmDelete = (obj['confirmDelete'] ?? true) as bool;

      _tasks
        ..clear()
        ..addAll(t.map((e) => Map<String, dynamic>.from(e as Map)));
      _folders.clear();
      for (var item in f) {
        if (item is String) {
          _folders.add({'name': item});
        } else if (item is Map) {
          _folders.add(Map<String, dynamic>.from(item));
        }
      }
      _categories.clear();
      for (var item in c) {
        if (item is String) {
          // Migration: String -> Map
          final icon = CategoryIconsHelper.getIconForCategory(item).codePoint;
          _categories.add({'name': item, 'icon': icon});
        } else if (item is Map) {
          _categories.add(Map<String, dynamic>.from(item));
        }
      }

      if (sortRaw != null && sortRaw.isNotEmpty) {
        try {
          _sortOption = SortOption.values.firstWhere(
            (s) => s.toString() == sortRaw,
            orElse: () => SortOption.newestFirst,
          );
        } catch (_) {
          _sortOption = SortOption.newestFirst;
        }
      } else {
        _sortOption = SortOption.newestFirst;
      }
    } catch (e) {
      debugPrint('TaskProvider loadAll error: $e');
      _tasks.clear();
      _folders.clear();
      _categories.clear();
      _sortOption = SortOption.newestFirst;
    }
    notifyListeners();
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    final obj = {
      'tasks': _tasks,
      'folders': _folders,
      'categories': _categories,
      'sortOption': _sortOption.toString(),
      'filter': _taskFilter.toString().split('.').last,
      'confirmDelete': _confirmDelete,
    };
    await prefs.setString(_prefsKey, jsonEncode(obj));
  }

  // ------------------ Export / Import (Backup & Restore) ------------------

  /// Export all current in-memory data as a JSON string.
  /// [extraData] can be used to include theme settings or other non-task data.
  Future<String> exportData({Map<String, dynamic>? extraData}) async {
    try {
      final obj = {
        'tasks': _tasks,
        'folders': _folders,
        'categories': _categories,
        'sortOption': _sortOption.toString(),
        if (extraData != null) ...extraData,
      };
      return jsonEncode(obj);
    } catch (e) {
      debugPrint('TaskProvider.exportData error: $e');
      return '';
    }
  }

  /// Import JSON string from backup file.
  /// [clearFirst] if true, deletes all current tasks/folders/categories before importing.
  /// Returns the decoded map so the UI can extract extra data (like theme).
  Future<Map<String, dynamic>> importData(
    String importedJson, {
    bool clearFirst = false,
  }) async {
    try {
      final obj = jsonDecode(importedJson) as Map<String, dynamic>;

      if (clearFirst) {
        _tasks.clear();
        _folders.clear();
        _categories.clear();
      }

      final importedTasks = (obj['tasks'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final importedFolders = (obj['folders'] as List<dynamic>? ?? []);

      final importedCategories = (obj['categories'] as List<dynamic>? ?? []);

      // Merge tasks: skip duplicates by id. If id missing, generate new id.
      for (var t in importedTasks) {
        var id = (t['id'] ?? '').toString();
        if (id.isEmpty) {
          id =
              DateTime.now().millisecondsSinceEpoch.toString() +
              '_' +
              (t['task'] ?? '').toString().hashCode.toString();
        }

        final exists = _tasks.any((x) => (x['id'] ?? '') == id);
        if (!exists) {
          // Ensure required fields exist and have sane defaults
          final safeTask = <String, dynamic>{
            'id': id,
            'task': (t['task'] ?? '').toString(),
            'isDone': (t['isDone'] ?? false) as bool,
            'createdDate':
                (t['createdDate'] ?? DateTime.now().toIso8601String())
                    .toString(),
            'editDate': t['editDate'],
            'folder': t['folder'],
            'category': t['category'],
            // keep any extra fields present in import
            if (t.keys
                .where(
                  (k) => !{
                    'id',
                    'task',
                    'isDone',
                    'createdDate',
                    'editDate',
                    'folder',
                    'category',
                  }.contains(k),
                )
                .isNotEmpty)
              ...Map.fromEntries(
                t.entries.where(
                  (e) => !{
                    'id',
                    'task',
                    'isDone',
                    'createdDate',
                    'editDate',
                    'folder',
                    'category',
                  }.contains(e.key),
                ),
              ),
          };
          _tasks.add(safeTask);
        }
      }

      // Merge folders (avoid duplicates)
      for (var f in importedFolders) {
        if (f is String) {
          if (!_folders.any((x) => x['name'] == f)) {
            _folders.add({'name': f});
          }
        } else if (f is Map) {
          final m = Map<String, dynamic>.from(f);
          final name = (m['name'] ?? '').toString();
          if (name.isNotEmpty && !_folders.any((x) => x['name'] == name)) {
            _folders.add(m);
          }
        }
      }

      // Merge categories (avoid duplicates)
      for (var c in importedCategories) {
        if (c is String) {
          // Migration
          if (!_categories.any((x) => (x['name'] ?? '') == c)) {
            final icon = CategoryIconsHelper.getIconForCategory(c).codePoint;
            _categories.add({'name': c, 'icon': icon});
          }
        } else if (c is Map) {
          final m = Map<String, dynamic>.from(c);
          final name = (m['name'] ?? '').toString();
          if (name.isNotEmpty &&
              !_categories.any((x) => (x['name'] ?? '') == name)) {
            _categories.add(m);
          }
        }
      }

      // Save and notify
      await _saveAll();
      notifyListeners();

      return obj;
    } catch (e) {
      debugPrint('TaskProvider.importData error: $e');
      rethrow;
    }
  }

  // ------------------ Sorting ------------------
  void setSortOption(SortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    _saveAll();
    notifyListeners();
  }

  void setTaskFilter(TaskFilter filter) {
    if (_taskFilter == filter) return;
    _taskFilter = filter;
    _saveAll();
    notifyListeners();
  }

  void setShowCompleted(bool value) {
    // Legacy support: mapping true -> all, false -> incomplete
    setTaskFilter(value ? TaskFilter.all : TaskFilter.incomplete);
  }

  void setConfirmDelete(bool value) {
    if (_confirmDelete == value) return;
    _confirmDelete = value;
    _saveAll();
    notifyListeners();
  }

  List<Map<String, dynamic>> getSortedTasks() {
    var list = List<Map<String, dynamic>>.from(_tasks);

    if (_taskFilter == TaskFilter.complete) {
      list = list.where((t) => (t['isDone'] ?? false)).toList();
    } else if (_taskFilter == TaskFilter.incomplete) {
      list = list.where((t) => !(t['isDone'] ?? false)).toList();
    }

    int parseDateCompareDesc(Map<String, dynamic> a, Map<String, dynamic> b) {
      DateTime? da;
      DateTime? db;
      try {
        da = DateTime.parse((a['createdDate'] ?? '') as String);
      } catch (_) {
        da = null;
      }
      try {
        db = DateTime.parse((b['createdDate'] ?? '') as String);
      } catch (_) {
        db = null;
      }
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da); // newest first
    }

    int alphaAsc(Map<String, dynamic> a, Map<String, dynamic> b) {
      final sa = ((a['task'] ?? '') as String).toLowerCase();
      final sb = ((b['task'] ?? '') as String).toLowerCase();
      return sa.compareTo(sb);
    }

    int completedFirst(Map<String, dynamic> a, Map<String, dynamic> b) {
      final da = (a['isDone'] ?? false) as bool;
      final db = (b['isDone'] ?? false) as bool;
      if (da == db) return parseDateCompareDesc(a, b);
      return da ? -1 : 1; // completed true first
    }

    int incompleteFirst(Map<String, dynamic> a, Map<String, dynamic> b) {
      final da = (a['isDone'] ?? false) as bool;
      final db = (b['isDone'] ?? false) as bool;
      if (da == db) return parseDateCompareDesc(a, b);
      return da ? 1 : -1; // incomplete (false) first
    }

    int colorSort(Map<String, dynamic> a, Map<String, dynamic> b) {
      final ca = (a['color'] ?? 0) as int;
      final cb = (b['color'] ?? 0) as int;
      if (ca == cb) return parseDateCompareDesc(a, b);
      return cb.compareTo(
        ca,
      ); // color desc (assuming higher value is more important/distinct)
    }

    int folderSort(Map<String, dynamic> a, Map<String, dynamic> b) {
      final fa = ((a['folder'] ?? '') as String).toLowerCase();
      final fb = ((b['folder'] ?? '') as String).toLowerCase();
      if (fa == fb) return parseDateCompareDesc(a, b);
      if (fa.isEmpty) return 1; // no folder last
      if (fb.isEmpty) return -1;
      return fa.compareTo(fb);
    }

    int categorySort(Map<String, dynamic> a, Map<String, dynamic> b) {
      final ca = ((a['category'] ?? '') as String).toLowerCase();
      final cb = ((b['category'] ?? '') as String).toLowerCase();
      if (ca == cb) return parseDateCompareDesc(a, b);
      if (ca.isEmpty) return 1; // no category last
      if (cb.isEmpty) return -1;
      return ca.compareTo(cb);
    }

    switch (_sortOption) {
      case SortOption.newestFirst:
        list.sort(parseDateCompareDesc);
        break;
      case SortOption.oldestFirst:
        list.sort((a, b) => -parseDateCompareDesc(a, b));
        break;
      case SortOption.alphaAsc:
        list.sort(alphaAsc);
        break;
      case SortOption.alphaDesc:
        list.sort((a, b) => alphaAsc(b, a));
        break;
      case SortOption.completedFirst:
        list.sort(completedFirst);
        break;
      case SortOption.incompleteFirst:
        list.sort(incompleteFirst);
        break;
      case SortOption.color:
        list.sort(colorSort);
        break;
      case SortOption.folder:
        list.sort(folderSort);
        break;
      case SortOption.category:
        list.sort(categorySort);
        break;
    }

    return list;
  }

  // ------------------ CRUD: Folders, Categories, Tasks ------------------
  void createFolder(String name, {int? icon, String? image, int? color}) {
    final n = name.trim();
    if (n.isEmpty) return;
    if (!_folders.any(
      (f) => (f['name'] ?? '').toString().toLowerCase() == n.toLowerCase(),
    )) {
      _folders.insert(0, {
        'name': n,
        'icon': icon,
        'image': image,
        'color': color,
      });
      _saveAll();
      notifyListeners();
    }
  }

  void createCategory(String name, {int? icon}) {
    final n = name.trim();
    if (n.isEmpty) return;
    if (!_categories.any(
      (c) => (c['name'] ?? '').toString().toLowerCase() == n.toLowerCase(),
    )) {
      _categories.insert(0, {'name': n, 'icon': icon});
      _saveAll();
      notifyListeners();
    }
  }

  void createTask(
    String taskText, {
    bool isDone = false,
    String? folder,
    String? category,
    int? color,
  }) {
    final t = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'task': taskText,
      'isDone': isDone,
      'createdDate': DateTime.now().toIso8601String(),
      'folder': (folder == null || folder.trim().isEmpty)
          ? null
          : folder.trim(),
      'category': (category == null || category.trim().isEmpty)
          ? null
          : category.trim(),
      'color': color,
    };
    _tasks.insert(0, t);
    _saveAll();
    notifyListeners();
  }

  void toggleIsDone(int index) {
    if (index < 0 || index >= _tasks.length) return;
    _tasks[index]['isDone'] = !(_tasks[index]['isDone'] as bool? ?? false);
    _saveAll();
    notifyListeners();
  }

  void editTask(
    int index,
    String newText, {
    bool? isDone,
    String? folder,
    String? category,
    int? color,
  }) {
    if (index < 0 || index >= _tasks.length) return;
    _tasks[index]['task'] = newText;
    if (isDone != null) {
      _tasks[index]['isDone'] = isDone;
    }
    if (folder != null) {
      _tasks[index]['folder'] = folder.isEmpty ? null : folder;
    }
    if (category != null) {
      _tasks[index]['category'] = category.isEmpty ? null : category;
    }
    if (color != null) {
      _tasks[index]['color'] = color;
    }
    _tasks[index]['editDate'] = DateTime.now().toIso8601String();
    _saveAll();
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index < 0 || index >= _tasks.length) return;
    _tasks.removeAt(index);
    _saveAll();
    notifyListeners();
  }

  Future<void> deleteAllTasks() async {
    _tasks.clear();
    await _saveAll();
    notifyListeners();
  }

  List<Map<String, dynamic>> tasksInFolder(String folder) {
    final list = _tasks.where((t) => (t['folder'] ?? '') == folder).toList();
    if (_taskFilter == TaskFilter.complete) {
      return list.where((t) => (t['isDone'] ?? false)).toList();
    } else if (_taskFilter == TaskFilter.incomplete) {
      return list.where((t) => !(t['isDone'] ?? false)).toList();
    }
    return list;
  }

  List<Map<String, dynamic>> tasksInCategory(String category) {
    final list = _tasks
        .where((t) => (t['category'] ?? '') == category)
        .toList();
    if (_taskFilter == TaskFilter.complete) {
      return list.where((t) => (t['isDone'] ?? false)).toList();
    } else if (_taskFilter == TaskFilter.incomplete) {
      return list.where((t) => !(t['isDone'] ?? false)).toList();
    }
    return list;
  }

  // ---------------- Folder / Category management helpers ----------------

  /// Delete a folder and tasks inside it.
  void deleteFolder(String folder) {
    final f = folder.trim();
    if (f.isEmpty) return;
    _folders.removeWhere((x) => (x['name'] ?? '') == f);
    _tasks.removeWhere((t) => (t['folder'] ?? '') == f);
    _saveAll();
    notifyListeners();
  }

  /// Delete only tasks in given folder (keep folder)
  void deleteTasksInFolder(String folder) {
    final f = folder.trim();
    _tasks.removeWhere((t) => (t['folder'] ?? '') == f);
    _saveAll();
    notifyListeners();
  }

  /// Unset folder tag from tasks (keep tasks)
  void unsetFolderTagFromTasks(String folder) {
    final f = folder.trim();
    for (var t in _tasks) {
      if ((t['folder'] ?? '') == f) t['folder'] = null;
    }
    _saveAll();
    notifyListeners();
  }

  /// Delete all folders. Optionally delete tasks too.
  void deleteAllFolders({bool deleteTasks = false}) {
    if (deleteTasks) {
      final setFolders = _folders
          .map((e) => (e['name'] ?? '').toString())
          .toSet();
      _tasks.removeWhere((t) => setFolders.contains((t['folder'] ?? '')));
    } else {
      for (var t in _tasks) {
        if (t['folder'] != null && (t['folder'] as String).isNotEmpty) {
          t['folder'] = null;
        }
      }
    }
    _folders.clear();
    _saveAll();
    notifyListeners();
  }

  /// Delete category and unset it from tasks
  void deleteCategory(String category) {
    final c = category.trim();
    if (c.isEmpty) return;
    _categories.removeWhere((x) => (x['name'] ?? '') == c);
    for (var t in _tasks) {
      if ((t['category'] ?? '') == c) t['category'] = null;
    }
    _saveAll();
    notifyListeners();
  }

  /// Delete only tasks in category (keep category)
  void deleteTasksInCategory(String category) {
    final c = category.trim();
    _tasks.removeWhere((t) => (t['category'] ?? '') == c);
    _saveAll();
    notifyListeners();
  }

  /// Unset category tag from tasks (keep tasks)
  void unsetCategoryTagFromTasks(String category) {
    final c = category.trim();
    for (var t in _tasks) {
      if ((t['category'] ?? '') == c) t['category'] = null;
    }
    _saveAll();
    notifyListeners();
  }

  /// Delete all categories. Optionally delete tasks too.
  void deleteAllCategories({bool deleteTasks = false}) {
    if (deleteTasks) {
      final setCats = _categories
          .map((e) => (e['name'] ?? '').toString())
          .toSet();
      _tasks.removeWhere((t) => setCats.contains((t['category'] ?? '')));
    } else {
      for (var t in _tasks) {
        if (t['category'] != null && (t['category'] as String).isNotEmpty) {
          t['category'] = null;
        }
      }
    }
    _categories.clear();
    _saveAll();
    notifyListeners();
  }

  // rename helpers
  void editFolder(
    String oldName, {
    String? newName,
    int? icon,
    String? image,
    int? color,
  }) {
    final o = oldName.trim();
    if (o.isEmpty) return;

    final idx = _folders.indexWhere((f) => (f['name'] ?? '') == o);
    if (idx == -1) return;

    if (newName != null) {
      final n = newName.trim();
      if (n.isNotEmpty && n.toLowerCase() != o.toLowerCase()) {
        _folders[idx]['name'] = n;
        // update tasks
        for (var t in _tasks) {
          if ((t['folder'] ?? '') == o) t['folder'] = n;
        }
      }
    }

    if (icon != null) {
      _folders[idx]['icon'] = icon;
      _folders[idx]['image'] = null;
    }
    if (image != null) {
      _folders[idx]['image'] = image;
      _folders[idx]['icon'] = null;
    }
    if (color != null) _folders[idx]['color'] = color;

    _saveAll();
    notifyListeners();
  }

  void renameFolder(String oldName, String newName) {
    final o = oldName.trim();
    final n = newName.trim();
    if (o.isEmpty || n.isEmpty) return;
    if (o.toLowerCase() == n.toLowerCase()) return;

    final idx = _folders.indexWhere((f) => (f['name'] ?? '') == o);
    if (idx != -1) _folders[idx]['name'] = n;

    for (var t in _tasks) {
      if ((t['folder'] ?? '') == o) t['folder'] = n;
    }
    _saveAll();
    notifyListeners();
  }

  void renameCategory(String oldName, String newName, {int? icon}) {
    final o = oldName.trim();
    final n = newName.trim();
    if (o.isEmpty || n.isEmpty) return;

    final idx = _categories.indexWhere((c) => (c['name'] ?? '') == o);
    if (idx != -1) {
      if (o.toLowerCase() != n.toLowerCase()) {
        _categories[idx]['name'] = n;
        // Update tasks
        for (var t in _tasks) {
          if ((t['category'] ?? '') == o) t['category'] = n;
        }
      }
      if (icon != null) {
        _categories[idx]['icon'] = icon;
      }
    }

    _saveAll();
    notifyListeners();
  }
}
