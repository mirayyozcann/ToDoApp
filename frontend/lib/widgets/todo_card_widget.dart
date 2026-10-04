import 'package:flutter/material.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';

class TodoCardWidget extends StatelessWidget {
  final dynamic todo;
  final ThemeNotifier theme;
  final LanguageNotifier lang;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TodoCardWidget({
    super.key,
    required this.todo,
    required this.theme,
    required this.lang,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = todo.isCompleted ?? false;
    final String rawPriority = todo.priority ?? 'Orta';
    final String translatedPriority = _getTranslatedPriority(rawPriority, lang);

    Color priorityBg;
    Color priorityTextColor;
    final String lowerP = rawPriority.toLowerCase();
    if (lowerP.contains('yüksek') || lowerP.contains('high')) {
      priorityBg = Colors.red.withOpacity(0.12);
      priorityTextColor = Colors.redAccent;
    } else if (lowerP.contains('düşük') || lowerP.contains('low')) {
      priorityBg = Colors.green.withOpacity(0.12);
      priorityTextColor = Colors.green;
    } else {
      priorityBg = Colors.orange.withOpacity(0.12);
      priorityTextColor = Colors.orange;
    }

    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.delete_rounded, color: Colors.white, size: 24), SizedBox(height: 2), Text("Sil", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))]),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isCompleted ? Colors.green.withOpacity(0.4) : theme.borderColor.withOpacity(0.6), width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onToggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(top: 2),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isCompleted ? Colors.green : theme.subtitleColor.withOpacity(0.6), width: 2),
                          ),
                          child: isCompleted ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todo.title ?? '', style: TextStyle(color: isCompleted ? theme.subtitleColor : theme.textColor, fontSize: 14.5, fontWeight: FontWeight.w600, decoration: isCompleted ? TextDecoration.lineThrough : null), maxLines: 1, overflow: TextOverflow.ellipsis),
                            if (todo.description != null && todo.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(todo.description!, style: TextStyle(color: theme.subtitleColor, fontSize: 12.5, decoration: isCompleted ? TextDecoration.lineThrough : null), maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: theme.accentBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(_getCategoryIcon(todo.category), size: 16, color: theme.accentBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: priorityBg, borderRadius: BorderRadius.circular(8)),
                        child: Text(translatedPriority, style: TextStyle(color: priorityTextColor, fontSize: 10.5, fontWeight: FontWeight.bold)),
                      ),
                      if (todo.day != null && todo.day!.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, color: theme.subtitleColor, size: 13),
                            const SizedBox(width: 5),
                            Text((todo.deadlineTime != null && todo.deadlineTime!.isNotEmpty) ? "${todo.day}, ${todo.deadlineTime}" : todo.day!, style: TextStyle(color: theme.subtitleColor, fontSize: 11.5, fontWeight: FontWeight.w500)),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTranslatedPriority(String priority, LanguageNotifier lang) {
    final String p = priority.toLowerCase().trim();
    if (p.contains('high') || p.contains('yüksek')) return lang.translate('priority_high');
    if (p.contains('low') || p.contains('düşük')) return lang.translate('priority_low');
    if (p.contains('medium') || p.contains('orta')) return lang.translate('priority_medium');
    return priority;
  }

  IconData _getCategoryIcon(String? category) {
    final cat = (category ?? '').toLowerCase();
    if (cat.contains('work') || cat.contains('iş')) return Icons.work_rounded;
    if (cat.contains('personal') || cat.contains('kişisel')) return Icons.bookmark_rounded;
    if (cat.contains('growth') || cat.contains('gelişim')) return Icons.trending_up_rounded;
    return Icons.task_alt_rounded;
  }
}