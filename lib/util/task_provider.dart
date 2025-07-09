import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> tasksList = [];
  List<TaskModel> filteredTasksList = [];
  String _searchQuery = "";

  List<TaskModel> get _tasksList => tasksList;

  bool appTheme = false;

  void searchTasks(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      filteredTasksList = tasksList;
    } else {
      filteredTasksList =
          _tasksList.where((task) {
            return task.title.toLowerCase().contains(_searchQuery);
          }).toList();
    }
    notifyListeners();
  }

  // ---------------- STORAGE (Prefs) ----------------
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      List<dynamic> taskList = json.decode(tasksString);
      tasksList = taskList.map((data) => TaskModel.fromMap(data)).toList();
      filteredTasksList = tasksList;
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString = json.encode(
      tasksList.map((task) => task.toMap()).toList(),
    );
    await prefs.setString('tasks', tasksString);
  }

  // ---------------- BACKUP / RESTORE ----------------
  Future<String> _getBackupFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/tasks_backup.json";
  }

  /// Save tasks to a JSON file (backup)
  Future<File> backupTasksToFile() async {
    final path = await _getBackupFilePath();
    final file = File(path);

    String tasksJson = json.encode(
      tasksList.map((task) => task.toMap()).toList(),
    );

    return file.writeAsString(tasksJson);
  }

  /// Restore tasks from the default backup file
  Future<void> restoreTasksFromFile() async {
    final path = await _getBackupFilePath();
    final file = File(path);

    if (await file.exists()) {
      String tasksJson = await file.readAsString();
      List<dynamic> taskList = json.decode(tasksJson);

      tasksList = taskList.map((data) => TaskModel.fromMap(data)).toList();
      filteredTasksList = tasksList;

      await saveTasks(); // sync with prefs
      notifyListeners();
    }
  }

  /// Let user pick a backup file manually (cross-device restore)
  Future<void> importTasksFromPickedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String tasksJson = await file.readAsString();
      List<dynamic> taskList = json.decode(tasksJson);

      tasksList = taskList.map((data) => TaskModel.fromMap(data)).toList();
      filteredTasksList = tasksList;

      await saveTasks();
      notifyListeners();
    }
  }

  /// Export tasks to a user-chosen location
  Future<void> exportTasksToPickedFile() async {
    String tasksJson = json.encode(
      tasksList.map((task) => task.toMap()).toList(),
    );

    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Backup',
      fileName: 'tasks_backup.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (outputPath != null) {
      File file = File(outputPath);
      await file.writeAsString(tasksJson);
    }
  }

  // ---------------- TASK ACTIONS ----------------
  Future<void> addTasks(String title) async {
    tasksList.add(
      TaskModel(
        title: title,
        isDone: false,
        createDate: DateTime.now().toString(),
        editDate: "Not edited yet",
      ),
    );

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    notifyListeners();
  }

  Future<void> toggleIsdone(int index) async {
    final actualIndex =
        _searchQuery.isEmpty
            ? index
            : tasksList.indexOf(filteredTasksList[index]);

    tasksList[actualIndex] = TaskModel(
      title: tasksList[actualIndex].title,
      isDone: !tasksList[actualIndex].isDone,
      createDate: tasksList[actualIndex].createDate,
      editDate: tasksList[actualIndex].editDate,
    );

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    notifyListeners();
  }

  Future<void> editTask(int index, String newTask) async {
    final actualIndex =
        _searchQuery.isEmpty
            ? index
            : tasksList.indexOf(filteredTasksList[index]);

    tasksList[actualIndex] = TaskModel(
      title: newTask,
      isDone: tasksList[actualIndex].isDone,
      createDate: tasksList[actualIndex].createDate,
      editDate: DateTime.now().toString(),
    );

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    notifyListeners();
  }

  Future<void> refreshList() async {
    tasksList.clear();
    filteredTasksList.clear();
    await loadTasks();

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    notifyListeners();
  }

  Future<void> deleteTasks(int index) async {
    final actualIndex =
        _searchQuery.isEmpty
            ? index
            : tasksList.indexOf(filteredTasksList[index]);

    tasksList.removeAt(actualIndex);

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    notifyListeners();
  }

  Future<void> deleteAllTask() {
    tasksList.clear();
    filteredTasksList.clear();
    _searchQuery = "";
    notifyListeners();
    return saveTasks();
  }
}
