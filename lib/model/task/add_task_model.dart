class TaskInsert {
  String title;
  String status;
  String description;
  int order;
  int userId;
  final DateTime dueDate;

  TaskInsert(
      {required this.title,
      required this.description,
      required this.userId,
      required this.dueDate,
      required this.status,
      this.order = 0});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'userId': userId,
      'status': status,
      'description': description,
      'order': order,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory TaskInsert.fromJson(Map<String, dynamic> json) {
    return TaskInsert(
      title: json['title'],
      status: json['status'],
      userId: json['userId'],
      dueDate: json['dueDate'],
      description: json['description'],
      order: json['order'],
    );
  }
}
