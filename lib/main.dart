
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_manager/components/responsive.dart';
// import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/Auth/Launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_manager/theme.dart';
import 'package:provider/provider.dart';

import 'models/GeneralProvider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  if (screenWidth >= 800) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductCategoryAdapter());
  await Hive.openBox<Product>('Product');
  await Hive.openBox<ProductCategory>('Category');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GeneralProvider()),
    // ChangeNotifierProvider(create: (_) => ApplicationState()),
  ], 
  child: const MyApp()));
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
        title: 'ShopMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 13, 71, 161),
          primaryColorLight: Colors.white,
          primaryColorDark: const Color.fromARGB(255, 14, 14, 14),
          fontFamily: "Montserrat",
          textTheme:  TextTheme(
              headline1:
                  TextStyle(fontSize: Responsive.isMobile()?20:25, color: const Color.fromARGB(255, 0, 0, 0)),
              headline2: TextStyle(fontSize: Responsive.isMobile()?20:25, color: Colors.white),
              bodyText1:
                  TextStyle(fontSize: Responsive.isMobile()?12:18, color: const Color.fromARGB(255, 0, 0, 0)),
              bodyText2: TextStyle(
                  fontSize: Responsive.isMobile()?12:18, color: const Color.fromARGB(255, 255, 255, 255))),
          primarySwatch: Colors.blue,
        ),
        home: const Launcher()
        //LoginScreen(),
        );
  }
}
