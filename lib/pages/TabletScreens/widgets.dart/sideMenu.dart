import 'package:flutter/material.dart';
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
    {'menu': 'Add Product', 'icon': Icons.shopping_bag},
    {'menu': 'Account', 'icon': Icons.receipt_long},
    {'menu': 'Inventory', 'icon': Icons.inventory},
  ];
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical:height * 0.05),
      height: height,
      width: width * 0.2,
      color: theme.primaryColorDark,
      child: Column(
        children: [
          Padding(
           padding: EdgeInsets.all(width * 0.02),
            child: Container(
                padding: EdgeInsets.all(width * 0.01),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.shop_2,
                      color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Shop Manager', style: theme.textTheme.bodyText2)
                ])),
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
                        // widget.indx!(indxBttn);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.02,left: width*0.02),
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(width * 0.01),
                        //width: width * 0.08,
                        duration: const Duration(milliseconds: 600),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            color: indxBttn == index
                                ? theme.primaryColor
                                : theme.primaryColorDark),
                        child: Row(
                          children: [
                            Icon(sideMenu[index]['icon'],
                                size: 35,
                                color: Colors.white),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              sideMenu[index]['menu'],
                              style: theme.textTheme.bodyText2!.copyWith(
                                fontSize: 17,
                                
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
