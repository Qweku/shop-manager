import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? shopName;

  Future addProducts(BuildContext context) async {
    Provider.of<GeneralProvider>(context, listen: false)
        .inventory
        .forEach((element) async {
      QuerySnapshot data = await fireStore.collection(shopName ?? "").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
                  log(snapshot.exists.toString());

        if (snapshot.exists) {
          log(snapshot.exists.toString());
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

  Future fetchProducts(BuildContext context) async {
    QuerySnapshot data =
        await fireStore.collection(shopName ?? "").get().catchError((e) {
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

    for (QueryDocumentSnapshot snapshot in data.docs) {
      log(snapshot.exists.toString());
      Product products = Product(
          pid: snapshot["product id"],
          productName: snapshot["product name"],
          productDescription: snapshot["product description"],
          productImage: snapshot["product image"],
          sellingPrice: snapshot["selling price"],
          costPrice: snapshot["cost price"],
          //productCategory: snapshot["product category"],
          productQuantity: snapshot["product quantity"],
          lowStockQuantity: snapshot["low stock quantity"],
          isLowStock: snapshot["low stock"]);
      Provider.of<GeneralProvider>(context, listen: false).addProduct(products);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Color.fromARGB(255, 1, 156, 27),
          content: Text('Products imported successfully',
              textAlign: TextAlign.center, style: bodyText2),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder()),
    );
  }

  void showBanner(int indx) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text(indx == 0 ? 'Syncing' : "Exporting data", style: bodyText2),
      //leading: const CircularProgressIndicator(color: Colors.white),
      backgroundColor: primaryColor,
      actions: [
        const CircularProgressIndicator(color: Colors.white),
      ],
    ));
  }

  refresh() async {
    var _duration = const Duration(seconds: 5);
    return Timer(_duration, cancelRefresh);
  }

  void cancelRefresh() {
    return ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  Future getShopName() async {
    shopName = auth.currentUser!.displayName;
  }

  @override
  void initState() {
    getShopName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: primaryColorLight,
                radius: width * 0.12,
                backgroundImage: AssetImage("assets/app_icon.png"),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "ShopMate",
                  style: headline1,
                )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Settings", style: headline1),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: width * 0.85),
              child: Divider(thickness: 3, color: actionColor),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: List.generate(
                  settings.length,
                  (index) => Column(
                    children: [
                      ListTile(
                        onTap: () {
                          if (index == 0) {
                            fetchProducts(context);
                            showBanner(0);
                            refresh();
                          } else if (index == 1) {
                            addProducts(context);
                            showBanner(1);
                            refresh();
                          } else {
                            return null;
                          }
                        },
                        leading:
                            Icon(settings[index]["icon"], color: primaryColor),
                        title: Text(settings[index]["title"],
                            style: bodyText1.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          settings[index]["subtitle"],
                          style: bodyText1,
                        ),
                      ),
                      Divider(
                          height: height * 0.01,
                          color: Color.fromARGB(255, 228, 228, 228)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> settings = [
    {
      "title": "Import Shop Data",
      "subtitle": "Inventory stocks",
      "icon": Icons.save_alt,
    },
    {
      "title": "Export Shop Data",
      "subtitle": "Store in cloud as backup",
      "icon": Icons.cloud_upload
    },
    {
      "title": "About",
      "subtitle": "Details about ShopMate",
      "icon": Icons.help_outline_rounded
    },
    // {
    //   "title": "Terms of service",
    //   "subtitle": "Read our terms of service",
    //   "icon": Icons.notes
    // },
    // {
    //   "title": "Privacy policy",
    //   "subtitle": "Read our policy",
    //   "icon": Icons.lock_outline
    // },
    // {
    //   "title": "Customer service",
    //   "subtitle": "Contact us for help",
    //   "icon": Icons.support_agent_outlined
    // },
    // {
    //   "title": "Logout",
    //   "subtitle": "Sign out from the account",
    //   "icon": Icons.settings_power
    // },
  ];
}
