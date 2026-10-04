import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Color get bgColor => _themeMode == ThemeMode.dark
      ? const Color(0xFF020617)
      : const Color(0xFFF1F5F9);

  Color get cardColor => _themeMode == ThemeMode.dark
      ? const Color(0xFF0B1120)
      : Colors.white;

  Color get textColor => _themeMode == ThemeMode.dark
      ? const Color(0xFFF1F5F9)
      : const Color(0xFF0F172A);

  Color get subtitleColor => _themeMode == ThemeMode.dark
      ? const Color(0xFF64748B)
      : const Color(0xFF475569);

  Color get accentBlue => _themeMode == ThemeMode.dark
      ? const Color(0xFF0891B2)
      : const Color(0xFF0369A1);

  Color get borderColor => _themeMode == ThemeMode.dark
      ? const Color(0xFF1E293B)
      : const Color(0xFFE2E8F0);

  // --- ÖNCELİK RENKLERİ ---
  Color get priorityHigh => const Color(0xFFE11D48);
  Color get priorityMedium => const Color(0xFFD97706);
  Color get priorityLow => const Color(0xFF059669);



  // Ana banner için daha derin gradient
  LinearGradient get primaryGradient => LinearGradient(
    colors: _themeMode == ThemeMode.dark
        ? [const Color(0xFF0369A1), const Color(0xFF083344)] // Çok derin geçiş
        : [const Color(0xFF0284C7), const Color(0xFF0369A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Kartlara görsel derinlik veren gölge
  List<BoxShadow> get neonShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Kartın genel kutu tasarımı 
  BoxDecoration get taskCardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: borderColor,
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: _themeMode == ThemeMode.dark
            ? Colors.black.withOpacity(0.4)
            : Colors.blue.withOpacity(0.06),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // Öncelik etiketleri 
  BoxDecoration priorityBadgeDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.15),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withOpacity(0.4), width: 1),
  );
  // Metin stilleri (Kısa isimlerle)
  TextStyle tStyle(double size, {Color? color, FontWeight weight = FontWeight.bold}) =>
      TextStyle(fontSize: size, color: color ?? textColor, fontWeight: weight);

  // Input stili (Modal'daki o uzun dekorasyonları tek satıra indirir)
  InputDecoration inputDec(String label, {Color? color}) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: color ?? subtitleColor),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: accentBlue)),
  );

  // --- HAZIR METİN STİLLERİ ---
  TextStyle titleStyle(double size, {FontWeight weight = FontWeight.bold, Color? color}) =>
      TextStyle(fontSize: size, fontWeight: weight, color: color ?? textColor);

  TextStyle subtitleStyle(double size, {FontWeight weight = FontWeight.normal}) =>
      TextStyle(fontSize: size, fontWeight: weight, color: subtitleColor);
  // Sol taraftaki ikonun arkasındaki parıltılı yuvarlak kutu
  BoxDecoration iconBoxDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.15),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.15),
        blurRadius: 8,
      ),
    ],
  );
}