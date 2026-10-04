import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';

class StatsWidget extends StatelessWidget {
  final double weeklyTargetHours;
  final double completedWeeklyHours;
  final int totalTasks;
  final int completedTasks;
  final VoidCallback onEditTargetPressed;

  const StatsWidget({
    super.key,
    required this.weeklyTargetHours,
    required this.completedWeeklyHours,
    required this.totalTasks,
    required this.completedTasks,
    required this.onEditTargetPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    double completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;
    double weeklyProgressRate = weeklyTargetHours > 0 ? (completedWeeklyHours / weeklyTargetHours) : 0.0;
    if (weeklyProgressRate > 1.0) weeklyProgressRate = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Üst Başlık ve Düzenle Butonu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.accentBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  lang.translate('overview'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textColor),
                ),
              ],
            ),
            GestureDetector(
              onTap: onEditTargetPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 13, color: theme.accentBlue),
                    const SizedBox(width: 4),
                    Text(
                      lang.translate('edit_target'),
                      style: TextStyle(fontSize: 11, color: theme.accentBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Modern 2'li Grid Yapısı (İstatistik Kartları)
        Row(
          children: [
            // 1. KART: Genel Başarı (Dairesel / Halka Görünümlü His)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.cardColor,
                      theme.cardColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.borderColor.withOpacity(0.8), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.accentBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.pie_chart_rounded, size: 18, color: theme.accentBlue),
                        ),
                        Text(
                          "${(completionRate * 100).toInt()}%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      lang.translate('general_average'),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.subtitleColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$completedTasks / $totalTasks ${lang.translate('tasks_label')}",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.textColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),

            // 2. KART: Haftalık Hedef Durumu
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.cardColor,
                      theme.cardColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.borderColor.withOpacity(0.8), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.local_fire_department_rounded, size: 18, color: Colors.orange),
                        ),
                        Text(
                          "${(weeklyProgressRate * 100).toInt()}%",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      lang.translate('weekly_target'),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.subtitleColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${completedWeeklyHours.toInt()} / ${weeklyTargetHours.toInt()} ${lang.translate('hours')}",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.textColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}