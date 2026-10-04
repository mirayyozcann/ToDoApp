import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'languages/app_tr.dart';
import 'languages/app_en.dart';

class LanguageNotifier extends ChangeNotifier {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Locale _currentLocale = const Locale('tr');
  Locale get currentLocale => _currentLocale;

  final Map<String, Map<String, String>> _localizedValues = {
    'tr': trValues,
    'en': enValues,
  };

  LanguageNotifier() { _loadLanguage(); }

  void changeLanguage(String languageCode) async {
    if (languageCode != 'tr' && languageCode != 'en') return; // (Eğer diğer dilleri de eklediysen buradaki kontrolü genişletebilirsin)
    if (_currentLocale.languageCode == languageCode) return;

    _currentLocale = Locale(languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_lang', languageCode);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('selected_lang');
    if (savedLang != null) {
      _currentLocale = Locale(savedLang);
      notifyListeners();
    }
  }

  String translate(String key) {
    return _localizedValues[_currentLocale.languageCode]?[key] ?? key;
  }
}

extension LocalizationExtension on BuildContext {
  String t(String key) => Provider.of<LanguageNotifier>(this, listen: false).translate(key);
}