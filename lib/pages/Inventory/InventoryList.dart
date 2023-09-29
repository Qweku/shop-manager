// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/components/button.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/addproduct.dart';
import 'package:shop_manager/pages/productView.dart';
import 'package:shop_manager/pages/widgets/constants.dart';
import 'package:shop_manager/pages/widgets/productCard.dart';
import 'package:shop_manager/utils/firebase_functions.dart';

class InventoryList extends StatefulWidget {
  final bool isList;
  const InventoryList({Key? key, this.isList = false}) : super(key: key);

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<String>? imagePaths;
  FirebaseFunction firebaseFunction = FirebaseFunction();

  Product? product;
  String? imagePath;
  String query = "";

  bool isScrolled = false;
  int isSelected = 0;
  List<Product> productItems = [];

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? shopName;
  bool isLoading = true;
  refresh() async {
    var _duration = const Duration(seconds: 5);
    return Timer(_duration, cancelRefresh);
  }

  bool cancelRefresh() {
    setState(() {});
    return isLoading = true;
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
    var categories = context.watch<GeneralProvider>();

    return StreamBuilder<QuerySnapshot>(
        stream: firebaseFunction.getProducts(shopName!),
        builder: (context, snapshot) {
           if (snapshot.hasError) {
            return Center(
              child: Text(
                "An Error Occured while fetching data",
                style: headline1.copyWith(color: Colors.grey),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.01),
            child: GridView.builder(
                // shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: height * 0.01),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile() ? 3 : 4,
                    childAspectRatio: 2 / 3.5),
                itemCount: categories.inventory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: ProductCard(
                      //edit and delete action
                      onLongPress: () {
                        _bottomDrawSheet(context, categories.inventory[index]);
                      },
                      // add to cart button action
                      onPressed: () {
                        if (!(context
                            .read<GeneralProvider>()
                            .cart
                            .contains(categories.inventory[index]))) {
                          Provider.of<GeneralProvider>(context, listen: false)
                              .addToCart(categories.inventory[index]);
                        }
                      },

                      //view product details action
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductView(
                                    product: categories.inventory[index])));
                      },
                      index: index,
                      image64: categories.inventory[index].productImage ?? "",

                      productName: categories.inventory[index].productName,

                      quantity: categories.inventory[index].productQuantity
                          .toString(),

                      price:
                          "GHS ${categories.inventory[index].sellingPrice.toStringAsFixed(2)}",
                    ),
                  );
                }),
          );
        });
  }

  void _bottomDrawSheet(BuildContext context, Product product) {
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => AddProductScreen(
                                      toEdit: true,
                                      product: product,
                                    ))).then((value) {
                          setState(() {});
                          Navigator.pop(context);
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.edit, color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Edit', style: bodyText1)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<GeneralProvider>(context, listen: false)
                            .deleteProduct(product);

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.delete, color: primaryColorLight),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Remove', style: bodyText1)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
        });
  }
}
