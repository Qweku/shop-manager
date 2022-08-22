// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/pages/widgets/clipPath.dart';

import 'package:shop_manager/pages/widgets/productCard.dart';

class InventoryProductList extends StatefulWidget {
  const InventoryProductList({
    Key? key,
  }) : super(key: key);

  @override
  _InventoryProductListState createState() => _InventoryProductListState();
}

class _InventoryProductListState extends State<InventoryProductList> {
  String query = "";
  bool isScrolled = false;
  bool boxScroll = false;
  int isSelected = 0;

  final ScrollController _scrollController = ScrollController();

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
                    SliverAppBar(
                      expandedHeight: height * 0.2,
                      pinned: true,
                      floating: true,
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
                          ],
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ];
                },
                body: Column(
                  children: [
                    SizedBox(height: height * 0.03),
                    categories.inventory
                            .skipWhile((value) =>
                                value.itemcategory != 'Uncategorised')
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
                                          .skipWhile((value) =>
                                              value.itemcategory !=
                                              'Uncategorised')
                                          .length,
                                      itemBuilder: (context, index) {
                                        return ProductListTile(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ProductView(
                                            //               product: categories
                                            //                   .inventory[index],
                                            //             )));
                                          },
                                          index: index,
                                          image64: categories.inventory
                                                  .skipWhile((value) =>
                                                      value.itemcategory !=
                                                      'Uncategorised')
                                                  .toList()[index]
                                                  .imageb64 ??
                                              "",
                                          productName: categories.inventory
                                              .skipWhile((value) =>
                                                  value.itemcategory !=
                                                  'Uncategorised')
                                              .toList()[index]
                                              .productName,
                                          quantity: categories.inventory
                                              .skipWhile((value) =>
                                                  value.itemcategory !=
                                                  'Uncategorised')
                                              .toList()[index]
                                              .quantity
                                              .toString(),
                                          price:
                                              "GHS ${categories.inventory.skipWhile((value) => value.itemcategory != 'Uncategorised').toList()[index].sellingPrice.toString()}",
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
