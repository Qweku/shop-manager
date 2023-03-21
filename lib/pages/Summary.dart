import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop_manager/components/button.dart';
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
  LocalStorage storage = LocalStorage('notification');

  @override
  Widget build(BuildContext context) {
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
                            Text('0001', style: bodyText1),
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

                          context.read<GeneralProvider>().inventory.forEach(
                            (element) {
                              Product productModel = Product(
                                  pid: element.pid,
                                  productCategory: element.productCategory,
                                  productDescription:
                                      element.productDescription,
                                  productName: element.productName,
                                  productImage: element.productName,
                                  productQuantity: element.productQuantity);
                              NotificationModel notiModel = NotificationModel(
                                  date: dateformat.format(DateTime.now()),
                                  time: timeformat.format(DateTime.now()),
                                  title: "Low Stock",
                                  body:
                                      ("${(element.productName)?.toCapitalized()} is running low. Prepare to re-stock"));
                              if (element.productQuantity <=
                                      element.lowStockQuantity &&
                                  !(Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .lowStocks
                                      .contains(element))) {
                                Provider.of<NotificationProvider>(context,
                                        listen: false)
                                    .addNotification(notiModel);

                                notify();
                                context.read<NotificationProvider>().notiCount =
                                    1;
                                Provider.of<GeneralProvider>(context,
                                        listen: false)
                                    .addLowStock(productModel);
                              } else {
                                return null;
                              }
                            },
                          );
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

  void notify() async {
    await notificationPlugin.showNotification(
        "Low Stock", "Some products are running low on stock");
    await storage.setItem(
        'notification',
        notificationModelToJson(
            Provider.of<NotificationProvider>(context, listen: false)
                .notiList));
  }
}
