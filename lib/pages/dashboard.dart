import 'package:flutter/material.dart';
 import 'package:shop_manager/components/bottomnav.dart';
import 'package:shop_manager/config/colors.dart';
 import 'package:shop_manager/pages/inventory.dart';

import 'addproduct.dart';
import 'category.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        bottomNavigationBar: BottomNav(),
        backgroundColor: ShopColors.primaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: height * 0.5,
                decoration: BoxDecoration(
                    color: ShopColors.secondaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(width * 0.5),
                      //bottomRight: Radius.circular(width * 0.5)
                    )),
              ),
            ),
            Container(
              height: height,
              width: width,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: height * 0.14,
                        child: Column(
                          children: [
                            Icon(Icons.shop_two_outlined,
                                size: 50, color: ShopColors.primaryColor),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 10),
                              child: Text("Shop",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ShopColors.primaryColor)),
                            ),
                          ],
                        )),
                    Container(
                        height: height * 0.53,
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryScreen()));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ShopColors.primaryColor,
                                      border: Border.all(
                                          color: ShopColors.secondaryColor!,
                                          width: 2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.category,
                                          size: 40,
                                          color: ShopColors.secondaryColor),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("Categories",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    ShopColors.secondaryColor)),
                                      ),
                                    ],
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddProductScreen()));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ShopColors.primaryColor,
                                      border: Border.all(
                                          color: ShopColors.secondaryColor!,
                                          width: 2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_bag,
                                          size: 40,
                                          color: ShopColors.secondaryColor),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("Add product",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    ShopColors.secondaryColor)),
                                      ),
                                    ],
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             CategoryScreen()));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ShopColors.secondaryColor,
                                      border: Border.all(
                                          color: ShopColors.secondaryColor!,
                                          width: 2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.list_alt,
                                          size: 40,
                                          color: ShopColors.primaryColor),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("Accounts",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    ShopColors.primaryColor)),
                                      ),
                                    ],
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InventoryScreen()));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ShopColors.secondaryColor,
                                      border: Border.all(
                                          color: ShopColors.primaryColor,
                                          width: 2)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.inventory,
                                          size: 40,
                                          color: ShopColors.primaryColor),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("Inventory",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    ShopColors.primaryColor)),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
