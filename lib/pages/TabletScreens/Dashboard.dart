import 'package:flutter/material.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/TabletScreens/widgets.dart/sideMenu.dart';
import 'package:shop_manager/pages/dashboard.dart';
import 'package:shop_manager/pages/widgets/barChart.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/itemGraph.dart';

class TabletDashboard extends StatelessWidget {
  const TabletDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Row(
          children: [
            const SideMenu(),
            //SizedBox(width: width*0.05,),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height:height*0.05),
                          // Text(
                          //   'Dashboard',
                          //   style: theme.textTheme.headline2,
                          // ),
                          //SizedBox(height: height * 0.05),
                          Row(
                            children: [
                                 SizedBox(
                                  height: height * 0.47,
                                  width: width * 0.45,
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      height: height * 0.25,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: Responsive.isMobile()
                                              ? theme.primaryColor
                                              : theme.primaryColorDark,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 1),
                                                color: Color.fromARGB(
                                                    255, 47, 48, 121),
                                                blurRadius: 2,
                                                spreadRadius: 1),
                                          ]),
                                      child: const ItemGraph())),
                       
                             
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: SizedBox(
                                height: height * 0.4,
                                child: GridView.count(
                                    padding: EdgeInsets.zero,
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 2.5,
                                    children: List.generate(
                                      2,
                                      (index) => ItemStatus(
                                        status: statusList[index]['status'],
                                        label: statusList[index]['label'],
                                        icon: statusList[index]['icon'],
                                        menuColor: theme.primaryColorDark,
                                        iconColor: theme.primaryColorLight,
                                      ),
                                    )),
                              )),
                            ],
                          ),
                          SizedBox(height: height * 0.03),
                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: height * 0.4,
                                child: GridView.count(
                                    padding: EdgeInsets.zero,
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 2.5,
                                    children: List.generate(2, (index) {
                                      int cIndex = index + 2;
                                      return ItemStatus(
                                        status: statusList[cIndex]['status'],
                                        label: statusList[cIndex]['label'],
                                        icon: statusList[cIndex]['icon'],
                                        menuColor: theme.primaryColorDark,
                                        iconColor: theme.primaryColorLight,
                                      );
                                    })),
                              )),
                              const SizedBox(width: 20),
                              SizedBox(
                                  height: height * 0.45,
                                  width: width * 0.45,
                                  child: const ShopBarChart()),  ],
                          )
                        ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
