import 'dart:convert';
// import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  //make a list
  List<TaskModel> tasksList = [];
  List<TaskModel> filteredTasksList = [];
  String _searchQuery = "";

  List<TaskModel> get _tasksList => tasksList;
  // List<TaskModel> get _filteredTaskList =>
  //     _searchQuery.isEmpty ? tasksList : filteredTasksList;

  bool appTheme = false;
  // bool get _appTheme => appTheme;

  // Future<void> _updateWidgetData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // Serialize tasks to JSON
  //   final tasksJson = json.encode(
  //     tasksList.map((task) => task.toMap()).toList(),
  //   );
  //   await prefs.setString('flutter.tasks_json', tasksJson);

  //   // Trigger widget update
  //   try {
  //     const platform = MethodChannel('com.c.task/widget');
  //     await platform.invokeMethod('updateWidget');
  //   } catch (e) {
  //     // print('Widget update error: $e');
  //   }
  // }

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

  //loadTasks
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    //take task by Map(Json)
    final String? tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      //convert Map(Json) to List
      List<dynamic> taskList = json.decode(tasksString);
      //put taskModel to tasksList
      tasksList = taskList.map((data) => TaskModel.fromMap(data)).toList();
      filteredTasksList = tasksList;
      notifyListeners();
    }
  }

  //saveTasks
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString = json.encode(
      tasksList.map((task) => task.toMap()).toList(),
    );
    await prefs.setString('tasks', tasksString);
  }

  //addTasks
  Future<void> addTasks(String title) async {
    tasksList.add(
      TaskModel(
        title: title,
        isDone: false,
        createDate: DateTime.now().toString(),
      ),
    );

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    // await _updateWidgetData();
    notifyListeners();
  }

  //toggle isDone
  Future<void> toggleIsdone(int index) async {
    final actualIndex =
        _searchQuery.isEmpty
            ? index
            : tasksList.indexOf(filteredTasksList[index]);

    tasksList[actualIndex] = TaskModel(
      title: tasksList[actualIndex].title,
      isDone: !tasksList[actualIndex].isDone,
      createDate: tasksList[actualIndex].createDate,
    );

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    // await _updateWidgetData();
    notifyListeners();
  }

  //refreshList
  Future<void> refreshList() async {
    // Clear the current lists
    tasksList.clear();
    filteredTasksList.clear();

    // Reload from shared preferences
    await loadTasks();

    // Reapply search filter if there was one
    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    notifyListeners();
  }

  //deteleTasks
  Future<void> deleteTasks(int index) async {
    final actualIndex =
        _searchQuery.isEmpty
            ? index
            : tasksList.indexOf(filteredTasksList[index]);

    tasksList.removeAt(index);

    if (_searchQuery.isEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
    // await _updateWidgetData();
    notifyListeners();
  }

  //deleteAllTask
  Future<void> deleteAllTask() {
    tasksList.clear();
    filteredTasksList.clear();
    _searchQuery = "";
    notifyListeners();
    return saveTasks();
  }
}
