import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/config/notificationService.dart';
import 'package:shop_manager/models/AccountProvider.dart';

import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/addProductSuccess.dart';
import 'package:shop_manager/pages/notifications/notificationPlugin.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/productCalculatorWidget.dart';

import '../models/NotificationModel.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
NotificationService _notificationService = NotificationService();

class SummaryScreen extends StatefulWidget {
  final double amountReceived, change, totalCost;
  const SummaryScreen(
      {Key? key,
      required this.amountReceived,
      required this.change,
      required this.totalCost})
      : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool isCredit = false;
  LocalStorage storage = LocalStorage('shop_mate');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? shopName;

  @override
  Widget build(BuildContext context) {
    shopName = auth.currentUser!.displayName;
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            ClipPath(
              clipper: BottomClipper(),
              child: Container(
                padding: EdgeInsets.only(
                    right: height * 0.02,
                    left: height * 0.02,
                    top: height * 0.13,
                    bottom: height * 0.07),
                color: primaryColor,
                child: HeaderSection(
                  title: 'Summary',
                  height: height,
                  width: width,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        "Your order summary!",
                        style: headline1,
                      ),
                      SizedBox(height: height * 0.03),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #: ',
                                style: bodyText1.copyWith(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '000' +
                                    "${context.read<SalesProvider>().salesList.length + 1}",
                                style: bodyText1),
                          ]),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status: ',
                                style: bodyText1.copyWith(
                                    fontWeight: FontWeight.bold)),
                            Text('Paid', style: bodyText1),
                          ]),
                      Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date: ',
                                style: bodyText1.copyWith(
                                    fontWeight: FontWeight.bold)),
                            Text(
                              dateformat.format(DateTime.now()),
                              style: bodyText1,
                            ),
                          ]),
                      SizedBox(height: height * 0.03),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount:
                              context.watch<GeneralProvider>().cart.length,
                          itemBuilder: (context, index) {
                            return ItemDetail(
                                backgroundColor:
                                    const Color.fromARGB(255, 233, 233, 233),
                                textColor:
                                    const Color.fromARGB(255, 26, 26, 26),
                                item: Provider.of<GeneralProvider>(context,
                                        listen: false)
                                    .cart[index]);
                          }),
                      SizedBox(height: height * 0.03),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: headline1,
                          ),
                          Text(
                            "GHS ${widget.totalCost.toStringAsFixed(2)} ",
                            style: headline1,
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Received',
                            style: bodyText1.copyWith(fontSize: 15),
                          ),
                          Text(
                            "GHS ${widget.amountReceived.toStringAsFixed(2)}",
                            style: bodyText1.copyWith(fontSize: 15),
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change',
                            style: headline1,
                          ),
                          Text(
                            "GHS ${widget.change.toStringAsFixed(2)}",
                            style: headline1,
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                      Button(
                        onTap: () async {
                          //!
                          context.read<GeneralProvider>().processCart();
                          SalesModel salesModel = SalesModel(
                            products:
                                List.from(context.read<GeneralProvider>().cart),
                            accId:
                                context.read<SalesProvider>().salesList.length +
                                    1,
                            date: salesDateFormat.format(DateTime.now()),
                          );

                          Provider.of<SalesProvider>(context, listen: false)
                              .addSales(salesModel);

                          Provider.of<GeneralProvider>(context, listen: false)
                                  .shop
                                  .sales =
                              Provider.of<SalesProvider>(context, listen: false)
                                  .salesList;

                          await storage.setItem(
                              shopName!,
                              shopProductsToJson(Provider.of<GeneralProvider>(
                                      context,
                                      listen: false)
                                  .shop));

                          

                          // _notificationService.showNotifications();

                          //context.read<GeneralProvider>().cart.clear();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddProductSuccess(
                                        tag: 'order',
                                      )));
                        },
                        buttonText: 'Done',
                        color: primaryColor,
                        width: width * 0.8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void notify(Product productModel) async {
    await storage.setItem(
        'notification',
        notificationModelToJson(
            Provider.of<NotificationProvider>(context, listen: false)
                .notiList));
    Provider.of<GeneralProvider>(context, listen: false)
        .addLowStock(productModel);
    Provider.of<GeneralProvider>(context, listen: false).shop.lowStocks =
        Provider.of<GeneralProvider>(context, listen: false).lowStocks;
    await storage.setItem(
        'lowStocks',
        shopProductsToJson(
            Provider.of<GeneralProvider>(context, listen: false).shop));
    // await notificationPlugin.showNotification(
    //   "Low Stock", "Some products are running low on stock");
    // _notificationService.showNotifications();
    // NotiPlugin.showNotification(
    //     title: "Low Stock",
    //     body: "Some products are running low on stock",
    //     fln: flutterLocalNotificationsPlugin);
    //  flutterLocalNotificationsPlugin.show(
    //   0,
    //   "Low Stock",
    //   "Some products are running low on stock",
    //   NotificationDetails(
    //       android: AndroidNotificationDetails(
    //           channel.id, channel.name,
    //           importance: Importance.high,
    //           color: primaryColor,
    //           playSound: true,
    //           icon: '@mipmap/ic_launcher')));
  }
}
