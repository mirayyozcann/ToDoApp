import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/todo_model.dart';

class NotificationItem {
  final String titleKey;
  final String messageKey;
  final String taskTitle;
  final DateTime time;

  NotificationItem({
    required this.titleKey,
    required this.messageKey,
    required this.taskTitle,
    required this.time,
  });
}

class TodoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Todo> todos = [];
  bool isLoading = false;
  Map<String, dynamic> stats = {};

  final List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  void _addNotification(String titleKey, String messageKey, String taskTitle) {
    _notifications.insert(
      0,
      NotificationItem(
        titleKey: titleKey,
        messageKey: messageKey,
        taskTitle: taskTitle,
        time: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchTodos(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      var rawData = await _apiService.getTodosByUserId(userId);
      if (rawData != null) {
        todos = rawData.map((json) => Todo.fromJson(json)).toList();
      } else {
        todos = [];
      }
    } catch (e) {
      todos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTodo(
      int userId,
      String title,
      String description,
      String priority,
      String category,
      String day,
      String deadlineTime,
      ) async {
    bool success = await _apiService.addTodo(
      userId,
      title,
      description,
      priority,
      category,
      day,
      deadlineTime,
    );
    if (success) {
      _addNotification("notif_new_task_title", "notif_new_task_msg", title);
      await fetchTodos(userId);
    }
    return success;
  }

  Future<bool> updateTodo(
      int todoId,
      String title,
      String description,
      bool isCompleted,
      String priority,
      String category,
      String day,
      String deadlineTime,
      int userId,
      ) async {
    bool success = await _apiService.updateTodo(
      todoId,
      title,
      description,
      isCompleted,
      priority,
      category,
      day,
      deadlineTime,
    );

    if (success) {
      if (isCompleted) {
        _addNotification("notif_completed_title", "notif_completed_msg", title);
      }
      await fetchTodos(userId);
    }
    return success;
  }

  Future<bool> deleteTodo(int todoId, int userId) async {
    final todoToDelete = todos.where((t) => t.id == todoId).isNotEmpty
        ? todos.firstWhere((t) => t.id == todoId)
        : null;

    bool success = await _apiService.deleteTodo(todoId);
    if (success) {
      final taskTitle = todoToDelete?.title ?? "Task";
      _addNotification("notif_deleted_title", "notif_deleted_msg", taskTitle);
      await fetchTodos(userId);
    }
    return success;
  }

  Future<void> toggleTodoStatus(int todoId, int userId) async {
    final todoIndex = todos.indexWhere((t) => t.id == todoId);
    if (todoIndex == -1) return;

    final todo = todos[todoIndex];
    bool newStatus = !(todo.isCompleted ?? false);

    bool success = await updateTodo(
      todo.id!,
      todo.title ?? '',
      todo.description ?? '',
      newStatus,
      todo.priority ?? 'Orta',
      todo.category ?? 'İş',
      todo.day ?? '',
      todo.deadlineTime ?? '',
      userId,
    );

    if (success) {
      notifyListeners();
    }
  }

  Future<void> fetchStats(int userId) async {
    var data = await _apiService.getUserStats(userId);
    if (data != null) {
      stats = data;
      notifyListeners();
    }
  }
}