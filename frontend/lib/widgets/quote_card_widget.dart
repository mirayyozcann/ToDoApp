// lib/widgets/quote_card_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';
import '../language_notifier.dart';

class QuoteCardWidget extends StatefulWidget {
  const QuoteCardWidget({super.key});

  @override
  State<QuoteCardWidget> createState() => _QuoteCardWidgetState();
}

class _QuoteCardWidgetState extends State<QuoteCardWidget> {
  static String? _cachedQuote;
  static String? _cachedLangCode;

  String _getRandomQuote(String langCode) {
  
    final List<String> quotes = langCode == 'tr' ? [
      "Bugün küçük bir adım, yarın büyük bir başarıdır.",
      "Zaman en değerli hazinedir, onu doğru yönet.",
      "Disiplin, hedefler ile başarı arasındaki köprüdür.",
      "Başarının sırrı, sürekli ve tutarlı çalışmaktır.",
      "Her yeni gün, yeni bir başlangıç fırsatıdır."
    ] : [
      "A small step today is a big success tomorrow.",
      "Time is the most valuable treasure, manage it wisely.",
      "Discipline is the bridge between goals and success.",
      "The secret of success is continuous and consistent work.",
      "Every new day is an opportunity for a new beginning."
    ];
    return quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    final lang = Provider.of<LanguageNotifier>(context);

    final currentLangCode = lang.currentLocale.languageCode;
    if (_cachedQuote == null || _cachedLangCode != currentLangCode) {
      _cachedLangCode = currentLangCode;
      _cachedQuote = _getRandomQuote(currentLangCode);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderColor.withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.accentBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.auto_awesome_rounded, color: theme.accentBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.translate('daily_motivation'), // Artık dil dosyasından çekiyor
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.accentBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _cachedQuote!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: theme.textColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
