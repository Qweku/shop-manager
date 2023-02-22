// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/notificationButton.dart';
import 'package:shop_manager/components/textFields.dart';
import 'package:shop_manager/models/GeneralProvider.dart';

import 'package:shop_manager/pages/Inventory/InventoryList.dart';
import 'package:shop_manager/pages/Inventory/InventorySearchList.dart';
import 'package:shop_manager/pages/productCalculator.dart';

import 'package:shop_manager/pages/search.dart';

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

    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.primaryColor,
          onPressed: () {
            setState(() {
              isList = !isList;
            });
          },
          child: isList
              ? Icon(Icons.dashboard_customize, color: theme.primaryColorLight)
              : Icon(Icons.list, color: theme.primaryColorLight),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              ClipPath(
                clipper: BottomClipper(),
                child: Container(
                  width: width,
                  padding: EdgeInsets.only(
                      right: height * 0.02,
                      left: height * 0.02,
                      top: height * 0.05,
                      bottom: height * 0.07),
                  color: theme.primaryColor,
                  child: HeaderSection(
                    height: height,
                    theme: theme,
                    width: width,
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
              ),
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
    required this.theme,
    required this.width,
    this.onChanged,
  }) : super(key: key);

  final double height;
  //final ProductListScreen widget;
  final ThemeData theme;
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
                  style: theme.textTheme.headline2!.copyWith(fontSize: 30),
                ),
                SizedBox(
                    width: width * 0.1,
                    child: Divider(
                      color: theme.primaryColorLight,
                      thickness: 5,
                    )),
              ],
            ),
            CartIconButton(
                color: Colors.white,
                quantity: context.watch<GeneralProvider>().cart.length,
                onTap: () {
                  Navigator.pushReplacement(
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
            style: theme.textTheme.bodyText2,
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
