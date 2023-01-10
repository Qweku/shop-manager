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
      width: width * 0.17,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
           padding: EdgeInsets.all(width * 0.02),
            child: Container(
                padding: EdgeInsets.all(width * 0.01),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Icon(
                    Icons.shop_2,
                    color: theme.primaryColor,
                  ),
                  SizedBox(width: 10),
                  Text('ShopMate',textAlign: TextAlign.center, style: theme.textTheme.bodyText1)
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
                                :Colors.grey),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              sideMenu[index]['menu'],
                              style: theme.textTheme.bodyText1!.copyWith(
                                fontSize: 17,color:indxBttn == index
                                ? theme.primaryColor
                                :Colors.grey
                                
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
