class TaskModel {
  final String title;
  final bool isDone;
  final String createDate;
  String? editDate; // Add this field for last edit date

  TaskModel({
    required this.title,
    required this.isDone,
    required this.createDate,
    this.editDate,
  });

  // Update fromMap and toMap to include editDate
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'],
      isDone: map['isDone'],
      createDate: map['createDate'],
      editDate: map['editDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'createDate': createDate,
      'editDate': editDate,
    };
  }
}
