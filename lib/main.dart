import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/pages/notifications/notifications.dart';

import 'package:provider/provider.dart';
import 'package:shop_manager/pages/wrapper.dart';

import 'models/AuthService.dart';
import 'models/GeneralProvider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();



main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final double screenWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
  if (screenWidth >= 800) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  } else {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
  await Firebase.initializeApp();

  

  NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = Wrapper.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    initialRoute = NotificationScreen.routeName;
  }

  Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationState()),
      ],
      child: MyApp(
        initialRoute: initialRoute,
      )));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final String? initialRoute;
  const MyApp({Key? key, this.initialRoute}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Shop Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 13, 71, 161),
        primaryColorLight: Colors.white,
        primaryColorDark: const Color.fromARGB(255, 22, 22, 22),
        fontFamily: "Montserrat",
        primarySwatch: Colors.blue,
      ),
      initialRoute: widget.initialRoute,
      routes: <String, WidgetBuilder>{
        Wrapper.routeName: (_) => Wrapper(),
        NotificationScreen.routeName: (_) => NotificationScreen()
      },
      //LoginScreen(),
    );
  }
}
