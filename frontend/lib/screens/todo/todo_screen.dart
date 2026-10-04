// lib/screens/todo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import '../../viewmodels/todo_viewmodel.dart';
import 'edit_task_screen.dart';
import 'add_task_screen.dart';
import '../../widgets/todo_card_widget.dart';

class TodoScreen extends StatefulWidget {
  final int userId;
  const TodoScreen({super.key, required this.userId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoViewModel>(context, listen: false).fetchTodos(widget.userId);
    });
  }

  int _getCount(List<dynamic> todos, String key) {
    if (key == 'all') return todos.length;
    return todos.where((t) {
      final cat = (t.category ?? '').toLowerCase();
      if (key == 'work') return cat == 'work' || cat == 'iş';
      if (key == 'personal') return cat == 'personal' || cat == 'kişisel';
      if (key == 'growth') return cat == 'growth' || cat == 'gelişim';
      return cat == key;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);
    final vm = Provider.of<TodoViewModel>(context);
    final inputFillColor = theme.isDarkMode ? const Color(0xFF21262D) : const Color(0xFFF6F8FA);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32),
                Text(lang.translate('todos_title'), style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 22)),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(userId: widget.userId))).then((v) {
                    if (v == true) vm.fetchTodos(widget.userId);
                  }),
                  icon: Icon(Icons.add_circle_rounded, color: theme.accentBlue, size: 26),
                  tooltip: lang.translate('new_task'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              style: TextStyle(color: theme.textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: lang.translate('search_in_todos'),
                hintStyle: TextStyle(color: theme.subtitleColor.withOpacity(0.6), fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, color: theme.accentBlue, size: 22),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: Icon(Icons.clear_rounded, color: theme.subtitleColor, size: 18), onPressed: () => setState(() => _searchQuery = '')) : null,
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.borderColor.withOpacity(0.6), width: 1.5)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.borderColor.withOpacity(0.6), width: 1.5)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.accentBlue, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.translate('categories'), style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: theme.accentBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text("${vm.todos.length} ${lang.translate('tasks_total_text') ?? 'Görev'}", style: TextStyle(color: theme.accentBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _chip('all', lang.translate('all'), theme, inputFillColor, vm.todos)),
                const SizedBox(width: 6),
                Expanded(child: _chip('work', lang.translate('work'), theme, inputFillColor, vm.todos)),
                const SizedBox(width: 6),
                Expanded(child: _chip('personal', lang.translate('personal'), theme, inputFillColor, vm.todos)),
                const SizedBox(width: 6),
                Expanded(child: _chip('growth', lang.translate('growth'), theme, inputFillColor, vm.todos)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: vm.isLoading
                ? Center(child: CircularProgressIndicator(color: theme.accentBlue))
                : Builder(
              builder: (context) {
                var todos = vm.todos;
                if (_selectedCategory != 'all') {
                  todos = todos.where((t) {
                    final cat = (t.category ?? '').toLowerCase();
                    if (_selectedCategory == 'work') return cat == 'work' || cat == 'iş';
                    if (_selectedCategory == 'personal') return cat == 'personal' || cat == 'kişisel';
                    if (_selectedCategory == 'growth') return cat == 'growth' || cat == 'gelişim';
                    return cat == _selectedCategory;
                  }).toList();
                }
                if (_searchQuery.isNotEmpty) {
                  todos = todos.where((t) => (t.title ?? '').toLowerCase().contains(_searchQuery) || (t.description ?? '').toLowerCase().contains(_searchQuery)).toList();
                }
                if (todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: theme.accentBlue.withOpacity(0.08), shape: BoxShape.circle), child: Icon(Icons.task_alt_rounded, size: 52, color: theme.accentBlue)),
                        const SizedBox(height: 16),
                        Text(lang.translate('no_tasks_found'), style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text("Bu kategoride veya aramada henüz görev bulunmuyor.", style: TextStyle(color: theme.subtitleColor, fontSize: 13)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(userId: widget.userId))).then((v) {
                            if (v == true) vm.fetchTodos(widget.userId);
                          }),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(lang.translate('new_task')),
                          style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), elevation: 0),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: todos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final todo = todos[i];
                    return TodoCardWidget(
                      todo: todo,
                      theme: theme,
                      lang: lang,
                      onToggle: () => vm.toggleTodoStatus(todo.id!, widget.userId),
                      onDelete: () {
                        vm.deleteTodo(widget.userId, todo.id!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${todo.title} silindi."), backgroundColor: Colors.red.shade800, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
                      },
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => EditTaskScreen(taskId: todo.id!, userId: widget.userId, initialTitle: todo.title ?? '', initialDescription: todo.description ?? '', initialCategory: todo.category ?? 'work', initialPriority: todo.priority ?? 'Orta', initialDay: todo.day ?? '', initialDeadlineTime: todo.deadlineTime ?? '')));
                        vm.fetchTodos(widget.userId);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _chip(String key, String label, ThemeNotifier theme, Color bgColor, List<dynamic> todos) {
    bool isSelected = _selectedCategory == key;
    int count = _getCount(todos, key);

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.accentBlue.withOpacity(0.15) : bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.accentBlue : theme.borderColor.withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(label, style: TextStyle(color: isSelected ? theme.accentBlue : theme.subtitleColor, fontWeight: FontWeight.w600, fontSize: 11.5), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: isSelected ? theme.accentBlue.withOpacity(0.2) : theme.subtitleColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text('$count', style: TextStyle(color: isSelected ? theme.accentBlue : theme.subtitleColor, fontSize: 9.5, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}