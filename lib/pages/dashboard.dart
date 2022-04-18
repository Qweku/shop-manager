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
    final theme = Theme.of(context);
    return Scaffold(
        bottomNavigationBar: const BottomNav(),
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
                    SizedBox(
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
                    SizedBox(
                        height: height * 0.53,
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: [
                            GridMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryScreen()));
                              },
                              label: "Categories",
                              icon: Icons.category,
                              menuColor: theme.primaryColorLight,
                              iconColor: theme.primaryColor,
                            ),
                            GridMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddProductScreen()));
                              },
                              label: "Add Product",
                              icon: Icons.shopping_bag,
                              menuColor: theme.primaryColorLight,
                              iconColor: theme.primaryColor,
                            ),
                            GridMenuItem(
                              onTap: () {},
                              label: "Accounts",
                              icon: Icons.receipt_long,
                              menuColor: theme.primaryColor,
                              iconColor: theme.primaryColorLight,
                            ),
                            GridMenuItem(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InventoryScreen()));
                              },
                              label: "Inventory",
                              icon: Icons.inventory,
                              menuColor: theme.primaryColor,
                              iconColor: theme.primaryColorLight,
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

class GridMenuItem extends StatelessWidget {
  final Function()? onTap;
  final Color menuColor, iconColor;
  final String label;
  final IconData icon;
  const GridMenuItem({
    Key? key,
    this.onTap,
    required this.menuColor,
    required this.iconColor,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: menuColor,
              border: Border.all(color: iconColor, width: 2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: iconColor),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(label,
                    style: TextStyle(fontSize: 20, color: iconColor)),
              ),
            ],
          )),
    );
  }
}
