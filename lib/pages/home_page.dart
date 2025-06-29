import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:provider/provider.dart';
import 'package:task/pages/settings_page.dart';
import 'package:task/util/task_model.dart';
import 'package:task/util/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //textControllers
  final taskTextEditingController = TextEditingController();

  //init Functions
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    late final loadProvider = Provider.of<TaskProvider>(context, listen: false);
    loadProvider.loadTasks();
  }

  //dispose Functions
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //controllers
    final listController = ScrollController();
    final searchController = SearchController();

    //media query
    final screenWidth = MediaQuery.of(context).size.width;

    //starts of UI
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        //add Consummer for Provider
        child: Consumer<TaskProvider>(
          builder: (context, taskModel, _) {
            //check taskList
            if (taskModel.tasksList.isEmpty) {
              //show text if it was Nothing on taskList
              return Center(child: Text("Add some Task!"));
            } else {
              //show This(ListViewBuilder) if it has taskList
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //SearchBar Widget
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: SearchBar(
                      controller: searchController,
                      onChanged: (value) {
                        Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        ).searchTasks(value);
                      },
                      hintText: "Search..",
                      trailing: [
                        IconButton(
                          tooltip: 'Setting',
                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            );
                          },
                          icon: Icon(FlutterRemix.settings_3_fill),
                        ),
                      ],
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                    ),
                  ),

                  //ListViewBuilder Widget
                  Expanded(
                    child: Center(
                      //check screen width
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth > 400 ? 400 : double.infinity,
                        ),
                        child: ListView.builder(
                          //listCOntroller
                          controller: listController,

                          //padding the List for bottom for FloatingButton
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).size.height *
                                0.1, // 10% of screen height
                          ),
                          itemCount:
                              Provider.of<TaskProvider>(
                                context,
                              ).filteredTasksList.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final task =
                                Provider.of<TaskProvider>(
                                  context,
                                ).filteredTasksList[index];

                            //ListView UI
                            return Card(
                              elevation: 0,
                              margin: EdgeInsets.only(
                                left: 20,
                                top: 10,
                                right: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color:
                                  task.isDone
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer
                                      // ignore: deprecated_member_use
                                      .withOpacity(0.4)
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,

                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () {
                                  //toggle tasks(isDone)
                                  taskModel.toggleIsdone(index);
                                },
                                title: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    top: 5,
                                    bottom: 5,
                                  ),

                                  child: Text(
                                    task.title,

                                    style: TextStyle(
                                      decoration:
                                          task.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                      color:
                                          task.isDone
                                              ? Theme.of(
                                                context,
                                              ).colorScheme.onSurface
                                              // ignore: deprecated_member_use
                                              .withOpacity(0.4)
                                              : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                trailing: Checkbox(
                                  value: task.isDone,
                                  onChanged: (value) {
                                    taskModel.toggleIsdone(index);
                                  },
                                ),
                                onLongPress: () {
                                  //show dialog for delete task
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: IntrinsicHeight(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Top Row
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 15,
                                                    bottom: 0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Informations",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 10,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      //task Info
                                                      ListTile(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        title: Text("Task"),
                                                        subtitle: Text(
                                                          task.title,
                                                        ),
                                                        onLongPress: () {
                                                          Clipboard.setData(
                                                            ClipboardData(
                                                              text: task.title,
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Copied to clipboard",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      //createDate Info
                                                      ListTile(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        title: Text(
                                                          "Create Date",
                                                        ),
                                                        subtitle: Text(
                                                          task.createDate,
                                                        ),
                                                        onLongPress: () {
                                                          Clipboard.setData(
                                                            ClipboardData(
                                                              text:
                                                                  task.createDate,
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Copied to clipboard",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),

                                                      //isDone Info
                                                      ListTile(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        title: Text("Status"),
                                                        subtitle: Text(
                                                          task.isDone
                                                              ? "Done"
                                                              : "Not Done yet",
                                                        ),
                                                        onLongPress: () {
                                                          Clipboard.setData(
                                                            ClipboardData(
                                                              text:
                                                                  task.isDone
                                                                      ? "Done"
                                                                      : "Not Done",
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Copied to clipboard",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      //Delete Task
                                                      ListTile(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        leading: Icon(
                                                          FlutterRemix
                                                              .delete_bin_fill,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error,
                                                        ),
                                                        title: Text(
                                                          "Delete Task",
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .error,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          task.isDone
                                                              ? "This task is already done, you can delete it."
                                                              : "Are you sure to delete this task?",
                                                        ),
                                                        onTap: () {
                                                          taskModel.deleteTasks(
                                                            index,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Task deleted",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 10,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      FilledButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text("Close"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),

      //add new Tasks
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
        child: Icon(FlutterRemix.add_line),
      ),
    );
  }
}
