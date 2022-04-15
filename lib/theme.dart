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
        primaryColor: Color(0xFF0D47A1),
        primaryColorLight: Colors.white,
        textTheme: TextTheme(          
          headline1: TextStyle(color: Colors.black, fontSize: 42,fontFamily: "Louis_George_Cafe",),
          headline2: TextStyle(color: Colors.white, fontSize: 42,fontFamily: "Louis_George_Cafe",),
          headline3: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Louis_George_Cafe",),
          headline4: TextStyle(color: Colors.white, fontSize: 20,fontFamily: "Louis_George_Cafe",),
          bodyText1: TextStyle(color: Colors.black, fontSize: 17,fontFamily: "Louis_George_Cafe",),
          bodyText2: TextStyle(color: Colors.white, fontSize: 17,fontFamily: "Louis_George_Cafe",),
          button: TextStyle(color:Colors.white,fontSize:15)
        ),
        iconTheme: IconThemeData(color: Color(0xFF0D47A1)));
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}
