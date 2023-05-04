import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/bottomnav.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationModel.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/localStore.dart';
import 'package:shop_manager/pages/Inventory/inventory.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/expenses.dart';
import 'package:shop_manager/pages/low_stock_list.dart';
import 'package:shop_manager/pages/notifications/notificationPlugin.dart';
import 'package:shop_manager/pages/sales.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  Widget? _content;
  LocalStore localStore = LocalStore();
  LocalStorage storage = LocalStorage('shop_mate');

  FirebaseAuth auth = FirebaseAuth.instance;
  int count = 0;
  String? shopName;

  Future getShopProducts() async {
    shopName = auth.currentUser!.displayName;
    var data = await storage.getItem(shopName!.isEmpty ? 'demo' : shopName!);

    if (data == null) {
      log('empty');
      Provider.of<GeneralProvider>(context, listen: false).shop = ShopProducts(
          id: 0,
          shopname: 'demo',
          products: [],
          sales: [],
          expenses: [],
          lowStocks: []);
    } else {
      log('not empty');
      Provider.of<GeneralProvider>(context, listen: false).shop =
          shopProductsFromJson(data);
    }
  }

  void bootUp() async {
    shopName = auth.currentUser!.displayName;
    if (await storage.ready) {
      Provider.of<NotificationProvider>(context, listen: false).notiList =
          notificationModelFromJson(storage.getItem('notification') ?? '[]');
      Provider.of<GeneralProvider>(context, listen: false).shop =
          shopProductsFromJson(storage.getItem(shopName!) ?? '[]');
    }
  }

  @override
  void initState() {
    bootUp();
    NotiPlugin.initialize(flutterLocalNotificationsPlugin);

    // log("${Provider.of<SalesProvider>(context, listen: false).salesList.length}");
    // log("${Provider.of<GeneralProvider>(context, listen: false).shop.shopname}");

    Set<String> name = {};

    // Provider.of<GeneralProvider>(context, listen: false).categories =
    //     Provider.of<GeneralProvider>(context, listen: false).inventory.map((e) {
    //   if (name.add(e.productCategory!.categoryName!)) {
    //     return e.productCategory!;
    //   } else {
    //     return ProductCategory(
    //       cid: -1,
    //     );
    //   }
    // }).toList()
    //       ..removeWhere((element) => element.cid == -1);

    // if (Provider.of<GeneralProvider>(context, listen: false)
    //     .categories
    //     .isEmpty) {
    //   Provider.of<GeneralProvider>(context, listen: false).categories.add(
    //       ProductCategory(
    //           cid: 0,
    //           categoryName: "Uncategorised",
    //           categoryDescription: 'No Description'));
    // }

    delayScreen();
    super.initState();
  }

  void delayScreen() async {
    await Future.delayed(const Duration(milliseconds: 300), () {
      _content = const Dashboard();
      setState(() {});
    });
  }

  // void notify() async {
  //   await notificationPlugin.showNotification(
  //       "Low Stock", "Some products are running low on stock");
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _backButton(context),
      child: Scaffold(
          backgroundColor: primaryColorLight,
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: primaryColor,
          //   actions: [
          //     IconButton(
          //         onPressed: () {},
          //         icon: Icon(Icons.notifications_active,
          //             color: primaryColorLight))
          //   ],
          // ),
          // drawer: const DrawerWidget(),
          bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Color.fromARGB(255, 247, 247, 247)))),
              child: BottomNav(onChange: _handleNavigationChange)),
          body: _content),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _content = const InventoryScreen();
          break;
        case 1:
          _content = const SalesScreen();
          break;
        case 2:
          _content = const Dashboard();
          break;
        case 3:
          _content = const LowStockList();
          break;
        case 4:
          _content = const ExpenseScreen();
          break;
      }
      _content = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        child: _content,
      );
    });
  }

  _backButton(context) {
    return showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: height * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_outlined,
                        size: 40, color: Color.fromARGB(255, 255, 38, 23)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Do you really want to exit?",
                      style: bodyText1,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        exit(0);
                      }
                      if (Platform.isAndroid) {
                        return await SystemChannels.platform
                            .invokeMethod<void>('SystemNavigator.pop');
                      }
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text("No"))
              ],
            ));
  }
}
