import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.150.42:5293/api';

  
  Future<int?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usernameOrEmail": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userObj = data['user'] ?? data;
        return userObj['user_id'] ?? userObj['userId'] ?? userObj['id'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  
  Future<List<dynamic>?> getTodos(int userId) async {
    return await getTodosByUserId(userId);
  }

  Future<List<dynamic>?> getTodosByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Todo/$userId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawList = jsonDecode(response.body);
        return rawList.map((todo) {
          return {
            'id': todo['todo_id'] ?? todo['Id'] ?? todo['id'] ?? 0,
            'userId': todo['user_id'] ?? todo['UserId'] ?? todo['userId'] ?? 0,
            'title': todo['title'] ?? todo['Title'] ?? '',
            'description': todo['description'] ?? todo['Description'] ?? '',
            'isCompleted': todo['is_completed'] ?? todo['IsCompleted'] ?? todo['isCompleted'] ?? false,
            'priority': todo['priority'] ?? todo['Priority'] ?? 'Normal',
            'category': todo['category'] ?? todo['Category'] ?? 'Genel',
            'day': todo['day'] ?? todo['Day'] ?? todo['date'] ?? '',
            'deadlineTime': todo['deadline_time'] ?? todo['DeadlineTime'] ?? todo['deadlineTime'] ?? '',
          };
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Görev Ekleme Metodu (category alanı eklendi)
  Future<bool> addTodo(
      int userId,
      String title,
      String description,
      String priority,
      String day,
      String deadlineTime,
      String category, // Süslü parantezler kaldırıldı, düz sıralı parametre yapıldı
      ) async {
    try {
      final body = jsonEncode({
        "userId": userId,
        "title": title,
        "description": description,
        "priority": priority,
        "category": category,
        "Day": day,
        "DeadlineTime": deadlineTime
      });

      print("API'ye gönderilen body: $body");

      final response = await http.post(
        Uri.parse('$baseUrl/Todo'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("İstek Hatası: $e");
      return false;
    }
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
      ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Todo/$todoId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "description": description,
          "isCompleted": isCompleted,
          "priority": priority,
          "category": category,
          "day": day,
          "deadlineTime": deadlineTime,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Güncelleme Hatası: $e");
      return false;
    }
  }

  
  Future<bool> deleteTodo(int todoId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/Todo/$todoId'),
        headers: {"Content-Type": "application/json"},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }


  Future<Map<String, dynamic>?> getUserStats(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Todo/stats/$userId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'totalCount': data['totalCount'] ?? data['TotalCount'] ?? data['total_count'] ?? 0,
          'completedCount': data['completedCount'] ?? data['CompletedCount'] ?? data['completed_count'] ?? 0,
          'notCompletedCount': data['notCompletedCount'] ?? data['NotCompletedCount'] ?? data['not_completed_count'] ?? 0,
          'highPriorityCount': data['highPriorityCount'] ?? data['HighPriorityCount'] ?? data['high_priority_count'] ?? 0,
          'normalPriorityCount': data['normalPriorityCount'] ?? data['NormalPriorityCount'] ?? data['normal_priority_count'] ?? 0,
          'lowPriorityCount': data['lowPriorityCount'] ?? data['LowPriorityCount'] ?? data['low_priority_count'] ?? 0,
        };
      }
    } catch (e) {
      print("İstatistik Hatası: $e");
    }
    return null;
  }
}