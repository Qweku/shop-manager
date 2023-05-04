import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class FirebaseFunction {
  LocalStorage storage = LocalStorage('shop_mate');
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future fetchProducts(BuildContext context, String? shopName) async {
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
      await storage.setItem(
          shopName!,
          shopProductsToJson(
              Provider.of<GeneralProvider>(context, listen: false).shop));
    }
  }

  Future updateProduct(BuildContext context, Product product,
      String productName, String? shopName) async {
    DocumentReference data =
        fireStore.collection(shopName ?? "").doc(productName);
    data.update({
      'product id': product.pid,
      'product name': product.productName,
      'product description': product.productDescription,
      'product image': product.productImage,
      'selling price': product.sellingPrice,
      'cost price': product.costPrice,
      //'product category':product.productCategory,
      'product quantity': product.productQuantity,
      'low stock quantity': product.lowStockQuantity,
      'low stock': product.isLowStock,
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
  }

  Future addProducts(
      Product product, String productName, String? shopName) async {
    String customId = productName;

    QuerySnapshot data = await fireStore.collection(shopName ?? "").get();

    for (QueryDocumentSnapshot snapshot in data.docs) {
      if (snapshot.exists) {
        //! Unhandled Exception: Bad state: field does not exist within the DocumentSnapshotPlatform
        if (snapshot["product name"] != productName) {
          await fireStore.collection(shopName ?? "").doc(customId).set({
            'product id': product.pid,
            'product name': product.productName,
            'product description': product.productDescription,
            'product image': product.productImage,
            'selling price': product.sellingPrice,
            'cost price': product.costPrice,
           // 'product category': product.productCategory,
            'product quantity': product.productQuantity,
            'low stock quantity': product.lowStockQuantity,
            'low stock': product.isLowStock,
          });
        } else {
          log("Document already exist.");
        }
      }
    }
  }
}
