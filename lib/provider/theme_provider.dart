import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  void toggleTheme(){
    isDark = !isDark;
    notifyListeners();
  }

  var lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: Colors.grey[800]!,
      onSurface: Colors.black,
      inversePrimary: Colors.grey[600],
      secondary: Colors.grey[300]!,
      surface: Colors.white,
    ),
  );

  var darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Colors.grey[200]!,
      onSurface: Colors.white,
      inversePrimary: Colors.grey[300],
      secondary: Colors.grey[800]!,
      surface: Colors.black,
    ),
  );
}
