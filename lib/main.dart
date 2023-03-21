import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/pages/Auth/Launcher.dart';
import 'package:shop_manager/pages/notifications/notificationPlugin.dart';
import 'package:shop_manager/pages/notifications/notifications.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_manager/theme.dart';
import 'package:provider/provider.dart';

import 'models/AuthService.dart';
import 'models/GeneralProvider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  if (screenWidth >= 800) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  } else {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

   NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = Launcher.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    initialRoute = NotificationScreen.routeName;
  }

  // await Hive.initFlutter();
  // Hive.registerAdapter(ProductAdapter());
  // Hive.registerAdapter(ProductCategoryAdapter());
  // await Hive.openBox<Product>('Product');
  // await Hive.openBox<ProductCategory>('Category');
  Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider<AuthService>(create: (_)=>AuthService(),),
    ChangeNotifierProvider(create: (_) => GeneralProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => SalesProvider()),
    ChangeNotifierProvider(create: (_) => ApplicationState()),
  ], child:  MyApp(initialRoute: initialRoute,)));
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
      title: 'Shop Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 13, 71, 161),
        primaryColorLight: Colors.white,
        primaryColorDark: const Color.fromARGB(255, 22, 22, 22),
        fontFamily: "Montserrat",
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: Responsive.isMobile() ? 20 : 25,
                color: const Color.fromARGB(255, 22, 22, 22)),
            headline2: TextStyle(
                fontSize: Responsive.isMobile() ? 20 : 25, color: Colors.white),
            bodyText1: TextStyle(
                fontSize: Responsive.isMobile() ? 12 : 18,
                color: const Color.fromARGB(255, 22, 22, 22)),
            bodyText2: TextStyle(
                fontSize: Responsive.isMobile() ? 12 : 18,
                color: const Color.fromARGB(255, 255, 255, 255))),
        primarySwatch: Colors.blue,
      ),
      initialRoute: widget.initialRoute,
      routes: <String, WidgetBuilder>{
        Launcher.routeName: (_) => Launcher(),
        NotificationScreen.routeName: (_) =>
            NotificationScreen()
      },
      //LoginScreen(),
    );
  }
}
