// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
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
  String query = "";
  bool isList = false;
  int isSelected = 0;
  List<Product> productItems = [];
  List<Product> searchItem(String query) {
    productItems.clear();
    for (ProductCategory element
        in Provider.of<GeneralProvider>(context, listen: false).categories!) {
      productItems.addAll(element.products!.where((elements) =>
          elements.productName!.toLowerCase().contains(query.toLowerCase())));
    }
    return productItems;
  }

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
                        // showSearch(
                        //     //useRootNavigator: true,
                        //     context: context,
                        //     delegate: Search());
                        // print('SEARCH');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.03),
                  child: ItemSearchBar(
                    valueCallback: (valueCallback) {
                      setState(() {
                        query = valueCallback;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                      duration: Duration(microseconds: 100),
                      child: (query.isEmpty)
                          ? Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.01),
                                    height: height * 0.15,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            categories.categories!.length + 1,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSelected = index;
                                              });
                                            },
                                            child: SizedBox(
                                              width: width * 0.3,
                                              child: CategoryCard(
                                                index: index,
                                                selected: isSelected == index
                                                    ? true
                                                    : false,
                                                smallFont: 12.0,
                                                largeFont: 25.0,
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
                                                .copyWith(
                                                    fontSize: 25,
                                                    color: Colors.blueGrey),
                                          ),
                                        )
                                      : Expanded(
                                          child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: height * 0.01),
                                          child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 800),
                                              child: !isList
                                                  ? GridView.builder(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding: EdgeInsets.only(
                                                          top: height * 0.02),
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              childAspectRatio:
                                                                  2 / 2.9),
                                                      itemCount: isSelected == 0
                                                          ? categories
                                                              .inventory.length
                                                          : categories
                                                              .categories![
                                                                  isSelected -
                                                                      1]
                                                              .products!
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: index
                                                                          .isEven
                                                                      ? height *
                                                                          0.02
                                                                      : 0,
                                                                  bottom: index
                                                                          .isOdd
                                                                      ? height *
                                                                          0.02
                                                                      : 0),
                                                          child: ProductCard(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductView(
                                                                            product: isSelected == 0
                                                                                ? categories.inventory[index]
                                                                                : categories.categories![isSelected - 1].products![index],
                                                                          )));
                                                            },
                                                            index: index,
                                                            image64: isSelected ==
                                                                    0
                                                                ? categories
                                                                        .inventory[
                                                                            index]
                                                                        .imageb64 ??
                                                                    ""
                                                                : categories
                                                                        .categories![
                                                                            isSelected -
                                                                                1]
                                                                        .products![
                                                                            index]
                                                                        .imageb64 ??
                                                                    "",
                                                            productName: isSelected ==
                                                                    0
                                                                ? categories
                                                                    .inventory[
                                                                        index]
                                                                    .productName
                                                                : categories
                                                                    .categories![
                                                                        isSelected -
                                                                            1]
                                                                    .products![
                                                                        index]
                                                                    .productName,
                                                            quantity: isSelected ==
                                                                    0
                                                                ? categories
                                                                    .inventory[
                                                                        index]
                                                                    .quantity
                                                                    .toString()
                                                                : categories
                                                                    .categories![
                                                                        isSelected -
                                                                            1]
                                                                    .products![
                                                                        index]
                                                                    .quantity
                                                                    .toString(),
                                                            price:
                                                                "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.categories![isSelected - 1].products![index].sellingPrice.toString()}",
                                                          ),
                                                        );
                                                      })
                                                  : ListView.builder(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      itemCount: isSelected == 0
                                                          ? categories
                                                              .inventory.length
                                                          : categories
                                                              .categories![
                                                                  isSelected -
                                                                      1]
                                                              .products!
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ProductListTile(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProductView(
                                                                              product: categories.inventory[index],
                                                                            )));
                                                          },
                                                          index: index,
                                                          image64: isSelected ==
                                                                  0
                                                              ? categories
                                                                      .inventory[
                                                                          index]
                                                                      .imageb64 ??
                                                                  ""
                                                              : categories
                                                                      .categories![
                                                                          isSelected -
                                                                              1]
                                                                      .products![
                                                                          index]
                                                                      .imageb64 ??
                                                                  "",
                                                          productName: isSelected ==
                                                                  0
                                                              ? categories
                                                                  .inventory[
                                                                      index]
                                                                  .productName
                                                              : categories
                                                                  .categories![
                                                                      isSelected -
                                                                          1]
                                                                  .products![
                                                                      index]
                                                                  .productName,
                                                          quantity: isSelected ==
                                                                  0
                                                              ? categories
                                                                  .inventory[
                                                                      index]
                                                                  .quantity
                                                                  .toString()
                                                              : categories
                                                                  .categories![
                                                                      isSelected -
                                                                          1]
                                                                  .products![
                                                                      index]
                                                                  .quantity
                                                                  .toString(),
                                                          price:
                                                              "GHS ${isSelected == 0 ? categories.inventory[index].sellingPrice.toString() : categories.categories![isSelected - 1].products![index].sellingPrice.toString()}",
                                                        );
                                                      })),
                                        ))
                                ],
                              ),
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  (searchItem(query).isEmpty)
                                      ? Center(
                                          child: Text(
                                            'No Products',
                                            style: theme.textTheme.headline1!
                                                .copyWith(
                                                    fontSize: 25,
                                                    color: Colors.blueGrey),
                                          ),
                                        )
                                      : Expanded(
                                          child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: height * 0.01),
                                          child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 800),
                                              child: !isList
                                                  ? GridView.builder(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding: EdgeInsets.only(
                                                          top: height * 0.02),
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              childAspectRatio:
                                                                  2 / 2.9),
                                                      itemCount:
                                                          productItems.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: index
                                                                          .isEven
                                                                      ? height *
                                                                          0.02
                                                                      : 0,
                                                                  bottom: index
                                                                          .isOdd
                                                                      ? height *
                                                                          0.02
                                                                      : 0),
                                                          child: ProductCard(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductView(
                                                                            product:
                                                                                productItems[index],
                                                                          )));
                                                            },
                                                            index: index,
                                                            image64: productItems[
                                                                        index]
                                                                    .imageb64 ??
                                                                "",
                                                            productName:
                                                                productItems[
                                                                        index]
                                                                    .productName,
                                                            quantity:
                                                                productItems[
                                                                        index]
                                                                    .quantity
                                                                    .toString(),
                                                            price:
                                                                "GHS ${productItems[index].sellingPrice.toString()}",
                                                          ),
                                                        );
                                                      })
                                                  : ListView.builder(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      itemCount:
                                                          productItems.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ProductListTile(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProductView(
                                                                              product: productItems[index],
                                                                            )));
                                                          },
                                                          index: index,
                                                          image64: productItems[
                                                                      index]
                                                                  .imageb64 ??
                                                              "",
                                                          productName:
                                                              productItems[
                                                                      index]
                                                                  .quantity
                                                                  .toString(),
                                                          price:
                                                              "GHS ${productItems[index].sellingPrice.toString()}",
                                                        );
                                                      })),
                                        ))
                                ],
                              ),
                            )),
                ),
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
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: theme.primaryColor),
        //   child: IconButton(
        //     icon: Icon(Icons.search, color: theme.primaryColorLight, size: 30),
        //     onPressed: onPressed,
        //   ),
        // )
      ],
    );
  }
}
