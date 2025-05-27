import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  //make a list
  List<TaskModel> tasksList = [];
  List<TaskModel> filteredTasksList = [];
  String _searchQuery = "";

  List<TaskModel> get _tasksList => tasksList;
  List<TaskModel> get _filteredTaskList =>
      _searchQuery.isEmpty ? tasksList : filteredTasksList;

  bool appTheme = false;
  bool get _appTheme => appTheme;

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
    tasksList.add(TaskModel(title: title, isDone: false));

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
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
    );

    if (_searchQuery.isNotEmpty) {
      searchTasks(_searchQuery);
    }

    await saveTasks();
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
    notifyListeners();
  }
}
