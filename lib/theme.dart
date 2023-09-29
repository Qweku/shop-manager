import 'package:flutter/material.dart';

// ThemeData appTheme() {
//   TextTheme _baseTextTheme(TextTheme base) {
//     return base.copyWith(
//         headline1: base.headline1.copyWith(
//             fontFamily: 'Monserrat', fontSize: 30, color: Colors.black));
//   }

//   final ThemeData base = ThemeData.light();
//   return base.copyWith(
//       textTheme: _baseTextTheme(base.textTheme),
//       primaryColor: Colors.orange,
//       iconTheme: IconThemeData(color: Colors.orange, size: 20));
// }

CustomTheme activeTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get activeTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        primaryColorLight: Colors.white,
        textTheme: const TextTheme(          
          displayLarge: TextStyle(color: Colors.black, fontSize: 42,fontFamily: "Louis_George_Cafe",),
          displayMedium: TextStyle(color: Colors.white, fontSize: 42,fontFamily: "Louis_George_Cafe",),
          displaySmall: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Louis_George_Cafe",),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 20,fontFamily: "Louis_George_Cafe",),
          bodyLarge: TextStyle(color: Colors.black, fontSize: 17,fontFamily: "Louis_George_Cafe",),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "Louis_George_Cafe",),
          labelLarge: TextStyle(color:Colors.white,fontSize:15)
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0D47A1)));
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}
