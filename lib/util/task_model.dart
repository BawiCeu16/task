class TaskModel {
  //create requests
  final String title;
  bool isDone;

  //make requests
  TaskModel({required this.title, this.isDone = false});

  // Convert TaskModel to Map
  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone};
  }

  //Convert Map to TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(title: map['title'], isDone: map['isDone'] ?? false);
  }
}
