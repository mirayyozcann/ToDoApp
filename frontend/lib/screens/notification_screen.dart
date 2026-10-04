// lib/screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';
import '../viewmodels/todo_viewmodel.dart';

class NotificationScreen extends StatelessWidget {
  final int userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoViewModel>(context);
    final lang = Provider.of<LanguageNotifier>(context);
    final theme = Provider.of<ThemeNotifier>(context);
    final notifications = viewModel.notifications;

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textColor),
        title: Text(
          lang.translate('notifications'),
          style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
        child: Text(
          lang.translate('no_notifications_yet'),
          style: TextStyle(color: theme.subtitleColor, fontSize: 14),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];

          final translatedTitle = lang.translate(notif.titleKey);
          final translatedMsgAction = lang.translate(notif.messageKey);
          final finalMessage = "'${notif.taskTitle}' $translatedMsgAction";

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.borderColor),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: theme.accentBlue.withOpacity(0.15),
                child: Icon(Icons.notifications_active, color: theme.accentBlue, size: 20),
              ),
              title: Text(
                translatedTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textColor),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  finalMessage,
                  style: TextStyle(fontSize: 12, color: theme.subtitleColor),
                ),
              ),
              trailing: Text(
                "${notif.time.hour.toString().padLeft(2, '0')}:${notif.time.minute.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 11, color: theme.subtitleColor),
              ),
            ),
          );
        },
      ),
    );
  }
}