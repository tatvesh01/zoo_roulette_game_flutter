import 'package:flutter/material.dart';

class ColorHelper {
  static const Color bgColor = Color(0xFFEEEEEE);
  static const appColorsGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [tersoryColor, secondryColor, primaryAppColor],
      tileMode: TileMode.decal);
  static const appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryAppColor, tersoryColor],
  );
  static const textColorGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.grey],
  );
  // static const Color primaryred = Color(0xFFE10000);
  static const Color primaryAppColor = Colors.purple;
  static const Color secondryColor = Color.fromARGB(255, 39, 133, 176);
  static const Color tersoryColor = Color.fromARGB(255, 39, 92, 176);

  static const Color primaryred = Color(0xFFE10000);
  static Color primaryredlight = const Color(0xFFE10000).withOpacity(0.1);
  static const Color black = Color(0xFF000000);
  static const Color btnRed = Color(0xFFFF4646);
  static const Color darkBlue = Color(0xFF012169);
  static const Color white = Color(0xFFFFFFFF);
  static const Color light_gray = Color(0xff373737);
  static const Color gray = Color(0xff8C8C8C);
  static const Color lightGray2 = Color(0xff8C8C8C);
  static const Color offWhite = Colors.white70;
}
