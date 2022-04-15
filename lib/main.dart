import 'package:flutter/material.dart';
import 'package:shop_manager/theme.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/pages/login.dart';

import 'models/GeneralProvider.dart';

void main() {
  runApp(ChangeNotifierProvider<GeneralProvider>(
      create: (context) => GeneralProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    activeTheme.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
       primaryColorLight: Colors.white,
       primaryColorDark: const Color.fromARGB(255, 7, 7, 7),
       fontFamily: "Montserrat",
       textTheme: const TextTheme(
         headline1:  TextStyle(fontSize:20,color: Color.fromARGB(255, 0, 0, 0)),
         headline2: TextStyle(fontSize:20,color: Colors.white),
         bodyText1: TextStyle(fontSize: 14,color:Color.fromARGB(255, 0, 0, 0)),
         bodyText2: TextStyle(fontSize: 14,color:Color.fromARGB(255, 255, 255, 255))
       ),
        primarySwatch: Colors.green,
      ),
      home: const LoginScreen(),
    );
  }
}
