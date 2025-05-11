import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/pages/settings_page.dart';
import 'package:task/util/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    late final loadProvider = Provider.of<TaskProvider>(context, listen: false);
    loadProvider.loadTasks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("task"),
        actions: [
          IconButton(
            tooltip: 'Setting',
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
          SizedBox(width: 5),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskModel, _) {
          if (taskModel.tasksList.isEmpty) {
            return Center(child: Text("Add some Task!"));
          } else {
            return ListView.builder(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).size.height *
                    0.1, // 10% of screen height
              ),
              itemCount: taskModel.tasksList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final task = taskModel.tasksList[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  margin: EdgeInsets.only(left: 20, top: 10, right: 20),

                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: ListTile(
                    title: Text(
                      "${task.title}",
                      style: TextStyle(
                        decoration:
                            task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    trailing: Checkbox(
                      value: task.isDone,
                      onChanged: (value) {
                        taskModel.toggleIsdone(index);
                      },
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("Want to delete?"),
                              content: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.7,
                                ),
                                child: Text(
                                  "Are you sure to delete: ${task.title} ${task.isDone ? "(already done)" : ''}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              actions: [
                                SizedBox(
                                  height: 40,
                                  child: FilledButton.tonal(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancle"),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: FilledButton(
                                    onPressed: () {
                                      taskModel.deleteTasks(index);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete"),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Add Task"),
                  content: TextField(
                    controller: taskTextEditingController,
                    decoration: InputDecoration(hintText: "task.."),
                  ),
                  actions: [
                    SizedBox(
                      height: 40,
                      child: FilledButton.tonal(
                        onPressed: () {
                          Navigator.pop(context);
                          taskTextEditingController.clear();
                        },
                        child: Text("Cancle"),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: FilledButton(
                        onPressed: () {
                          if (taskTextEditingController.text.isNotEmpty) {
                            Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            ).addTasks(taskTextEditingController.text);
                            taskTextEditingController.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
