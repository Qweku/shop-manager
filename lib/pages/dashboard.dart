// ignore_for_file: prefer_is_not_empty

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/bottomnav.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/localStore.dart';
import 'package:shop_manager/pages/expenses.dart';
import 'package:shop_manager/pages/sales.dart';
import 'package:shop_manager/pages/Inventory/inventory.dart';
import 'package:shop_manager/pages/low_stock_list.dart';
import 'package:shop_manager/pages/notifications/notifications.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/dashboard_card.dart';
import 'package:shop_manager/pages/widgets/drawerMenu.dart';

import '../models/NotificationModel.dart';
import 'addproduct.dart';
// import 'Categories/category.dart';


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
  double totalExpenses = 0.0;
  LocalStorage storage = LocalStorage('shop_mate');
  @override
  void initState() {
    Provider.of<GeneralProvider>(context, listen: false).inventory =
        Provider.of<GeneralProvider>(context, listen: false).shop.products;
    Provider.of<SalesProvider>(context, listen: false).expenseList =
        Provider.of<GeneralProvider>(context, listen: false).shop.expenses;
    Provider.of<GeneralProvider>(context, listen: false).lowStocks =
        Provider.of<GeneralProvider>(context, listen: false).shop.lowStocks;
    Provider.of<SalesProvider>(context, listen: false).salesList =
        Provider.of<GeneralProvider>(context, listen: false).shop.sales;
    Provider.of<NotificationProvider>(context, listen: false).notiList =
        notificationModelFromJson(storage.getItem('notification') ?? '[]');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalSales = 0.0;
    totalProfit = 0.0;
    totalExpenses = 0.0;
    context.watch<SalesProvider>().salesList.forEach((element) {
      element.products.forEach((item) {
        totalSales += item.sellingPrice * item.cartQuantity;
        totalProfit += (item.sellingPrice - item.costPrice) * item.cartQuantity;
      });
    });

    context.watch<SalesProvider>().expenseList.forEach((element) {
      totalExpenses += element.price;
    });
    List<Map<String, dynamic>> statusList = [
      {
        'status': 'GHS ${totalSales.toStringAsFixed(2)}',
        'label': 'Total Sales',
        'icon': Icons.monetization_on
      },
      {
        'status': 'GHS ${totalExpenses.toStringAsFixed(2)}',
        'label': 'Total Expenses',
        'icon': Icons.auto_graph
      },
      {
        'status': '${context.watch<GeneralProvider>().lowStocks.length}',
        'label': 'Low Stock',
        'icon': Icons.arrow_circle_down
      },
      {
        'status': '${context.watch<GeneralProvider>().inventory.length}',
        'label': 'Total Stock',
        'icon': Icons.inventory
      },
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
              quantity: context.watch<NotificationProvider>().notiList.where((element) => element.isRead == false).length,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome,', style: headline2),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Admin',
                          style: headline2.copyWith(
                              fontSize: 40, color: actionColor),
                        ),
                      ],
                    )),
                    DashboardCard(totalProfit: totalProfit),
                    //const ShopBarChart(),
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
