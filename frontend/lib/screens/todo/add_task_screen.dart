// lib/screens/add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../language_notifier.dart';
import '../../responsive_helper.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../../theme_notifier.dart';

class AddTaskScreen extends StatefulWidget {
  final int userId;

  const AddTaskScreen({super.key, required this.userId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _selectedCategory = 'work';
  String _selectedPriority = 'medium';
  String _dueDate = '';
  String _dueTime = '';

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoViewModel>(context);
    final theme = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textColor),
        title: Text(context.t('app_title'), style: theme.titleStyle(18)),
        centerTitle: true,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.t('new_task_title'), style: theme.titleStyle(26)),
              UIHelper.verticalSpaceLow(context),
              Text(context.t('new_task_subtitle'), style: theme.subtitleStyle(13)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: theme.taskCardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.t('task_name_label'), style: theme.subtitleStyle(11, weight: FontWeight.bold)),
                    TextField(
                      controller: _titleController,
                      style: theme.tStyle(14, weight: FontWeight.normal),
                      decoration: InputDecoration(
                        hintText: context.t('task_name_hint'),
                        hintStyle: theme.subtitleStyle(13).copyWith(color: theme.subtitleColor.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(color: theme.borderColor, height: 24),
                    Text(context.t('task_desc_label'), style: theme.subtitleStyle(11, weight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      style: theme.tStyle(14, weight: FontWeight.normal),
                      decoration: InputDecoration(
                        hintText: context.t('task_desc_hint'),
                        hintStyle: theme.subtitleStyle(13).copyWith(color: theme.subtitleColor.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                    Divider(color: theme.borderColor, height: 24),
                    Text(context.t('category_label'), style: theme.subtitleStyle(11, weight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildCategoryButton(context.t('category_work'), Icons.work_outline, _selectedCategory == 'work', theme, () => setState(() => _selectedCategory = 'work')),
                        const SizedBox(width: 8),
                        _buildCategoryButton(context.t('category_personal'), Icons.person_outline, _selectedCategory == 'personal', theme, () => setState(() => _selectedCategory = 'personal')),
                        const SizedBox(width: 8),
                        _buildCategoryButton(context.t('category_growth'), Icons.school_outlined, _selectedCategory == 'growth', theme, () => setState(() => _selectedCategory = 'growth')),
                      ],
                    ),
                    Divider(color: theme.borderColor, height: 28),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.t('due_date_label'), style: theme.subtitleStyle(11, weight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextField(
                                style: theme.tStyle(14, weight: FontWeight.normal),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2030),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dueDate = "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: _dueDate.isEmpty ? context.t('select_date_hint') : _dueDate,
                                  hintStyle: theme.subtitleStyle(13).copyWith(color: _dueDate.isEmpty ? theme.subtitleColor.withOpacity(0.5) : theme.textColor),
                                  suffixIcon: Icon(Icons.calendar_today, size: 16, color: theme.subtitleColor),
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.t('time_label'), style: theme.subtitleStyle(11, weight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextField(
                                style: theme.tStyle(14, weight: FontWeight.normal),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      final hours = pickedTime.hour.toString().padLeft(2, '0');
                                      final minutes = pickedTime.minute.toString().padLeft(2, '0');
                                      _dueTime = "$hours:$minutes";
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: _dueTime.isEmpty ? "17:00" : _dueTime,
                                  hintStyle: theme.subtitleStyle(13).copyWith(color: _dueTime.isEmpty ? theme.subtitleColor.withOpacity(0.5) : theme.textColor),
                                  suffixIcon: Icon(Icons.access_time, size: 16, color: theme.subtitleColor),
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: theme.borderColor, height: 24),
                    Text(context.t('priority_label'), style: theme.subtitleStyle(11, weight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildPriorityButton(context.t('priority_low'), _selectedPriority == 'low', theme.priorityLow, theme, () => setState(() => _selectedPriority = 'low')),
                        const SizedBox(width: 8),
                        _buildPriorityButton(context.t('priority_medium'), _selectedPriority == 'medium', theme.priorityMedium, theme, () => setState(() => _selectedPriority = 'medium')),
                        const SizedBox(width: 8),
                        _buildPriorityButton(context.t('priority_high'), _selectedPriority == 'high', theme.priorityHigh, theme, () => setState(() => _selectedPriority = 'high')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.accentBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (_titleController.text.trim().isNotEmpty) {
                            if (_dueDate.isEmpty) {
                              _showMessage(context.t('error_select_date'));
                              return;
                            }

                            bool success = await viewModel.addTodo(
                              widget.userId,
                              _titleController.text.trim(),
                              _descController.text.trim(),
                              _selectedPriority,
                              _dueDate,
                              _dueTime.isEmpty ? "00:00" : _dueTime,
                              _selectedCategory,
                            );
                            if (success) {
                              _showMessage(context.t('success_task_created'), isError: false);
                              Navigator.pop(context);
                            } else {
                              _showMessage(context.t('error_task_failed'));
                            }
                          } else {
                            _showMessage(context.t('error_title_empty'));
                          }
                        },
                        child: Text(context.t('create_task_button'), style: theme.tStyle(15, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon, bool isSelected, ThemeNotifier theme, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: isSelected
              ? theme.priorityBadgeDecoration(theme.accentBlue)
              : BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.borderColor, width: 1.5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? theme.accentBlue : theme.subtitleColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: theme.tStyle(11, color: isSelected ? theme.accentBlue : theme.textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String label, bool isSelected, Color activeColor, ThemeNotifier theme, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          alignment: Alignment.center,
          decoration: isSelected
              ? theme.priorityBadgeDecoration(activeColor)
              : BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.borderColor, width: 1.5)),
          child: Text(
            label,
            style: theme.tStyle(12, color: isSelected ? activeColor : theme.textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}