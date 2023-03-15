// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/widgets/categoryCard.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var categories = context.watch<GeneralProvider>();
    final theme = Theme.of(context);
    return Column(
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
                  style: theme.textTheme.headline1!
                      .copyWith(fontSize: 25, color: Colors.blueGrey),
                ),
              )
            : Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: !widget.isList
                          ? GridView.builder(
                              // shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: height * 0.01),
                              gridDelegate:
                                   SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: Responsive.isMobile()?3:6,
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
                                    onPressed: () {
                                      if (!(context
                                          .read<GeneralProvider>()
                                          .cart
                                          .contains(
                                              categories.inventory[index]))) {
                                        Provider.of<GeneralProvider>(context,
                                                listen: false)
                                            .addToCart(
                                          isSelected == 0
                                              ? categories.inventory[index]
                                              : categories.inventory
                                                  .where((element) =>
                                                      element.productCategory ==
                                                      categories.categories[
                                                          isSelected - 1])
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
                                                        ? categories
                                                            .inventory[index]
                                                        : categories.inventory
                                                            .where((element) =>
                                                                element
                                                                    .productCategory ==
                                                                categories
                                                                        .categories[
                                                                    isSelected -
                                                                        1])
                                                            .toList()[index],
                                                  )));
                                    },
                                    index: index,
                                    image64: isSelected == 0
                                        ? categories.inventory[index]
                                                .productImage ??
                                            ""
                                        : categories.inventory
                                                .where((element) =>
                                                    element.productCategory!.cid ==
                                                    categories.categories[
                                                        isSelected - 1].cid)
                                                .toList()[index]
                                                .productImage ??
                                            "",
                                    productName: isSelected == 0
                                        ? categories
                                            .inventory[index].productName
                                        : categories.inventory
                                            .where((element) =>
                                                element.productCategory!.cid ==
                                                categories
                                                    .categories[isSelected - 1].cid)
                                            .toList()[index]
                                            .productName,
                                    quantity: isSelected == 0
                                        ? categories
                                            .inventory[index].productQuantity
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
                                        "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.inventory.where((element) => element.productCategory!.cid == categories.categories[isSelected - 1].cid).toList()[index].sellingPrice.toString()}",
                                  ),
                                );
                              })
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: isSelected == 0
                                  ? categories.inventory.length
                                  : categories.inventory
                                      .where((element) =>
                                          element.productCategory!.cid ==
                                          categories.categories[isSelected - 1].cid)
                                      .toList()
                                      .length,
                              itemBuilder: (context, index) {
                                return ProductListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductView(
                                                  product: categories
                                                      .inventory[index],
                                                )));
                                  },
                                  index: index,
                                  image64: isSelected == 0
                                      ? categories
                                              .inventory[index].productImage ??
                                          ""
                                      : categories.inventory
                                              .where((element) =>
                                                  element.productCategory!.cid ==
                                                  categories.categories[
                                                      isSelected - 1].cid)
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
                                      ? categories
                                          .inventory[index].productQuantity
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
                                      "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.inventory.where((element) => element.productCategory!.cid == categories.categories[isSelected - 1].cid).toList()[index].sellingPrice.toString()}",
                                );
                              })),
                ),
              )
      ],
    );
  }
}
