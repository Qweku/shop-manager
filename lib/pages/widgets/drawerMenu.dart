// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/FirebaseApplicationState.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/notifications/notificationPlugin.dart';
import 'package:shop_manager/pages/settings.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? shopName;

  Future addProducts(BuildContext context) async {
    Provider.of<GeneralProvider>(context, listen: false)
        .inventory
        .forEach((element) async {
      QuerySnapshot data = await fireStore.collection(shopName ?? "").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
        if (snapshot.exists) {
          if (snapshot["product name"] != element.productName) {
            await fireStore
                .collection(shopName ?? "")
                .doc(element.productName)
                .set({
              'product id': element.pid,
              'product name': element.productName,
              'product description': element.productDescription,
              'product image': element.productImage,
              'selling price': element.sellingPrice,
              'cost price': element.costPrice,
              //'product category': element.productCategory,
              'product quantity': element.productQuantity,
              'low stock quantity': element.lowStockQuantity,
              'low stock': element.isLowStock,
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Color.fromARGB(255, 219, 16, 16),
                    content: Text('An error occurred, please try again',
                        textAlign: TextAlign.center, style: bodyText2),
                    duration: const Duration(milliseconds: 1500),
                    behavior: SnackBarBehavior.floating,
                    shape: const StadiumBorder()),
              );
            });
          } else {
            log("Something went wrong");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Color.fromARGB(255, 1, 156, 27),
                content: Text('Products Exported Successfully',
                    textAlign: TextAlign.center, style: bodyText2),
                duration: const Duration(milliseconds: 1500),
                behavior: SnackBarBehavior.floating,
                shape: const StadiumBorder()),
          );
        }
      }
    });
  }

  Future getShopName() async {
    shopName = auth.currentUser!.displayName;
  }

  @override
  void initState() {
    getShopName();
     NotiPlugin.initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: height * 0.3,
            child: DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  // backgroundColor: primaryColor,
                  radius: 30,
                  backgroundImage: AssetImage("assets/app_icon.png"),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  'ShopMate',
                  style: headline2,
                ),
              ]),
            ),
          ),
          DrawerItem(
            onTap: () {
              NotiPlugin.showNotification(
        title: "Low Stock",
        body: "Some products are running low on stock",
        fln: flutterLocalNotificationsPlugin);
            },
            text: 'Profile',
            icon: Icons.person,
          ),
          DrawerItem(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            text: 'Settings',
            icon: Icons.settings,
          ),
          DrawerItem(
            onTap: () => _backButton(context),
            text: 'Logout',
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  Future<File> downloadAttachment(
    BuildContext context,
  ) async {
    try {
      String dir = '';

      if (Platform.isAndroid) {
        dir = (await getExternalStorageDirectory())?.path ?? '';
      } else {
        dir = (await getDownloadsDirectory())?.path ?? '';
      }

      File file = File(
          "$dir/SHOPMATE_${context.read<GeneralProvider>().shop.shopname ?? 'demo'}_${DateTime.now().millisecondsSinceEpoch}.json");
      // log(file.path);
      file.writeAsString(
          shopProductsToJson(context.read<GeneralProvider>().shop));
      return file;
    } on Exception catch (e) {
      return File('');
      // log(e.toString());
    }
  }

  _backButton(context) {
    return showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: height * 0.13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_outlined,
                        size: 40, color: Color.fromARGB(255, 255, 38, 23)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Do you really want to logout?",
                      style: bodyText1,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      ApplicationState().signOut();
                      Navigator.pop(context);
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text("No"))
              ],
            ));
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const DrawerItem({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(text, style: bodyText1.copyWith(fontSize: 14)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: primaryColor,
          size: 15,
        ),
        onTap: onTap);
  }
}
