// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/productModel.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/search.dart';
import 'package:shop_manager/pages/widgets/categoryCard.dart';
import 'widgets/clipPath.dart';
import 'widgets/productCard.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  //File _image;
  List<String>? imagePaths;
  // final toBytes = Io.File(widget.imagePath).readAsBytesSync();
  // String base64Image = base64Encode(toBytes);
  Product? product;
  String? imagePath;
  bool isList = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //var categories = context.watch<GeneralProvider>();
    var categories = context.watch<GeneralProvider>();
    final theme = Theme.of(context);
    return Scaffold(
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
              // height: height * 0.8,
              children: [
                ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    width: width,
                    padding: EdgeInsets.only(
                        right: height * 0.02,
                        left: height * 0.02,
                        top: height * 0.1,
                        bottom: height * 0.07),
                    color: theme.primaryColor,
                    child: HeaderSection(
                      height: height,
                      theme: theme,
                      width: width,
                      onPressed: () {
                        showSearch(
                            //useRootNavigator: true,
                            context: context,
                            delegate: Search());
                        // print('SEARCH');
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  height: height * 0.15,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.categories!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: width * 0.3,
                          child: CategoryCard(
                            index: index,
                            onTap: () {
                              // categories =
                              //     categories.categories[index];
                              // categories.categorised = true;
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ProductListScreen(
                              //               categoryIndex: index,
                              //             )));
                            },
                            smallFont: 12.0,
                            largeFont: 25.0,
                            categoryName:
                                "${categories.categories![index].categoryName}",
                            categoryInitial: categories
                                .categories![index].categoryName!
                                .substring(0, 2),
                          ),
                        );
                      }),
                ),
                categories.categories!.isEmpty
                    ? Center(
                        child: Text(
                          'No Products',
                          style: theme.textTheme.headline1!
                              .copyWith(fontSize: 25, color: Colors.blueGrey),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.01),
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 800),
                            child: !isList
                                ? GridView.builder(
                                    physics: BouncingScrollPhysics(),
                                    padding:
                                        EdgeInsets.only(top: height * 0.02),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 2 / 2.9),
                                    itemCount: categories.inventory.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: index.isEven
                                                ? height * 0.02
                                                : 0,
                                            bottom: index.isOdd
                                                ? height * 0.02
                                                : 0),
                                        child: ProductCard(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductView(
                                                          product: categories
                                                              .inventory[index],
                                                        )));
                                          },
                                          index: index,
                                          image64: categories
                                                  .inventory[index].imageb64 ??
                                              "",
                                          productName: categories
                                              .inventory[index].productName,
                                          quantity: categories
                                              .inventory[index].quantity
                                              .toString(),
                                          price:
                                              "GHS ${categories.inventory[index].sellingPrice.toString()}",
                                        ),
                                      );
                                    })
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: categories.inventory.length,
                                    itemBuilder: (context, index) {
                                      return ProductListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductView(
                                                        product: categories
                                                            .inventory[index],
                                                      )));
                                        },
                                        index: index,
                                        image64: categories
                                                .inventory[index].imageb64 ??
                                            "",
                                        productName: categories
                                            .inventory[index].productName,
                                        quantity: categories
                                            .inventory[index].quantity
                                            .toString(),
                                        price:
                                            "GHS ${categories.inventory[index].sellingPrice.toString()}",
                                      );
                                    })),
                      ))
              ]),
        ));
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    Key? key,
    required this.height,
    required this.theme,
    required this.width,
    this.onPressed,
  }) : super(key: key);

  final double height;
  final ThemeData theme;
  final double width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.primaryColor),
          child: IconButton(
            icon: Icon(Icons.search, color: theme.primaryColorLight, size: 30),
            onPressed: onPressed,
          ),
        )
      ],
    );
  }
}
