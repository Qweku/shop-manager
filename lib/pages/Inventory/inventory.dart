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
          child: NestedScrollView(
            controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                _scrollController.addListener(() {
                  if(innerBoxIsScrolled){
                    setState(() {
                      isScrolled = true;
                    });
                  }else{
                    setState(() {
                      isScrolled = false;
                    });
                  }
                });
                return [
                  SliverAppBar(
                    expandedHeight: height * 0.2,
                    pinned: true,
                    floating: true,
                    // snap:true,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      title:
                          Text('Inventory', style: theme.textTheme.headline2),
                      background: ClipPath(
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
                    ),
                    backgroundColor: Colors.white,
                    bottom: AppBar(
                      automaticallyImplyLeading: isScrolled,
                      elevation: 0,
                      backgroundColor:
                          !isScrolled ? Colors.transparent : theme.primaryColor,
                      title: !isScrolled
                          ? Padding(
                              padding: EdgeInsets.all(width * 0.03),
                              child: ItemSearchBar(
                                valueCallback: (valueCallback) {
                                  setState(() {
                                    query = valueCallback;
                                  });
                                },
                              ),
                            )
                          : Text('Inventory', style: theme.textTheme.headline2),
                    ),
                  ),
                ];
              },
              body: Column(children: [
                Expanded(
                    child: AnimatedSwitcher(
                        duration: Duration(microseconds: 100),
                        child: (query.isEmpty)
                            ? InventoryList(
                                isList: isList,
                              )
                            : InventorySearchList(
                                query: query, isList: isList))),
              ]),
            )
         
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
