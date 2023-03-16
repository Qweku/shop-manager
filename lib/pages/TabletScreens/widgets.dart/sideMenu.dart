import 'package:flutter/material.dart';
import 'package:shop_manager/pages/Inventory/inventory.dart';
import 'package:shop_manager/pages/TabletScreens/Dashboard.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/low_stock_list.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SideMenu extends StatefulWidget {
  final Function(int menuIndex)? indx;
  const SideMenu({Key? key, this.indx}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int indxBttn = 0;
  List<Map<String, dynamic>> sideMenu = [
    {'menu': 'Dashboard', 'icon': Icons.dashboard_customize},
    {'menu': 'Category', 'icon': Icons.category},
    {'menu': 'Low Stock Items', 'icon': Icons.arrow_circle_down_outlined},
    {'menu': 'Sales', 'icon': Icons.receipt_long},
    {'menu': 'Inventory', 'icon': Icons.inventory},
  ];
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.05),
      height: height,
      width: width * 0.14,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: Image.asset("assets/app_icon.png",height: height*0.12,),
          ),
          Divider(
            color: Colors.grey,
            height: height * 0.1,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                sideMenu.length,
                (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        indxBttn = index;
                        widget.indx!(indxBttn);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.02, ),
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(width * 0.01),
                        //width: width * 0.08,
                        duration: const Duration(milliseconds: 600),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Icon(sideMenu[index]['icon'],
                                //size: 35,
                                color: indxBttn == index
                                    ? theme.primaryColor
                                    : Colors.grey),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                sideMenu[index]['menu'],
                                style: theme.textTheme.bodyText1!.copyWith(
                                    fontSize: 17,
                                    color: indxBttn == index
                                        ? theme.primaryColor
                                        : Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              )),
        ],
      ),
    );
  }
}

List<Widget> sideMenuItems = [
  TabletHomeScreen(),
  Container(),
  LowStockList(),
  Container(),
  InventoryScreen(),
  AddProductScreen()
];
