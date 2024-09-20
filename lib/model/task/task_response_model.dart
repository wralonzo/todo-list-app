class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime dueDate;
  final int userId;
  final int order;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.userId,
    required this.order,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      userId: json['userId'],
      order: json['order'],
      status: json['status'],
    );
  }
}
