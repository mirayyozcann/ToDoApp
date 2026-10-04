// lib/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../../widgets/user_header_widget.dart';
import '../../widgets/task_list_widget.dart';
import '../todo/todo_screen.dart';
import '../todo/stats_screen.dart';
import '../profile_screen.dart';
import '../../widgets/quote_card_widget.dart';
import '../../widgets/stats_widget.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String kullaniciAdi;

  const HomeScreen({super.key, required this.userId, required this.kullaniciAdi});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  double _weeklyTargetHours = 20.0;
  String _currentTime = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (mounted) setState(() => _currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoViewModel>(context, listen: false).fetchTodos(widget.userId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _showModal(ThemeNotifier theme, LanguageNotifier lang) {
    final tc = TextEditingController(text: _weeklyTargetHours.toInt().toString());
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.translate('edit_target'), style: theme.titleStyle(18)),
            const SizedBox(height: 16),
            TextField(controller: tc, keyboardType: TextInputType.number, style: theme.tStyle(14, weight: FontWeight.normal), decoration: theme.inputDec(lang.translate('weekly_target_hours'))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _weeklyTargetHours = double.tryParse(tc.text) ?? _weeklyTargetHours);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: Text(lang.translate('save_changes'), style: theme.tStyle(14, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, TodoViewModel vm, ThemeNotifier theme, LanguageNotifier lang) {
    final filtered = vm.todos.where((t) => (t.title ?? '').toLowerCase().contains(_searchQuery) || (t.description ?? '').toLowerCase().contains(_searchQuery)).toList();
    final total = vm.todos.length;
    final completed = vm.todos.where((t) => t.isCompleted == true).length;
    final recent = vm.todos.take(4).toList();

    return SafeArea(
      child: vm.isLoading
          ? Center(child: CircularProgressIndicator(color: theme.accentBlue))
          : SingleChildScrollView(
        key: const PageStorageKey<String>('home_screen_scroll_key'),
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHeaderWidget(userId: widget.userId, kullaniciAdi: widget.kullaniciAdi, currentTime: _currentTime),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lang.translate('review_plans'),
                          style: theme.subtitleStyle(12, weight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text("📌", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$completed/$total ${lang.translate('tasks_label')}",
                        style: theme.tStyle(11, color: theme.accentBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const QuoteCardWidget(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.borderColor.withOpacity(0.6), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: TextField(
                style: theme.tStyle(14, weight: FontWeight.normal),
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded, color: theme.accentBlue, size: 22),
                  hintText: lang.translate('search_in_todos'),
                  hintStyle: theme.subtitleStyle(13).copyWith(color: theme.subtitleColor.withOpacity(0.6)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            StatsWidget(weeklyTargetHours: _weeklyTargetHours, completedWeeklyHours: (completed * 2.0), totalTasks: total, completedTasks: completed, onEditTargetPressed: () => _showModal(theme, lang)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.translate('upcoming_tasks'), style: theme.titleStyle(16)),
                Text("${filtered.length} ${lang.translate('tasks')}", style: theme.subtitleStyle(12, weight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            TaskListWidget(todos: filtered, userId: widget.userId),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.translate('recent_activities'), style: theme.titleStyle(16)),
                Text("${recent.length} ${lang.translate('tasks')}", style: theme.subtitleStyle(12, weight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            recent.isEmpty
                ? Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: theme.taskCardDecoration, child: Text(lang.translate('no_tasks_found'), style: theme.subtitleStyle(13)))
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final todo = recent[i];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.borderColor.withOpacity(0.6), width: 1.2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: todo.isCompleted ? Colors.green.withOpacity(0.12) : theme.accentBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                        child: Icon(todo.isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded, size: 20, color: todo.isCompleted ? Colors.green : theme.accentBlue),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todo.title ?? '', style: theme.tStyle(13.5, weight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 3),
                            Text(todo.day ?? '', style: theme.subtitleStyle(11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: todo.isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          todo.isCompleted ? lang.translate('completed_status') : lang.translate('pending'),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: todo.isCompleted ? Colors.green : Colors.orange),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TodoViewModel>(context);
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(context, vm, theme, lang),
          TodoScreen(userId: widget.userId),
          StatsScreen(userId: widget.userId),
          ProfileScreen(userId: widget.userId, initialName: widget.kullaniciAdi, onProfileUpdated: (_) {}),
        ],
      ),
    );
  }
}