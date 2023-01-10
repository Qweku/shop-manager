import 'package:flutter/material.dart';
import 'package:shop_manager/components/notificationButton.dart';
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
      // backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Row(
          children: [
            const SideMenu(),
            //SizedBox(width: width*0.05,),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const NotificationIconButton(quantity: 1),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            IconButton(
                              onPressed: (){},
                              icon: Icon(
                                Icons.account_circle_outlined,
                                size: 35,
                                color: primaryColor,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.03),
                        Expanded(
                          // height: height*0.8,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            //shrinkWrap: true,
                            children: [
                              GridView.count(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.8,
                                  children: List.generate(
                                    statusList.length,
                                    (index) => ItemStatus(
                                      status: statusList[index]['status'],
                                      label: statusList[index]['label'],
                                      icon: statusList[index]['icon'],
                                      menuColor: theme.primaryColor,
                                      iconColor: theme.primaryColorLight,
                                    ),
                                  )),
                              SizedBox(height: height * 0.03),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                          //height: height * 0.4,
                                          width: width * 0.45,
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              //height: height * 0.25,
                                              width: width,
                                              decoration: BoxDecoration(
                                                  color: Responsive.isMobile()
                                                      ? theme.primaryColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        offset: Offset(0, 1),
                                                        color: Color.fromARGB(
                                                            255, 219, 219, 233),
                                                        blurRadius: 2,
                                                        spreadRadius: 1),
                                                  ]),
                                              child: const ItemGraph())),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                          height: height * 0.4,
                                          width: width * 0.45,
                                          child: const ShopBarChart()),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        // height: height * 0.7,
                                        decoration: BoxDecoration(
                                            color: Responsive.isMobile()
                                                ? theme.primaryColor
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                  offset: Offset(0, 1),
                                                  color: Color.fromARGB(
                                                      255, 239, 240, 245),
                                                  blurRadius: 2,
                                                  spreadRadius: 1),
                                            ]),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Top Products',
                                              style: theme.textTheme.headline1,
                                            ),
                                            Divider(
                                                height: height * 0.05,
                                                color: Colors.grey),
                                            ListView(
                                              shrinkWrap: true,
                                              children: List.generate(
                                                 7,
                                                  (index) =>  Padding(
                                                        padding: const EdgeInsets.only(
                                                            bottom: 10),
                                                        child: ListTile(
                                                            leading: const CircleAvatar(
                                                          backgroundColor:
                                                              Color.fromARGB(255, 228, 228, 228),
                                                          child: Icon(
                                                            Icons.shopping_bag,
                                                            size: 17,
                                                            color: Colors.blueGrey,
                                                          ),
                                                        ),
                                                        title: Text('Product Name',style: theme.textTheme.bodyText1,),
                                                        subtitle: Text('30 sold out',style: theme.textTheme.bodyText1!.copyWith(fontSize:14,color:Colors.grey),),
                                                        trailing:  Text('GHS 350.00',style: theme.textTheme.bodyText1!.copyWith(fontSize:15),),
                                                        ),
                                                      )),
                                            )
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
