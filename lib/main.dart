import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/pages/Auth/onboarding.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_manager/theme.dart';
import 'package:provider/provider.dart';

import 'models/GeneralProvider.dart';

main() async {
  await Hive.initFlutter();
Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GeneralProvider()),
    ChangeNotifierProvider(create: (_) => ApplicationState()),
  ], child: const MyApp()));
}
final navigatorKey = GlobalKey<NavigatorState>();
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
      navigatorKey: navigatorKey,
        title: 'Shop Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF0D47A1),
          primaryColorLight: Colors.white,
          primaryColorDark: const Color.fromARGB(255, 7, 7, 7),
          fontFamily: "Montserrat",
          textTheme: const TextTheme(
              headline1:
                  TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
              headline2: TextStyle(fontSize: 20, color: Colors.white),
              bodyText1:
                  TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
              bodyText2: TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 255, 255, 255))),
          primarySwatch: Colors.blue,
        ),
        home: const OnboardingScreen()
        //LoginScreen(),
        );
  }
}
