// ignore_for_file: prefer_is_not_empty

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:shop_manager/components/bottomnav.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/localStore.dart';
import 'package:shop_manager/pages/sales.dart';
import 'package:shop_manager/pages/Inventory/inventory.dart';
import 'package:shop_manager/pages/low_stock_list.dart';
import 'package:shop_manager/pages/notifications/notifications.dart';
import 'package:shop_manager/pages/widgets/barChart.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/drawerMenu.dart';
import 'package:intl/intl.dart';

import 'addproduct.dart';
import 'Categories/category.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  Widget? _content;
  LocalStore localStore = LocalStore();
  DateFormat dateformat = DateFormat.yMMMd();
  DateFormat timeformat = DateFormat.Hm();
  int count = 0;
  @override
  void initState() {
    log("${Provider.of<SalesProvider>(context, listen: false).salesList.length}");
    // var productBox = Hive.box<Product>('Product');
    // var categoryBox = Hive.box<ProductCategory>('Category');
    // HiveFunctions().reArrangeCategory();
    // log('5');
    // context.read<GeneralProvider>().inventory.forEach(
    //   (element) {
    //     Product productModel = Product(
    //         pid: pid,
    //         productCategory: element.productCategory,
    //         productDescription: element.productDescription,
    //         productName: element.productName,
    //         productImage: element.productName,
    //         productQuantity: element.productQuantity);
    //     NotificationModel notiModel = NotificationModel(
    //         date: dateformat.format(DateTime.now()),
    //         time: timeformat.format(DateTime.now()),
    //         title: "Low Stock",
    //         body:
    //             ("${(element.productName)?.toCapitalized()} is running low. Prepare to re-stock"));
    //     if (element.productQuantity <= element.lowStockQuantity) {
    //       Provider.of<NotificationProvider>(context, listen: false)
    //           .addNotification(notiModel);
    //       notify();
    //       count = 1;
    //       Provider.of<GeneralProvider>(context, listen: false)
    //           .addLowStock(productModel);
    //     } else {
    //       return null;
    //     }
    //   },
    // );

    Provider.of<GeneralProvider>(context, listen: false).inventory =
        Provider.of<GeneralProvider>(context, listen: false).shop.products;
    Set<String> name = {};

    Provider.of<GeneralProvider>(context, listen: false).categories =
        Provider.of<GeneralProvider>(context, listen: false).inventory.map((e) {
      if (name.add(e.productCategory!.categoryName!)) {
        return e.productCategory!;
      } else {
        return ProductCategory(
          cid: -1,
        );
      }
    }).toList()
          ..removeWhere((element) => element.cid == -1);

    log('CATEGORIES: ');
    log(Provider.of<GeneralProvider>(context, listen: false)
        .categories
        .length
        .toString());

    if (Provider.of<GeneralProvider>(context, listen: false)
        .categories
        .isEmpty) {
      Provider.of<GeneralProvider>(context, listen: false).categories.add(
          ProductCategory(
              cid: 0,
              categoryName: "Uncategorised",
              categoryDescription: 'No Description'));
    }

    _content = const Dashboard();
    super.initState();
  }

  // void notify() async {
  //   await notificationPlugin.showNotification(
  //       "Low Stock", "Some products are running low on stock");
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backButton(context),
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
          _content = const CategoryScreen();
          break;
        case 1:
          _content = const LowStockList();
          break;
        case 2:
          _content = const Dashboard();
          break;
        case 3:
          _content = const SalesScreen();
          break;
        case 4:
          _content = const InventoryScreen();
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

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> period = ['1D', '1W', '1M', '1Y'];
  int tap = 0;
  double totalSales = 0.0;
  double totalProfit = 0.0;
  @override
  Widget build(BuildContext context) {
    totalSales = 0.0;
    totalProfit = 0.0;
    context.watch<SalesProvider>().salesList.forEach((element) {
      element.products.forEach((item) {
        totalSales += item.sellingPrice * item.cartQuantity;
        totalProfit += (item.sellingPrice - item.costPrice) * item.cartQuantity;
      });
    });
List<Map<String, dynamic>> statusList = [
  {'status': 'GHS ${totalSales.toStringAsFixed(2)}', 'label': 'Total Sales', 'icon': Icons.monetization_on},
  {'status': 'GHS 1.2K', 'label': 'Total Expenses', 'icon': Icons.auto_graph},
  {'status': '${context.watch<GeneralProvider>().lowStocks.length}', 'label': 'Low Stock', 'icon': Icons.arrow_circle_down},
  {'status': '${context.watch<GeneralProvider>().inventory.length}', 'label': 'Total Stock', 'icon': Icons.inventory},
];
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => AddProductScreen()));
          },
          backgroundColor: primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          actions: [
            NotificationIconButton(
              quantity: context.watch<NotificationProvider>().notiCount,
              onTap: () {
                if (context.read<NotificationProvider>().notiCount > 0) {
                  context.read<NotificationProvider>().notiCount = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                }
              },
            )
          ],
        ),
        drawer: const DrawerWidget(),
        backgroundColor: primaryColorLight,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
              ),
            ),
            Container(
              height: height,
              width: width,
              color: Colors.transparent,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.05, left: width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Column(
                      children: [
                        Text('Total Earnings', style: bodyText2),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'GHS ${totalProfit.toStringAsFixed(2)}',
                          style: headline2.copyWith(fontSize: 25),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              period.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tap = index;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: width * 0.15,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          color: tap == index
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        child: Text(
                                          period[index],
                                          textAlign: TextAlign.center,
                                          style: bodyText2.copyWith(
                                              color: tap == index
                                                  ? primaryColor
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  )),
                        )
                      ],
                    )),
                    const ShopBarChart(),
                    GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.7,
                        children: List.generate(
                          statusList.length,
                          (index) => ItemStatus(
                            status: statusList[index]['status'],
                            label: statusList[index]['label'],
                            icon: statusList[index]['icon'],
                            menuColor: Color.fromARGB(255, 247, 247, 247),
                            iconColor: actionColor,
                            textColor: primaryColorDark,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ItemStatus extends StatelessWidget {
  final Function()? onTap;
  final Color menuColor, iconColor, textColor;
  final String label, status;
  final IconData icon;
  const ItemStatus({
    Key? key,
    this.onTap,
    required this.menuColor,
    required this.iconColor,
    required this.label,
    required this.icon,
    required this.status,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: menuColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                status,
                style: headline1.copyWith(color: textColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon,
                      size: Responsive.isMobile() ? 20 : 30, color: iconColor),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(label, style: bodyText1.copyWith(color: textColor)),
                ],
              ),
            ],
          )),
    );
  }
}
