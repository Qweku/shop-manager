// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';

import 'package:shop_manager/pages/Inventory/InventoryList.dart';
import 'package:shop_manager/pages/Inventory/InventorySearchList.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/productCalculator.dart';

import 'package:shop_manager/pages/widgets/constants.dart';

import '../widgets/clipPath.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String query = "";
  bool isList = false;
  bool isScrolled = false;
  bool boxScroll = false;

  final ScrollController _scrollController = ScrollController();

 
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => AddProductScreen()));
          },
          backgroundColor: primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Responsive.isMobile()
                  ? ClipPath(
                      clipper: BottomClipper(),
                      child: Container(
                        width: width,
                        padding: EdgeInsets.only(
                            right: height * 0.02,
                            left: height * 0.02,
                            top: height * 0.05,
                            bottom: height * 0.07),
                        color: primaryColor,
                        child: HeaderSection(
                          height: height,
                          width: width,
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Inventory",
                            textAlign: TextAlign.left,
                            style: headline1.copyWith(fontSize: 20),
                          ),
                          SizedBox(
                            width: width * 0.4,
                            child: CustomTextField(
                              borderColor: Colors.grey,
                              style: bodyText1,
                              suffixIcon: GestureDetector(
                                  child: const Icon(Icons.search,
                                      color: Colors.grey)),
                              hintText: "Search for product",
                              hintColor: Colors.grey,
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [],
                          )
                        ],
                      ),
                    ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: AnimatedSwitcher(
                    duration: Duration(microseconds: 100),
                    child: (query.isEmpty)
                        ? InventoryList(
                            isList: isList,
                          )
                        : InventorySearchList(query: query, isList: isList)),
              ),
            ],
          ),
        ));
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.height,
    //required this.widget,

    required this.width,
    this.onChanged,
  }) : super(key: key);

  final double height;
  //final ProductListScreen widget;

  final double width;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Inventory",
                  textAlign: TextAlign.left,
                  style: headline2.copyWith(fontSize: 30),
                ),
                SizedBox(
                    width: width * 0.1,
                    child: Divider(
                      color: primaryColorLight,
                      thickness: 5,
                    )),
              ],
            ),
            CartIconButton(
                color: Colors.white,
                quantity: context.watch<GeneralProvider>().cart.length,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ProductCalculator()));
                })
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: 20),
          child: CustomTextField(
            borderColor: const Color.fromARGB(255, 255, 255, 255),
            style: bodyText2,
            suffixIcon: GestureDetector(
                child: const Icon(Icons.search, color: Colors.white)),
            hintText: "Search for product",
            hintColor: Colors.white,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
