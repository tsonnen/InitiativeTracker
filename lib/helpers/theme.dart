import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData mapTheme(String theme) {
    switch (theme) {
      case 'light':
        return light;
      case 'dark':
        return dark;
      default:
        break;
    }
    return dark; // personal preference
  }

  static var light = ThemeData(brightness: Brightness.light);

  static var dark = ThemeData(brightness: Brightness.dark);
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
