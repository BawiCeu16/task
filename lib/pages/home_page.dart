import 'package:flutter/material.dart';
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
    final _searchController = SearchController();

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
                      controller: _searchController,
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
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              child: Card(
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
                                        : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerLow,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onTap: () {
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
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text("Want to delete?"),
                                            content: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.7,
                                              ),
                                              child: Text(
                                                "Are you sure to delete: ${task.title} ${task.isDone ? "(already done)" : ''}",
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyLarge,
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
                                                    taskModel.deleteTasks(
                                                      index,
                                                    );
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
