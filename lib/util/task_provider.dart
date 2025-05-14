import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  //make a list
  List<TaskModel> tasksList = [];
  List<TaskModel> get _tasksList => tasksList;

  bool appTheme = false;
  bool get _appTheme => appTheme;

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
    await saveTasks();
    notifyListeners();
  }

  //toggle isDone
  Future<void> toggleIsdone(int index) async {
    tasksList[index] = TaskModel(
      title: tasksList[index].title,
      isDone: !tasksList[index].isDone,
    );
    await saveTasks();
    notifyListeners();
  }

  //deteleTasks
  Future<void> deleteTasks(int index) async {
    tasksList.removeAt(index);
    await saveTasks();
    notifyListeners();
  }
}
