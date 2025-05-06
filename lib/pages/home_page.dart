import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: Text("task"),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<TaskProvider>(
        builder:
            (context, taskModel, _) => ListView.builder(
              itemCount: taskModel.tasksList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final task = taskModel.tasksList[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                  height: 70,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 5),
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
                              content: Text(
                                "are you sure to delete ${task.title}",
                              ),
                              actions: [
                                FilledButton.tonal(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancle"),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    taskModel.deleteTasks(index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
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
