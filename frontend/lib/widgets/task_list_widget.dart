import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../screens/todo/edit_task_screen.dart';
import 'task_card.dart';

class TaskListWidget extends StatelessWidget {
  final List<dynamic> todos;
  final int userId;

  const TaskListWidget({
    super.key,
    required this.todos,
    required this.userId,
  });

  String _getTranslatedPriority(String priority, LanguageNotifier lang) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'yüksek':
        return lang.translate('priority_high');
      case 'medium':
      case 'orta':
        return lang.translate('priority_medium');
      case 'low':
      case 'düşük':
        return lang.translate('priority_low');
      default:
        return priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);
    final viewModel = Provider.of<TodoViewModel>(context);

    if (todos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.borderColor, width: 1),
        ),
        child: Center(
          child: Text(lang.translate('no_tasks_found'), style: TextStyle(fontSize: 13, color: theme.subtitleColor)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        final bool isCompleted = todo.isCompleted ?? false;

        return TaskCard(
          uniqueKey: todo.id.toString(),
          title: todo.title ?? '',
          description: todo.description ?? '',
          isCompleted: isCompleted,
          priority: _getTranslatedPriority(todo.priority ?? 'Orta', lang),
          day: todo.day ?? '',
          time: todo.deadlineTime ?? '',
          onDismissed: () => viewModel.deleteTodo(todo.id!, userId),
          onTap: () {}, // İstersen detay sayfasına yönlendirme ekleyebilirsin
          onToggle: () => viewModel.updateTodo(
              todo.id!, todo.title!, todo.description!, !isCompleted,
              todo.priority!, todo.category!, todo.day!, todo.deadlineTime!, userId
          ),
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                taskId: todo.id!,
                userId: userId,
                initialTitle: todo.title!,
                initialDescription: todo.description!,
                initialCategory: todo.category!,
                initialPriority: todo.priority!,
                initialDay: todo.day!,
                initialDeadlineTime: todo.deadlineTime ?? '',

              ),
            ),
          ),
          onDelete: () => viewModel.deleteTodo(todo.id!, userId),
        );
      },
    );
  }
}