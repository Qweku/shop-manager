import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/sales_receipt.dart';
import 'package:shop_manager/pages/sales_report.dart';
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
  var output = <SalesModel>[];
  bool isError = false;

//Filter sales date range
  List<SalesModel> itemsBetweenDates({
    required DateTime start,
    required DateTime end,
  }) {
    Provider.of<SalesProvider>(context, listen: false)
        .salesList
        .forEach((element) {
      DateFormat newDateFormat = DateFormat('y-MM-dd');
      var date = newDateFormat.parse(element.date ?? "", true);
      if (date.compareTo(start) >= 0 && date.compareTo(end) <= 0) {
        output.add(element);
      }
    });
    return output;
  }

  @override
  void initState() {
    log("Total Sales Items: " +
        Provider.of<SalesProvider>(context, listen: false)
            .salesList
            .length
            .toString());
    output = <SalesModel>[];
    if (Provider.of<SalesProvider>(context, listen: false)
        .salesList
        .isNotEmpty) {
      fromDate.text = Provider.of<SalesProvider>(context, listen: false).salesList.first.date!;
    }
    // fromDate.text =
    //     Provider.of<SalesProvider>(context, listen: false).salesList[0].date!;
    // log("First sales date: " +
    //     Provider.of<SalesProvider>(context, listen: false).salesList[0].date!);
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
                          output.clear();
                          fromDate.clear();
                          toDate.clear();
                          _searchAccount();
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
              child: context.watch<SalesProvider>().salesList.isEmpty
                  ? Center(
                      child: Text(
                        'No Records Yet',
                        style: headline1.copyWith(
                            fontSize: 25, color: Colors.blueGrey),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount:
                          context.watch<SalesProvider>().salesList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          SalesListSection(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalesReceipt(
                                      sales: context
                                          .watch<SalesProvider>()
                                          .salesList[index])));
                        },
                        width: width,
                        sales: context.watch<SalesProvider>().salesList[index],
                      ),
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

  _searchAccount() {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(20),
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: SizedBox(
                  height: height * 0.4,
                  width: width * 0.7,
                  child: Column(
                    // spacing: 20,
                    children: <Widget>[
                      SizedBox(height: height * 0.02),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: height * 0.02, top: height * 0.04),
                        child: Text("Generate Sales Report",
                            textAlign: TextAlign.center, style: headline1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.2,
                            child: Divider(color: primaryColor),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: height * 0.01),
                            child: Icon(Icons.receipt_long,
                                color: actionColor, size: 20),
                          ),
                          SizedBox(
                            width: width * 0.2,
                            child: Divider(color: primaryColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: height * 0.04,
                        ),
                        child: DateTextField(
                            controller: fromDate,
                            hintText: 'From',
                            borderColor: Color.fromARGB(255, 206, 206, 206),
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: Colors.grey, size: 20),
                            style: bodyText1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: height * 0.04,
                        ),
                        child: DateTextField(
                            controller: toDate,
                            hintText: 'To',
                            borderColor: Color.fromARGB(255, 206, 206, 206),
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: Colors.grey, size: 20),
                            style: bodyText1),
                      ),
                      isError
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "*Date range invalid",
                                style: bodyText1.copyWith(
                                    color: Color.fromARGB(255, 201, 26, 14)),
                              ))
                          : Container(),
                    ],
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: Button(
                      onTap: () async {
                        if (DateTime.parse(fromDate.text)
                                .isBefore(DateTime.parse(toDate.text)) ||
                            DateTime.parse(fromDate.text).isAtSameMomentAs(
                                DateTime.parse(fromDate.text))) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalesReport(
                                      fromDate: fromDate.text,
                                      toDate: toDate.text,
                                      salesList: itemsBetweenDates(
                                        start: DateTime.parse(fromDate.text),
                                        end: DateTime.parse(toDate.text),
                                      ))));
                        } else {
                          setState(() {
                            isError = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 17, 1),
                                content: Text('Date range invalid',
                                    textAlign: TextAlign.center,
                                    style: bodyText2),
                                duration: const Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                shape: const StadiumBorder()),
                          );
                        }
                      },
                      width: width * 0.4,
                      buttonText: 'Done',
                      color: primaryColor,
                    ),
                  )
                ],
              );
            }));
  }
}

class SalesListSection extends StatelessWidget {
  const SalesListSection({
    Key? key,
    required this.width,
    required this.sales,
    this.onTap,
  }) : super(key: key);

  final double width;
  final SalesModel sales;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
                    Text("Order Number: #${sales.accId}",
                        style: bodyText1.copyWith(color: primaryColorDark)),
                    Text("Date: ${sales.date}",
                        style: bodyText1.copyWith(color: primaryColorDark))
                  ],
                ),
              ),
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: sales.products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                      ),
                      child: SummaryListItem(
                        item: sales.products[index].productName!,
                        amount:
                            "${sales.products[index].sellingPrice.toStringAsFixed(2)}",
                        quantity: sales.products[index].cartQuantity.toString(),
                        date: sales.date!,
                      ),
                    );
                  }),
            ],
          ),
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
