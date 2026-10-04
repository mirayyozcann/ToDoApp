class Todo {
  final int id;
  final int userId;
  final String title;
  final String description;
  final bool isCompleted;
  final String priority;
  final String category;
  final String deadlineTime;
  final String day;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.category,
    required this.deadlineTime,
    required this.day,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['todo_id'] ?? json['Id'] ?? json['id'] ?? 0,
      userId: json['user_id'] ?? json['UserId'] ?? json['userId'] ?? 0,
      title: json['title'] ?? json['Title'] ?? '',
      description: json['description'] ?? json['Description'] ?? '',
      isCompleted: json['is_completed'] ?? json['IsCompleted'] ?? json['isCompleted'] ?? false,
      priority: json['priority'] ?? json['Priority'] ?? 'Normal',
      category: json['category'] ?? json['Category'] ?? 'Genel',
      deadlineTime: json['deadline_time'] ?? json['DeadlineTime'] ?? json['deadlineTime'] ?? json['time'] ?? json['saat'] ?? '',
      day: json['day'] ?? json['Day'] ?? '',
    );
  }
}