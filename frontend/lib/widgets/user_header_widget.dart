// lib/widgets/user_header_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';
import '../screens/notification_screen.dart';

class UserHeaderWidget extends StatelessWidget {
  final int userId;
  final String kullaniciAdi;
  final String currentTime;

  const UserHeaderWidget({
    super.key,
    required this.userId,
    required this.kullaniciAdi,
    required this.currentTime,
  });

  String _getFormattedDate(LanguageNotifier lang) {
    DateTime now = DateTime.now();
    bool isTr = lang.currentLocale.languageCode == 'tr';

    List<String> monthsTr = [
      "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
      "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
    ];

    List<String> monthsEn = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    String monthName = isTr ? monthsTr[now.month - 1] : monthsEn[now.month - 1];
    return "${now.day} $monthName ${now.year}";
  }

  String _getGreeting(LanguageNotifier lang) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return lang.translate('good_morning');
    } else if (hour < 18) {
      return lang.translate('good_afternoon');
    } else {
      return lang.translate('good_evening');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol Taraf: Modern Karşılama ve Bilgiler
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst minik bilgi satırı (Tarih ve Saat)
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: theme.subtitleColor),
                    const SizedBox(width: 4),
                    Text(
                      _getFormattedDate(lang),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.subtitleColor, letterSpacing: 0.3),
                    ),
                    if (currentTime.isNotEmpty) ...[
                      Text(" • ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.subtitleColor)),
                      Text(currentTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.accentBlue)),
                    ],
                  ],
                ),
                const SizedBox(height: 6),

              
                Text(
                  _getGreeting(lang),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.subtitleColor,
                  ),
                ),
                const SizedBox(height: 2),

                
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        kullaniciAdi,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text(" 👋", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Sağ Taraf: Tema ve Bildirim Butonları (Dikey hizalama ile çakışma önlendi)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.borderColor.withOpacity(0.6), width: 1.2),
                    ),
                    child: IconButton(
                      icon: Icon(
                        theme.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: theme.textColor,
                        size: 20,
                      ),
                      onPressed: () => theme.toggleTheme(),
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.borderColor.withOpacity(0.6), width: 1.2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.notifications_outlined, color: theme.textColor, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationScreen(userId: userId)),
                        );
                      },
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}