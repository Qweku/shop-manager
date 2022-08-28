// ignore_for_file: prefer_is_not_empty

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/bottomnav.dart';
import 'package:shop_manager/config/colors.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/Accounts.dart';
import 'package:shop_manager/pages/Inventory/inventory.dart';
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
          bottomNavigationBar: BottomNav(onChange: _handleNavigationChange),
          body: _content),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _content = Container();
          break;
        case 1:
          _content = const Dashboard();
          break;
        case 2:
          _content = const Accounts(tag: 'dashboard');
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
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: ShopColors.primaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: height * 0.45,
                decoration: BoxDecoration(
                    color: ShopColors.secondaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(width * 0.5),
                    )),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: height * 0.2,
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.primaryColorLight,
                              radius: width * 0.12,
                              child: Icon(Icons.shop_2,
                                  color: theme.primaryColor, size: 35),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 10),
                              child: Text("Shop Manager",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ShopColors.primaryColor)),
                            ),
                          ],
                        )),
                    SizedBox(
                        height: height * 0.53,
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: [
                            GridMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryScreen()));
                              },
                              label: "Categories",
                              icon: Icons.category,
                              menuColor: theme.primaryColorLight,
                              iconColor: theme.primaryColor,
                            ),
                            GridMenuItem(
                              onTap: () {
                                // if (!(Provider.of<GeneralProvider>(context,
                                //         listen: false)
                                //     .categories
                                //     .isEmpty)) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddProductScreen()));
                                // }
                              },
                              label: "Add Product",
                              icon: Icons.shopping_bag,
                              menuColor: theme.primaryColorLight,
                              iconColor: theme.primaryColor,
                            ),
                            GridMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Accounts()));
                              },
                              label: "Account History",
                              icon: Icons.receipt_long,
                              menuColor: theme.primaryColor,
                              iconColor: theme.primaryColorLight,
                            ),
                            GridMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InventoryScreen()));
                              },
                              label: "Inventory",
                              icon: Icons.inventory,
                              menuColor: theme.primaryColor,
                              iconColor: theme.primaryColorLight,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class GridMenuItem extends StatelessWidget {
  final Function()? onTap;
  final Color menuColor, iconColor;
  final String label;
  final IconData icon;
  const GridMenuItem({
    Key? key,
    this.onTap,
    required this.menuColor,
    required this.iconColor,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: menuColor,
              border: Border.all(color: iconColor, width: 2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: iconColor),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(label,
                    style: TextStyle(fontSize: 20, color: iconColor)),
              ),
            ],
          )),
    );
  }
}
