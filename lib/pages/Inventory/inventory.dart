// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:shop_manager/pages/Inventory/InventoryList.dart';
import 'package:shop_manager/pages/Inventory/InventorySearchList.dart';

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
                      expandedHeight: height * 0.23,
                      pinned: true,
                      floating: true,
                      // snap:true,
                      automaticallyImplyLeading: false,

                      flexibleSpace: FlexibleSpaceBar(
                        // title:
                        //     Text('Inventory', style: theme.textTheme.headline2),
                        background: 
                        Stack(
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
                            Positioned(
                              bottom: 0,
                              right: 0,left:0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal:width * 0.05),
                                child: SizedBox(
                                  width: width*0.8,
                                  child: ItemSearchBar(
                                    valueCallback: (valueCallback) {
                                      setState(() {
                                        query = valueCallback;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      
                      ),
                      backgroundColor: Colors.white,
                      
                    ),
                  ];
                },
                body:
                AnimatedSwitcher(
                    duration: Duration(microseconds: 100),
                    child: (query.isEmpty)
                        ? InventoryList(
                            isList: isList,
                          )
                        : InventorySearchList(query: query, isList: isList)),
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

