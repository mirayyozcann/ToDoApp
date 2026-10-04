import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../../widgets/task_list_widget.dart';
import '../notification_screen.dart';
import '../todo/add_task_screen.dart';

class HomeContentView extends StatefulWidget {
  final int userId;
  final String kullaniciAdi;

  const HomeContentView({super.key, required this.userId, required this.kullaniciAdi});

  @override
  State<HomeContentView> createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  String _searchQuery = '';
  double _targetHours = 20.0, _completedHours = 12.0;
  String _time = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (mounted) setState(() => _time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);
    final vm = Provider.of<TodoViewModel>(context);

    final todos = vm.todos.where((t) {
      final matchSearch = (t.title ?? '').toLowerCase().contains(_searchQuery) || (t.description ?? '').toLowerCase().contains(_searchQuery);
      return matchSearch;
    }).toList();

    final total = vm.todos.length;
    final completed = vm.todos.where((t) => t.isCompleted == true).length;
    final rate = total > 0 ? completed / total : 0.0;

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: SafeArea(
        child: vm.isLoading
            ? Center(child: CircularProgressIndicator(color: theme.accentBlue))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${DateTime.now().day} • $_time", style: theme.subtitleStyle(10)),
                      const SizedBox(height: 4),
                      Text("${lang.translate('hello')},\n${widget.kullaniciAdi}", style: theme.titleStyle(22).copyWith(height: 1.15)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(icon: Icon(theme.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20, color: theme.textColor), onPressed: theme.toggleTheme),
                      IconButton(icon: Icon(Icons.notifications_outlined, size: 20, color: theme.textColor), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationScreen(userId: widget.userId)))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

             
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: theme.taskCardDecoration,
                child: TextField(
                  style: theme.tStyle(13, weight: FontWeight.normal),
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: theme.subtitleColor, size: 20),
                    hintText: lang.translate('search_in_todos'),
                    hintStyle: theme.subtitleStyle(13).copyWith(color: theme.subtitleColor.withOpacity(0.7)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

            
              Container(
                padding: const EdgeInsets.all(16),
                decoration: theme.taskCardDecoration,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lang.translate('general_average').toUpperCase(), style: theme.subtitleStyle(11)),
                        Text("${(rate * 100).toInt()}%", style: theme.titleStyle(14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: rate, backgroundColor: theme.borderColor, color: theme.accentBlue, minHeight: 6),
                    const SizedBox(height: 14),
                    _statRow(lang.translate('task_completion').toUpperCase(), "$completed/$total", rate, theme),
                    const SizedBox(height: 10),
                    _statRow(lang.translate('weekly_target').toUpperCase(), "${_completedHours.toInt()} / ${_targetHours.toInt()} ${lang.translate('hours')}", _targetHours > 0 ? _completedHours / _targetHours : 0.0, theme),
                  ],
                ),
              ),
              const SizedBox(height: 20),

            
              Text(lang.translate('upcoming_tasks'), style: theme.titleStyle(15)),
              const SizedBox(height: 10),
              TaskListWidget(todos: todos, userId: widget.userId),
              const SizedBox(height: 20),

             
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(userId: widget.userId))).then((v) {
                    if (v == true) vm.fetchTodos(widget.userId);
                  }),
                  icon: Icon(Icons.add, color: theme.isDarkMode ? Colors.white : Colors.black87),
                  label: Text(lang.translate('new_task'), style: theme.tStyle(14, color: theme.isDarkMode ? Colors.white : Colors.black87)),
                  style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue.withOpacity(0.15), padding: const EdgeInsets.symmetric(vertical: 14), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String title, String val, double progress, ThemeNotifier theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: theme.subtitleStyle(11)), Text(val, style: theme.titleStyle(12))]),
        const SizedBox(height: 4),
        LinearProgressIndicator(value: progress.clamp(0.0, 1.0), backgroundColor: theme.borderColor, color: theme.accentBlue, minHeight: 4),
      ],
    );
  }
}