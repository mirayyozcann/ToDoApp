// lib/screens/edit_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_notifier.dart';
import '../../language_notifier.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../../responsive_helper.dart';

class EditTaskScreen extends StatefulWidget {
  final int taskId, userId;
  final String initialTitle, initialDescription, initialCategory, initialPriority, initialDay, initialDeadlineTime;

  const EditTaskScreen({super.key, required this.taskId, required this.userId, required this.initialTitle, required this.initialDescription, required this.initialCategory, required this.initialPriority, required this.initialDay, required this.initialDeadlineTime});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController, _descriptionController;
  late String _selectedCategory, _selectedPriority;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedCategory = _normalize(widget.initialCategory, ['kişisel', 'personal'], ['gelişim', 'growth'], 'personal', 'growth', 'work');
    _selectedPriority = _normalize(widget.initialPriority, ['düşük', 'low'], ['yüksek', 'high'], 'low', 'high', 'medium');
    _selectedDate = DateTime.tryParse(widget.initialDay) ?? DateTime.now();

    if (widget.initialDeadlineTime.isNotEmpty) {
      final p = widget.initialDeadlineTime.split(':');
      _selectedTime = p.length == 2 ? TimeOfDay(hour: int.tryParse(p[0]) ?? 12, minute: int.tryParse(p[1]) ?? 0) : TimeOfDay.now();
    } else {
      _selectedTime = TimeOfDay.now();
    }
  }

  String _normalize(String val, List<String> k1, List<String> k2, String o1, String o2, String def) {
    String lower = val.toLowerCase();
    if (k1.any((e) => lower.contains(e))) return o1;
    if (k2.any((e) => lower.contains(e))) return o2;
    return def;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);
    final fDate = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final fTime = "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.textColor), onPressed: () => Navigator.pop(context)),
        title: Text(lang.translate('edit_task_title'), style: theme.titleStyle(20)),
      ),
      body: SingleChildScrollView(
        padding: UIHelper.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.translate('task_name'), style: theme.subtitleStyle(13, weight: FontWeight.w600)),
            UIHelper.verticalSpaceLow(context),
            TextField(controller: _titleController, style: theme.tStyle(16, weight: FontWeight.w500), decoration: InputDecoration(filled: true, fillColor: theme.cardColor, border: OutlineInputBorder(borderRadius: UIHelper.borderRadius, borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
            UIHelper.spaceH20,
            Text(lang.translate('task_detail'), style: theme.subtitleStyle(13, weight: FontWeight.w600)),
            UIHelper.verticalSpaceLow(context),
            TextField(controller: _descriptionController, maxLines: 4, style: theme.tStyle(15, weight: FontWeight.normal), decoration: InputDecoration(filled: true, fillColor: theme.cardColor, border: OutlineInputBorder(borderRadius: UIHelper.borderRadius, borderSide: BorderSide.none), contentPadding: UIHelper.cardPadding)),
            UIHelper.spaceH20,
            Text(lang.translate('categories'), style: theme.subtitleStyle(13, weight: FontWeight.w600)),
            UIHelper.verticalSpaceLow(context),
            Row(
              children: [
                _chip("work", lang.translate('work'), Icons.work_outline, theme),
                UIHelper.horizontalSpaceMedium(context),
                _chip("personal", lang.translate('personal'), Icons.person_outline, theme),
                UIHelper.horizontalSpaceMedium(context),
                _chip("growth", lang.translate('growth'), Icons.trending_up, theme),
              ],
            ),
            UIHelper.spaceH20,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lang.translate('due_date'), style: theme.subtitleStyle(13, weight: FontWeight.w600)),
                      UIHelper.verticalSpaceLow(context),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                          if (picked != null) setState(() => _selectedDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: UIHelper.borderRadius),
                          child: Row(children: [Icon(Icons.calendar_today_outlined, color: theme.subtitleColor, size: 18), UIHelper.horizontalSpaceMedium(context), Expanded(child: Text(fDate, style: theme.tStyle(14, weight: FontWeight.w500), overflow: TextOverflow.ellipsis))]),
                        ),
                      ),
                    ],
                  ),
                ),
                UIHelper.horizontalSpaceMedium(context),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Saat", style: theme.subtitleStyle(13, weight: FontWeight.w600)),
                      UIHelper.verticalSpaceLow(context),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                          if (picked != null) setState(() => _selectedTime = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: UIHelper.borderRadius),
                          child: Row(children: [Icon(Icons.access_time, color: theme.subtitleColor, size: 18), UIHelper.horizontalSpaceMedium(context), Expanded(child: Text(fTime, style: theme.tStyle(14, weight: FontWeight.w500), overflow: TextOverflow.ellipsis))]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            UIHelper.spaceH20,
            Text(lang.translate('priority_status'), style: theme.subtitleStyle(13, weight: FontWeight.w600)),
            UIHelper.verticalSpaceLow(context),
            Row(
              children: [
                _priorityBtn("low", lang.translate('priority_low'), theme.priorityLow, theme),
                UIHelper.horizontalSpaceMedium(context),
                _priorityBtn("medium", lang.translate('priority_medium'), theme.priorityMedium, theme),
                UIHelper.horizontalSpaceMedium(context),
                _priorityBtn("high", lang.translate('priority_high'), theme.priorityHigh, theme),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: theme.accentBlue.withOpacity(0.85), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: UIHelper.cardBorderRadius), elevation: 0),
                onPressed: () async {
                  await Provider.of<TodoViewModel>(context, listen: false).updateTodo(widget.taskId, _titleController.text.trim(), _descriptionController.text.trim(), false, _selectedPriority, _selectedCategory, fDate, fTime, widget.userId);
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Icon(Icons.save_outlined, size: 20), UIHelper.horizontalSpaceMedium(context), Text(lang.translate('save_changes'), style: theme.tStyle(16, color: Colors.white, weight: FontWeight.bold))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String key, String label, IconData icon, ThemeNotifier theme) {
    bool isSel = _selectedCategory == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: isSel ? theme.priorityBadgeDecoration(theme.accentBlue) : BoxDecoration(color: theme.cardColor, borderRadius: UIHelper.borderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSel ? theme.accentBlue : theme.textColor),
              const SizedBox(width: 4),
              Flexible(child: Text(label, style: theme.tStyle(12, color: isSel ? theme.accentBlue : theme.textColor, weight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityBtn(String key, String label, Color color, ThemeNotifier theme) {
    bool isSel = _selectedPriority == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: isSel ? BoxDecoration(color: color, borderRadius: UIHelper.borderRadius) : BoxDecoration(color: theme.cardColor, borderRadius: UIHelper.borderRadius),
          alignment: Alignment.center,
          child: Text(label, style: theme.tStyle(12, color: isSel ? Colors.white : theme.textColor, weight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}