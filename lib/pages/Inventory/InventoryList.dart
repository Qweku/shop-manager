// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/widgets/categoryCard.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/productCard.dart';

class InventoryList extends StatefulWidget {
  final bool isList;
  const InventoryList({Key? key, this.isList = false}) : super(key: key);

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<String>? imagePaths;

  Product? product;
  String? imagePath;
  String query = "";

  bool isScrolled = false;
  int isSelected = 0;
  List<Product> productItems = [];
  @override
  Widget build(BuildContext context) {
    var categories = context.watch<GeneralProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: height * 0.03),

        ((isSelected == 0)
                ? categories.inventory.isEmpty
                : categories.inventory
                    .where((element) =>
                        element.productCategory!.cid ==
                        categories.categories[isSelected - 1].cid)
                    .toSet()
                    .toList()
                    .isEmpty)
            ? Center(
                child: Text(
                  'No Products',
                  style:
                      headline1.copyWith(fontSize: 25, color: Colors.blueGrey),
                ),
              )
            : Expanded(
                child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: GridView.builder(
                        // shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: height * 0.01),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Responsive.isMobile() ? 3 : 4,
                            childAspectRatio: 2 / 3.5),
                        itemCount: isSelected == 0
                            ? categories.inventory.length
                            : categories.inventory
                                .where((element) =>
                                    element.productCategory!.cid ==
                                    categories.categories[isSelected - 1].cid)
                                .toSet()
                                .toList()
                                .length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: ProductCard(
                              onLongPress: () {
                                _bottomDrawSheet(
                                    context,
                                     isSelected == 0
                                        ? categories.inventory[index]
                                        : categories.inventory
                                            .where((element) =>
                                                element.productCategory ==
                                                categories
                                                    .categories[isSelected - 1])
                                            .toList()[index],);
                              },
                              onPressed: () {
                                if (!(context
                                    .read<GeneralProvider>()
                                    .cart
                                    .contains(categories.inventory[index]))) {
                                      
                                  Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .addToCart(
                                    isSelected == 0
                                        ? categories.inventory[index]
                                        : categories.inventory
                                            .where((element) =>
                                                element.productCategory ==
                                                categories
                                                    .categories[isSelected - 1])
                                            .toList()[index],
                                  );
                                }
                              },
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductView(
                                              product: isSelected == 0
                                                  ? categories.inventory[index]
                                                  : categories.inventory
                                                      .where((element) =>
                                                          element
                                                              .productCategory ==
                                                          categories.categories[
                                                              isSelected - 1])
                                                      .toList()[index],
                                            )));
                              },
                              index: index,
                              image64: isSelected == 0
                                  ? categories.inventory[index].productImage ??
                                      ""
                                  : categories.inventory
                                          .where((element) =>
                                              element.productCategory!.cid ==
                                              categories
                                                  .categories[isSelected - 1]
                                                  .cid)
                                          .toList()[index]
                                          .productImage ??
                                      "",
                              productName: isSelected == 0
                                  ? categories.inventory[index].productName
                                  : categories.inventory
                                      .where((element) =>
                                          element.productCategory!.cid ==
                                          categories
                                              .categories[isSelected - 1].cid)
                                      .toList()[index]
                                      .productName,
                              quantity: isSelected == 0
                                  ? categories.inventory[index].productQuantity
                                      .toString()
                                  : categories.inventory
                                      .where((element) =>
                                          element.productCategory!.cid ==
                                          categories
                                              .categories[isSelected - 1].cid)
                                      .toList()[index]
                                      .productQuantity
                                      .toString(),
                              price:
                                  "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toStringAsFixed(2) : categories.inventory.where((element) => element.productCategory!.cid == categories.categories[isSelected - 1].cid).toList()[index].sellingPrice.toStringAsFixed(2)}",
                            ),
                          );
                        })),
              ))
      ],
    );
  }

  void _bottomDrawSheet(BuildContext context, Product product) {
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => AddProductScreen(
                                      toEdit: true,
                                      product: product,
                                    ))).then((value) {
                          setState(() {});
                          Navigator.pop(context);
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.edit, color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Edit', style: bodyText1)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<GeneralProvider>(context, listen: false)
                            .deleteProduct(product);

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.delete, color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Remove', style: bodyText1)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
        });
  }
}



  // : ListView.builder(
  //                             physics: const BouncingScrollPhysics(),
  //                             padding: EdgeInsets.zero,
  //                             itemCount: isSelected == 0
  //                                 ? categories.inventory.length
  //                                 : categories.inventory
  //                                     .where((element) =>
  //                                         element.productCategory!.cid ==
  //                                         categories
  //                                             .categories[isSelected - 1].cid)
  //                                     .toList()
  //                                     .length,
  //                             itemBuilder: (context, index) {
  //                               return ProductListTile(
  //                                 onTap: () {
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                           builder: (context) => ProductView(
  //                                                 product: categories
  //                                                     .inventory[index],
  //                                               )));
  //                                 },
  //                                 index: index,
  //                                 image64: isSelected == 0
  //                                     ? categories
  //                                             .inventory[index].productImage ??
  //                                         ""
  //                                     : categories.inventory
  //                                             .where((element) =>
  //                                                 element
  //                                                     .productCategory!.cid ==
  //                                                 categories
  //                                                     .categories[
  //                                                         isSelected - 1]
  //                                                     .cid)
  //                                             .toList()[index]
  //                                             .productImage ??
  //                                         "",
  //                                 productName: isSelected == 0
  //                                     ? categories.inventory[index].productName
  //                                     : categories.inventory
  //                                         .where((element) =>
  //                                             element.productCategory!.cid ==
  //                                             categories
  //                                                 .categories[isSelected - 1]
  //                                                 .cid)
  //                                         .toList()[index]
  //                                         .productName,
  //                                 quantity: isSelected == 0
  //                                     ? categories
  //                                         .inventory[index].productQuantity
  //                                         .toString()
  //                                     : categories.inventory
  //                                         .where((element) =>
  //                                             element.productCategory!.cid ==
  //                                             categories
  //                                                 .categories[isSelected - 1]
  //                                                 .cid)
  //                                         .toList()[index]
  //                                         .productQuantity
  //                                         .toString(),
  //                                 price:
  //                                     "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.inventory.where((element) => element.productCategory!.cid == categories.categories[isSelected - 1].cid).toList()[index].sellingPrice.toString()}",
  //                               );
  //                             })),
           