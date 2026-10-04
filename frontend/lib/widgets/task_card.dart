// lib/widgets/task_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final String priority;
  final String day;
  final String time;
  final VoidCallback onDismissed;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final String uniqueKey;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.day,
    required this.time,
    required this.onDismissed,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.uniqueKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    Color priorityColor;
    String pLower = priority.toLowerCase();

    if (pLower == 'yüksek' || pLower == 'high') {
      priorityColor = theme.priorityHigh;
    } else if (pLower == 'düşük' || pLower == 'low') {
      priorityColor = theme.priorityLow;
    } else {
      priorityColor = theme.priorityMedium;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: priorityColor.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Dismissible(
          key: Key(uniqueKey),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDismissed(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade700,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.isDarkMode
                    ? [const Color(0xFF0B132B), const Color(0xFF030712)]
                    : [Colors.white, const Color(0xFFF0F9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: priorityColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 115,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          bottomLeft: Radius.circular(22),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: onToggle,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: priorityColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: priorityColor.withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  isCompleted ? Icons.check_circle_rounded : Icons.radar_rounded,
                                  color: isCompleted ? Colors.blueGrey : priorityColor,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted ? theme.subtitleColor : theme.textColor,
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (description.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      description,
                                      style: TextStyle(fontSize: 11.5, color: theme.subtitleColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: theme.borderColor.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.access_time_rounded, size: 11, color: theme.subtitleColor),
                                        const SizedBox(width: 3),
                                        Flexible(
                                          child: Text(
                                            time.isNotEmpty ? "$day, $time" : day,
                                            style: TextStyle(fontSize: 10.5, color: theme.subtitleColor, fontWeight: FontWeight.w600),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: priorityColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: priorityColor.withOpacity(0.4),
                                        blurRadius: 4,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    priority.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: onEdit,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(Icons.edit_outlined, color: theme.accentBlue, size: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    InkWell(
                                      onTap: onDelete,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(Icons.delete_outline_rounded, color: theme.subtitleColor, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}