import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class UIHelper {
  //Ekran Boyutları
  static double screenWidth(BuildContext context) => context.sized.width;
  static double screenHeight(BuildContext context) => context.sized.height;

  //Dinamik Yükseklik Boşlukları
  static Widget verticalSpaceLow(BuildContext context) => SizedBox(height: context.sized.dynamicHeight(0.01));
  static Widget verticalSpaceMedium(BuildContext context) => SizedBox(height: context.sized.dynamicHeight(0.02));
  static Widget verticalSpaceHigh(BuildContext context) => SizedBox(height: context.sized.dynamicHeight(0.05));

  //Dinamik Genişlik Boşlukları
  static Widget horizontalSpaceLow(BuildContext context) => SizedBox(width: context.sized.dynamicWidth(0.01));
  static Widget horizontalSpaceMedium(BuildContext context) => SizedBox(width: context.sized.dynamicWidth(0.03));
  static Widget horizontalSpaceHigh(BuildContext context) => SizedBox(width: context.sized.dynamicWidth(0.05));

  //Sabit Boşluk Kısayolları (Kod tekrarını önlemek için)
  static const Widget spaceH8 = SizedBox(height: 8);
  static const Widget spaceH12 = SizedBox(height: 12);
  static const Widget spaceH16 = SizedBox(height: 16);
  static const Widget spaceH20 = SizedBox(height: 20);
  static const Widget spaceH24 = SizedBox(height: 24);

  //Padding ve Margin
  static EdgeInsets get pagePadding => const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  static EdgeInsets get cardPadding => const EdgeInsets.all(16);
  static EdgeInsets get modalPadding => const EdgeInsets.all(20);

  //Dekorasyonlar
  static BorderRadius get borderRadius => BorderRadius.circular(16);
  static BorderRadius get cardBorderRadius => BorderRadius.circular(20);

  //Tema uyumlu ortak kart dekorasyonu
  static BoxDecoration cardDecoration(BuildContext context, Color cardColor, Color borderColor) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: cardBorderRadius,
      border: Border.all(color: borderColor.withOpacity(0.8), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}