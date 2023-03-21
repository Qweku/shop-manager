import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/custom_indicator.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/AccountProvider.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class Accounts extends StatefulWidget {
  final String? tag;
  const Accounts({Key? key, this.tag}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
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
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
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
                        icon: const Icon(Icons.search,
                            size: 40, color: Colors.white),
                        onPressed: () {
                          _searchAccount(context);
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: -height * 0.05,
                    right: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
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
                                  "GHS 3.5K",
                                  style: headline1.copyWith(
                                      color: primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
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
                                  "GHS 1.5K",
                                  style: headline1.copyWith(
                                      color: primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
            SizedBox(height: height * 0.08),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: SizedBox(
                  // color: Colors.white,
                  height: height * 0.7,
                  width: width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Color.fromARGB(255, 226, 226, 226),
                            //     offset: Offset(0, 2),
                            //     blurRadius: 3,
                            //     spreadRadius: 0,
                            //   )
                            // ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: TabBar(
                              indicator: CustomTabIndicator(),
                              isScrollable: false,
                              labelColor: primaryColorDark,
                              labelStyle: bodyText2,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: primaryColor,
                              onTap: (index) {},
                              tabs: [
                                Tab(
                                  text: 'General Sales',
                                ),
                                Tab(
                                  text: 'Credit Sales',
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Container(),Container(),
                              SalesListSection(width: width),
                              SalesListSection(width: width),
                            ],
                          ),
                        ),
                        //SizedBox(height: height * 0.03),
                      ]),
                ),
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
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: context.watch<SalesProvider>().salesList.length,
        itemBuilder: (context, index) {
          return context.watch<SalesProvider>().salesList.isEmpty
              ? Center(
                  child: Text(
                    'No Records Yet',
                    style: headline1.copyWith(
                        fontSize: 25, color: Colors.blueGrey),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                  ),
                  child: SummaryListItem(
                    item: context
                            .read<SalesProvider>()
                            .salesList[index]
                            .products[index]
                            .productName ??
                        "",
                    amount:
                        "${context.read<SalesProvider>().salesList[index].products[index].sellingPrice}",
                    quantity:
                        "${context.read<SalesProvider>().salesList[index].products[index].cartQuantity}",
                    date: context.read<SalesProvider>().salesList[index].date ??
                        "",
                  ),
                );
        });
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
              "I",
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
