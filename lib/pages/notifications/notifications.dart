import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/NotificationProvider.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

import 'notificationPlugin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const String routeName = '/notificationScreen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        centerTitle: true,
        elevation: 0,
        title: Text('Notifications', style: headline1.copyWith(fontSize: 18)),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
          child: SizedBox(
              height: height,
              child: context.watch<NotificationProvider>().notiList.isEmpty
                  ? Center(
                      child: Text(
                        'No Notifications',
                        style: headline1,
                      ),
                    )
                  : SingleChildScrollView(
                      //controller: controller,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                            context
                                .watch<NotificationProvider>()
                                .notiList
                                .length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white),
                                      color: primaryColorLight.withOpacity(0.3),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        context
                                            .read<NotificationProvider>()
                                            .notiList[index]
                                            .isRead = true;

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (builder) =>
                                                        AddProductScreen(
                                                          toEdit: true,
                                                          product: context
                                                              .read<
                                                                  GeneralProvider>()
                                                              .inventory
                                                              .singleWhere((element) =>
                                                                  (element.productName ??
                                                                          '')
                                                                      .toUpperCase() ==
                                                                  (context.read<NotificationProvider>().notiList[index].body ??
                                                                          '')
                                                                      .split(
                                                                          'is')
                                                                      .first
                                                                      .trim()),
                                                        ))).then((value) {
                                          setState(() {});
                                          Navigator.pop(context);
                                        });

                                        return;
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.notifications,
                                          color: primaryColor,
                                        ),
                                      ),
                                      title: Text(
                                        context
                                            .read<NotificationProvider>()
                                            .notiList[index]
                                            .title!,
                                        style: bodyText1.copyWith(
                                            color: primaryColor, fontSize: 17),
                                      ),
                                      subtitle: Text(
                                          context
                                              .read<NotificationProvider>()
                                              .notiList[index]
                                              .body!,
                                          style: bodyText1),
                                    )),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      context
                                          .watch<NotificationProvider>()
                                          .notiList[index]
                                          .date!,
                                      style: bodyText1.copyWith(
                                          color:
                                              Color.fromARGB(255, 56, 56, 56)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Icon(Icons.circle,
                                          color:
                                              Color.fromARGB(255, 56, 56, 56),
                                          size: 10),
                                    ),
                                    Text(
                                      context
                                          .watch<NotificationProvider>()
                                          .notiList[index]
                                          .time!,
                                      style: bodyText1.copyWith(
                                          color:
                                              Color.fromARGB(255, 56, 56, 56)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                            //reverse: true,

                            ),
                      ),
                    ))),
    );
  }

  // onNotificationLower(ReceivedNotification receivedNotification) {}
  // onNotificationClick(String payload) {
  //   // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //   //   return NotificationScreen();
  //   // }));
  // }
}
