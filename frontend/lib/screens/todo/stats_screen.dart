// lib/screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../../responsive_helper.dart';

class StatsScreen extends StatefulWidget {
  final int userId;
  const StatsScreen({super.key, required this.userId});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedDayIndex = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<TodoViewModel>(context, listen: false);
      vm.fetchTodos(widget.userId);
      vm.fetchStats(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);

    return SafeArea(
      child: Consumer<TodoViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return Center(child: CircularProgressIndicator(color: theme.accentBlue));

          final todos = vm.todos;
          final totalCount = todos.length;
          final completedCount = todos.where((t) => t.isCompleted == true).length;
          final pendingCount = totalCount - completedCount;
          final scorePercentage = totalCount > 0 ? ((completedCount / totalCount) * 100).round() : 0;

          final now = DateTime.now();
          final days = <String>[];
          final weeklyData = <double>[];
          final dayTasksList = <List<dynamic>>[];

          final daysKeys = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
          const trFull = ["pazartesi", "salı", "çarşamba", "perşembe", "cuma", "cumartesi", "pazar"];
          const enFull = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];

          for (int i = 6; i >= 0; i--) {
            final date = now.subtract(Duration(days: i));
            final idx = date.weekday - 1;

            final short = context.t(daysKeys[idx]);
            days.add(short);

            final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

            final dayTodos = todos.where((t) {
              final taskDay = (t.day ?? '').trim().toLowerCase();
              if (taskDay.isEmpty) return false;
              return taskDay.contains(short.toLowerCase()) || taskDay.contains(trFull[idx]) || taskDay.contains(enFull[idx]) || taskDay.contains(dateStr);
            }).toList();

            dayTasksList.add(dayTodos);

            double rate = 0.0;
            if (dayTodos.isNotEmpty) {
              rate = dayTodos.where((t) => t.isCompleted == true).length / dayTodos.length;
            } else if (i == 6 && totalCount > 0) {
              rate = completedCount / totalCount;
            }
            weeklyData.add(rate.clamp(0.0, 1.0));
          }

          if (_selectedDayIndex >= days.length) _selectedDayIndex = days.length - 1;
          final selDayName = days[_selectedDayIndex];
          final selTasks = dayTasksList[_selectedDayIndex];
          final selCompleted = selTasks.where((t) => t.isCompleted == true).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.t('stats'), style: theme.titleStyle(24)),
                        const SizedBox(height: 2),
                        Text(context.t('stats_subtitle'), style: theme.subtitleStyle(12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: UIHelper.cardDecoration(context, theme.cardColor, theme.borderColor),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: theme.accentBlue),
                          UIHelper.horizontalSpaceLow(context),
                          Text(context.t('this_week'), style: theme.tStyle(11, color: theme.textColor, weight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelper.spaceH20,
                Container(
                  width: double.infinity,
                  padding: UIHelper.cardPadding,
                  decoration: theme.taskCardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: theme.accentBlue.withOpacity(0.12), borderRadius: UIHelper.borderRadius),
                                child: Icon(Icons.bar_chart_rounded, color: theme.accentBlue, size: 18),
                              ),
                              UIHelper.horizontalSpaceMedium(context),
                              Text(context.t('activity_chart'), style: theme.titleStyle(15)),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              "%$scorePercentage ${context.t('success_rate')}",
                              style: theme.tStyle(12, color: theme.accentBlue, weight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      UIHelper.spaceH16,
                      // TAŞMA RİSKİNİ TAMAMEN ORTADAN KALDIRAN GÜVENLİ KISIM
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: theme.priorityBadgeDecoration(theme.accentBlue),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 16, color: theme.accentBlue),
                            UIHelper.horizontalSpaceMedium(context),
                            Expanded(
                              child: Text(
                                "$selDayName: $selCompleted / ${selTasks.length} ${context.t('tasks_count')}",
                                style: theme.tStyle(12, color: theme.textColor, weight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selTasks.isEmpty ? context.t('no_tasks_found') : "%${((selCompleted / selTasks.length) * 100).round()}",
                              style: theme.tStyle(12, color: theme.accentBlue, weight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      UIHelper.spaceH20,
                      SizedBox(
                        height: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(7, (i) {
                            final isSelected = _selectedDayIndex == i;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedDayIndex = i),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: isSelected ? 16 : 12,
                                        height: (80 * weeklyData[i]).clamp(10.0, 80.0),
                                        decoration: BoxDecoration(
                                          color: isSelected ? theme.accentBlue : (i == 6 ? theme.accentBlue.withOpacity(0.7) : theme.accentBlue.withOpacity(0.25)),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  UIHelper.spaceH8,
                                  Text(days[i], style: theme.tStyle(11.5, color: isSelected ? theme.accentBlue : theme.subtitleColor, weight: isSelected ? FontWeight.bold : FontWeight.w500)),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.spaceH16,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: UIHelper.cardPadding,
                        decoration: UIHelper.cardDecoration(context, theme.cardColor, theme.borderColor),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: totalCount > 0 ? (completedCount / totalCount) : 0.0,
                                    strokeWidth: 8,
                                    backgroundColor: theme.borderColor.withOpacity(0.4),
                                    valueColor: AlwaysStoppedAnimation<Color>(theme.accentBlue),
                                    strokeCap: StrokeCap.round,
                                  ),
                                  Text("%$scorePercentage", style: theme.titleStyle(18)),
                                ],
                              ),
                            ),
                            UIHelper.spaceH12,
                            Text(context.t('efficiency_score'), style: theme.subtitleStyle(11, weight: FontWeight.bold), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpaceMedium(context),
                    Expanded(
                      child: Column(
                        children: [
                          _buildStatRow(context.t('completed'), "$completedCount", Icons.check_circle_rounded, Colors.green, theme),
                          UIHelper.spaceH8,
                          _buildStatRow(context.t('pending'), "$pendingCount", Icons.hourglass_top_rounded, Colors.orange, theme),
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelper.spaceH20,
                Text(context.t('achievements'), style: theme.titleStyle(16)),
                UIHelper.spaceH12,
                Container(
                  padding: UIHelper.cardPadding,
                  decoration: UIHelper.cardDecoration(context, theme.cardColor, theme.borderColor),
                  child: Column(
                    children: [
                      _buildAchievement(Icons.local_fire_department_rounded, const Color(0xFFE3B341), context.t('active_streak'), "$completedCount ${context.t('day_streak')}", theme),
                      Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Divider(color: theme.borderColor.withOpacity(0.5), height: 1)),
                      _buildAchievement(Icons.military_tech_rounded, const Color(0xFF8A7CFB), context.t('task_monster'), totalCount >= 5 ? context.t('master_level') : context.t('apprentice_level'), theme),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String title, String value, IconData icon, Color color, ThemeNotifier theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: UIHelper.cardDecoration(context, theme.cardColor, theme.borderColor),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: UIHelper.borderRadius),
            child: Icon(icon, color: color, size: 18),
          ),
          UIHelper.horizontalSpaceMedium(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.subtitleStyle(10, weight: FontWeight.w600)),
                Text(value, style: theme.titleStyle(16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievement(IconData icon, Color color, String title, String subtitle, ThemeNotifier theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: UIHelper.cardBorderRadius),
          child: Icon(icon, color: color, size: 22),
        ),
        UIHelper.horizontalSpaceMedium(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.titleStyle(13)),
              const SizedBox(height: 2),
              Text(subtitle, style: theme.subtitleStyle(11)),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: theme.subtitleColor, size: 18),
      ],
    );
  }
}