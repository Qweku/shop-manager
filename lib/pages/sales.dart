import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/custom_indicator.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SalesScreen extends StatefulWidget {
  final String? tag;
  const SalesScreen({Key? key, this.tag}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
  double totalSales = 0.0;
  double totalProfit = 0.0;
  @override
  void initState() {
    log("Total Sales Items: " +
        Provider.of<SalesProvider>(context, listen: false)
            .salesList
            .length
            .toString());
    Provider.of<SalesProvider>(context, listen: false).salesList;
    super.initState();
  }

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
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    padding: EdgeInsets.only(
                        right: height * 0.02,
                        left: height * 0.02,
                        top: height * 0.1,
                        bottom: height * 0.13),
                    color: primaryColor,
                    child: HeaderSection(
                      title: 'Shop Sales',
                      height: height,
                      width: width,
                      trailing: IconButton(
                        icon: const Icon(Icons.filter_list,
                            size: 30, color: Colors.white),
                        onPressed: () {
                          _searchAccount(context);
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: -height * 0.03,
                    right: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: height * 0.12,
                          width: width * 0.45,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.money,
                                      size: Responsive.isMobile() ? 20 : 30,
                                      color: actionColor),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Total Sales",
                                      style: bodyText1.copyWith(
                                          color: primaryColorDark)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "GHS ${totalSales.toStringAsFixed(2)}",
                                    style: headline1.copyWith(
                                        color: primaryColorDark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.12,
                          width: width * 0.45,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_circle_up,
                                      size: Responsive.isMobile() ? 20 : 30,
                                      color: actionColor),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Total Profit",
                                      style: bodyText1.copyWith(
                                          color: primaryColorDark)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "GHS ${totalProfit.toStringAsFixed(2)}",
                                    style: headline1.copyWith(
                                        color: primaryColorDark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
            SizedBox(height: height * 0.07),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Sales History", style: headline1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                  width: width * 0.1,
                  child: Divider(
                    color: actionColor,
                    thickness: 5,
                  )),
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: /* context.watch<SalesProvider>().salesList.length */
                    5,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    SalesListSection(width: width),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchAccount(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: height * 0.7,
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: height * 0.02, top: height * 0.04),
                  child: Text("Search Account History", style: headline2),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.04,
                  ),
                  child: DateTextField(
                      controller: fromDate,
                      hintText: 'From',
                      hintColor: Colors.white,
                      borderColor: Colors.white,
                      prefixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white, size: 20),
                      style: bodyText2),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.04,
                  ),
                  child: DateTextField(
                      controller: toDate,
                      hintText: 'To',
                      hintColor: Colors.white,
                      borderColor: Colors.white,
                      prefixIcon: const Icon(Icons.calendar_today,
                          color: Colors.white, size: 20),
                      style: bodyText2),
                ),
                SizedBox(height: height * 0.1),
                Button(
                  color: primaryColorLight,
                  textColor: primaryColor,
                  width: width,
                  buttonText: "Done",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: height * 0.4),
              ],
            ),
          );
        });
  }
}

class SalesListSection extends StatelessWidget {
  const SalesListSection({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 247, 247),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Number: #001",
                      style: bodyText1.copyWith(color: primaryColorDark)),
                  Text("Date: 21/03/2023",
                      style: bodyText1.copyWith(color: primaryColorDark))
                ],
              ),
            ),
            ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                    ),
                    child: SummaryListItem(
                      item: "Ideal Milk",
                      amount: "10.00",
                      quantity: "2",
                      date: "21/03/2023",
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class SummaryListItem extends StatelessWidget {
  final String item, amount, date, quantity;

  const SummaryListItem({
    Key? key,
    required this.item,
    required this.amount,
    required this.date,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 17,
            child: Text(
              item.substring(0, 1),
              style: bodyText2,
            ),
          ),
          title: Text(
            item.toTitleCase(),
            style: bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(date, style: bodyText1),
          trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("GHS $amount", style: bodyText1),
                const SizedBox(height: 5),
                Text("x$quantity", style: bodyText1)
              ]),
        ));
  }
}
