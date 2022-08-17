// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    //var categories = context.watch<GeneralProvider>();
    var categories = context.watch<GeneralProvider>();
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: height * 0.03),
        SizedBox(
          // padding: EdgeInsets.symmetric(
          //     vertical: height * 0.01),
          height: height * 0.12,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.categories!.length + 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = index;
                    });
                  },
                  child: SizedBox(
                    width: width * 0.27,
                    child: CategoryCard(
                      index: index,
                      selected: isSelected == index ? true : false,
                      smallFont: 10.0,
                      largeFont: 20.0,
                      categoryName:
                          "${(index == 0) ? "ALL" : categories.categories![index - 1].categoryName}",
                    ),
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
                  padding: EdgeInsets.symmetric(horizontal: height * 0.01),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: !widget.isList
                          ? GridView.builder(
                              // shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: height * 0.01),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 2.9),
                              itemCount: isSelected == 0
                                  ? categories.inventory.length
                                  : categories.categories![isSelected - 1]
                                      .products!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: index.isEven ? height * 0.02 : 0,
                                      bottom: index.isOdd ? height * 0.02 : 0),
                                  child: ProductCard(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProductView(
                                                    product: isSelected == 0
                                                        ? categories
                                                            .inventory[index]
                                                        : categories
                                                            .categories![
                                                                isSelected - 1]
                                                            .products![index],
                                                  )));
                                    },
                                    index: index,
                                    image64: isSelected == 0
                                        ? categories
                                                .inventory[index].imageb64 ??
                                            ""
                                        : categories.categories![isSelected - 1]
                                                .products![index].imageb64 ??
                                            "",
                                    productName: isSelected == 0
                                        ? categories
                                            .inventory[index].productName
                                        : categories.categories![isSelected - 1]
                                            .products![index].productName,
                                    quantity: isSelected == 0
                                        ? categories.inventory[index].quantity
                                            .toString()
                                        : categories.categories![isSelected - 1]
                                            .products![index].quantity
                                            .toString(),
                                    price:
                                        "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.categories![isSelected - 1].products![index].sellingPrice.toString()}",
                                  ),
                                );
                              })
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: isSelected == 0
                                  ? categories.inventory.length
                                  : categories.categories![isSelected - 1]
                                      .products!.length,
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
                                      ? categories.inventory[index].imageb64 ??
                                          ""
                                      : categories.categories![isSelected - 1]
                                              .products![index].imageb64 ??
                                          "",
                                  productName: isSelected == 0
                                      ? categories.inventory[index].productName
                                      : categories.categories![isSelected - 1]
                                          .products![index].productName,
                                  quantity: isSelected == 0
                                      ? categories.inventory[index].quantity
                                          .toString()
                                      : categories.categories![isSelected - 1]
                                          .products![index].quantity
                                          .toString(),
                                  price:
                                      "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.categories![isSelected - 1].products![index].sellingPrice.toString()}",
                                );
                              })),
                ),
              )
      ],
    );
  }
}
