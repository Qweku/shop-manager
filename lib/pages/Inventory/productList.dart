// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';

import 'package:shop_manager/pages/widgets/productCard.dart';

class InventoryProductList extends StatefulWidget {
  // final ProductCategory category;
  const InventoryProductList({
    Key? key,
    /* required this.category */
  }) : super(key: key);

  @override
  _InventoryProductListState createState() => _InventoryProductListState();
}

class _InventoryProductListState extends State<InventoryProductList> {
  String query = "";
  bool isScrolled = false;
  bool boxScroll = false;
  bool selection = false;
  List<Product> isSelected = [];

  final ScrollController _scrollController = ScrollController();
  // var productBox = Hive.box<Product>('Product');
  // var categoryBox = Hive.box<ProductCategory>('Category');
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var categories = context.watch<GeneralProvider>();

    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: theme.primaryColor,
        //   onPressed: () {
        //     setState(() {
        //       isList = !isList;
        //     });
        //   },
        //   child: isList
        //       ? Icon(Icons.dashboard_customize, color: theme.primaryColorLight)
        //       : Icon(Icons.list, color: theme.primaryColorLight),
        // ),
        body: SafeArea(
            top: false,
            child: Builder(builder: (context) {
              _scrollController.addListener(() {
                if (boxScroll) {
                  setState(() {
                    isScrolled = true;
                  });
                } else {
                  setState(() {
                    isScrolled = false;
                  });
                }
              });
              return NestedScrollView(
                controller: _scrollController,
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  boxScroll = innerBoxIsScrolled;
                  return [
                    SliverVisibility(
                      visible: !selection,
                      sliver: SliverAppBar(
                        expandedHeight: height * 0.2,
                        pinned: false,
                        floating: false,
                        // snap:true,
                        automaticallyImplyLeading: false,

                        flexibleSpace: FlexibleSpaceBar(
                          // title:
                          //     Text('Inventory', style: theme.textTheme.headline2),
                          background: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipPath(
                                clipper: BottomClipper(),
                                child: Container(
                                  width: width,
                                  padding: EdgeInsets.only(
                                      right: height * 0.02,
                                      left: height * 0.02,
                                      top: height * 0.1,
                                      bottom: 0),
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
                            ],
                          ),
                        ),
                        // backgroundColor: theme.primaryColor,
                        backgroundColor: Colors.transparent,
                      ),
                      replacementSliver: SliverToBoxAdapter(
                          child: AppBar(
                        elevation: 0,
                        leading: GestureDetector(
                            onTap: () {
                              setState(() {
                                selection = false;
                              });
                              isSelected.clear();
                            },
                            child: Icon(
                              Icons.close,
                              size: 32,
                            )),
                        title: Text('${isSelected.length} selected'),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 10),
                            child: GestureDetector(
                              onTap: (() {
                                Provider.of<GeneralProvider>(context,
                                        listen: false)
                                    .inventory
                                    .forEach((element) async {
                                  if (isSelected.contains(element)) {
                                    // productBox.values
                                    //         .singleWhere((elements) =>
                                    //             elements == element)
                                    //         .itemcategory =
                                    //     widget.category.categoryName;
                                    // await productBox.values
                                    //     .singleWhere(
                                    //         (elements) => elements == element)
                                    //     .save();
                                    element.productCategory = context
                                        .read<GeneralProvider>()
                                        .category;
                                    // Provider.of<GeneralProvider>(context,
                                    //         listen: false)
                                    //     .categories
                                    //     .singleWhere((element) =>
                                    //         element == widget.category)
                                    //     .products = HiveList(productBox);
                                    // Provider.of<GeneralProvider>(context,
                                    //         listen: false)
                                    //     .categories
                                    //     .singleWhere((element) =>
                                    //         element == widget.category)
                                    //     .products!
                                    //     .addAll(productBox.values.where(
                                    //         (value) =>
                                    //             value.itemcategory!
                                    //                 .toLowerCase() ==
                                    //             widget.category.categoryName
                                    //                 .toLowerCase()));
                                    // HiveFunctions()
                                    //     .saveToCategory(widget.category);
                                    Navigator.pop(context);
                                  }
                                });
                              }),
                              child: Icon(
                                Icons.check,
                                size: 32,
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                          //   child: Text('Done',style: theme.appBarTheme.titleTextStyle,),
                          // ),
                        ],
                        backgroundColor: theme.primaryColor,
                      )),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    SizedBox(height: height * 0.03),
                    categories.inventory
                            .where((value) => value.productCategory!.cid == 0)
                            .toList()
                            .isEmpty
                        ? Center(
                            child: Text(
                              'No Uncategorised Products',
                              style: theme.textTheme.headline1!.copyWith(
                                  fontSize: 25, color: Colors.blueGrey),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: height * 0.01),
                              child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 800),
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: categories.inventory
                                          .where((value) =>
                                              value.productCategory!.cid == 0)
                                          .length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selection = true;
                                            });

                                            if (isSelected.contains(categories
                                                .inventory
                                                .where((value) =>
                                                    value
                                                        .productCategory!.cid ==
                                                    0)
                                                .toList()[index])) {
                                              isSelected.removeWhere((element) =>
                                                  element ==
                                                  categories.inventory
                                                      .where((value) =>
                                                          value.productCategory!
                                                              .cid ==
                                                          0)
                                                      .toList()[index]);
                                            } else {
                                              isSelected.add(categories
                                                  .inventory
                                                  .where((value) =>
                                                      value.productCategory!
                                                          .cid ==
                                                      0)
                                                  .toList()[index]);
                                            }
                                          },
                                          child: ProductListTile(
                                            isSelected: isSelected.contains(
                                                categories.inventory
                                                    .where((value) =>
                                                        value.productCategory!
                                                            .cid ==
                                                        0)
                                                    .toList()[index]),
                                            onTap: () {},
                                            index: index,
                                            image64: categories.inventory
                                                    .where((value) =>
                                                        value.productCategory!
                                                            .cid ==
                                                        0)
                                                    .toList()[index]
                                                    .productImage ??
                                                "",
                                            productName: categories.inventory
                                                .where((value) =>
                                                    value
                                                        .productCategory!.cid ==
                                                    0)
                                                .toList()[index]
                                                .productName,
                                            quantity: categories.inventory
                                                .where((value) =>
                                                    value
                                                        .productCategory!.cid ==
                                                    0)
                                                .toList()[index]
                                                .productQuantity
                                                .toString(),
                                            price:
                                                "GHS ${categories.inventory.where((value) => value.productCategory!.cid == 0).toList()[index].sellingPrice.toString()}",
                                          ),
                                        );
                                      })),
                            ),
                          )
                  ],
                ),
              );
            })));
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
      ],
    );
  }
}
