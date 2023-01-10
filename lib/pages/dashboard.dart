// ignore_for_file: prefer_is_not_empty

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/bottomnav.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/Accounts.dart';
import 'package:shop_manager/pages/Inventory/inventory.dart';
import 'package:shop_manager/pages/widgets/barChart.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/drawerMenu.dart';

import 'addproduct.dart';
import 'category.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  Widget? _content;

  @override
  void initState() {
    var productBox = Hive.box<Product>('Product');
    var categoryBox = Hive.box<ProductCategory>('Category');
    HiveFunctions().reArrangeCategory();

    Provider.of<GeneralProvider>(context, listen: false).inventory =
        List.from(productBox.values);
    Provider.of<GeneralProvider>(context, listen: false).categories =
        List.from(categoryBox.values.toList());
    _content = const Dashboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => _backButton(),
      child: Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: theme.primaryColor,
          //   actions: [
          //     IconButton(
          //         onPressed: () {},
          //         icon: Icon(Icons.notifications_active,
          //             color: theme.primaryColorLight))
          //   ],
          // ),
          // drawer: const DrawerWidget(),
          bottomNavigationBar: BottomNav(onChange: _handleNavigationChange),
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
          _content = const AddProductScreen();
          break;
        case 2:
          _content = const Dashboard();
          break;
        case 3:
          _content = const Accounts();
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

  _backButton() {
    return showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text("Warning"),
              content: const Text("Do you really want to exit?"),
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
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> period = ['1D', '1W', '1M', '1Y'];
  int tap = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.primaryColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_active,
                    color: theme.primaryColorLight))
          ],
        ),
        drawer: const DrawerWidget(),
        backgroundColor: theme.primaryColorLight,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                    color: theme.primaryColor,
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
                padding: EdgeInsets.only(
                    top: height * 0.01,
                    right: width * 0.05,
                    left: width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        // height: height * 0.23,
                        child: Column(
                          children: [
                            Text('Total Earnings',
                                style: theme.textTheme.bodyText2),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'GHS 20945.90',
                              style: theme.textTheme.headline2!
                                  .copyWith(fontSize: 25),
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
                                              border: Border.all(
                                                  color: Colors.white),
                                              color: tap == index
                                                  ? Colors.white
                                                  : Colors.transparent,
                                            ),
                                            child: Text(
                                              period[index],
                                              textAlign: TextAlign.center,
                                              style: theme.textTheme.bodyText2!
                                                  .copyWith(
                                                      color: tap == index
                                                          ? theme.primaryColor
                                                          : Colors.white),
                                            ),
                                          ),
                                        ),
                                      )),
                            )
                          ],
                        )),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: height*0.04),
                          child:  const ShopBarChart(),
                        ),
                    Expanded(
                        // height: height * 0.53,
                        child: GridView.count(
                      padding: EdgeInsets.zero,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.7,
                      children: List.generate(statusList.length, (index) => 
                      ItemStatus(
                         status: statusList[index]['status'],
                          label: statusList[index]['label'],
                          icon: statusList[index]['icon'],
                          menuColor: theme.primaryColor,
                          iconColor: theme.primaryColorLight,
                        ),))),
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
  final Color menuColor, iconColor;
  final String label,status;
  final IconData icon;
  const ItemStatus({
    Key? key,
    this.onTap,
    required this.menuColor,
    required this.iconColor,
    required this.label,
    required this.icon, required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                style: theme.textTheme.headline1!
                    .copyWith(color: iconColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: Responsive.isMobile()?20:30, color: iconColor),
                   const SizedBox(
                width: 10,
              ),
                  Text(label, style: theme.textTheme.bodyText1!.copyWith(color:iconColor)),
                ],
              ),
            ],
          )),
    );
  }
}
