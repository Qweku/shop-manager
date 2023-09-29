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
  void firebaseError(
    BuildContext context,
    Exception e,
  ) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(Icons.cancel,
                color: Color.fromARGB(255, 216, 30, 17), size: 50),

            // Text(
            //   "LOGIN ERROR",textAlign: TextAlign.center,
            //   style: TextStyle(fontWeight: FontWeight.bold,color:Color.fromARGB(255, 233, 22, 7), fontSize: 18),
            // ),
            content: Text("${(e as dynamic).message}"),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  child: Text("OK"))
            ],
          );
        });
  }

  Future fetchProducts(BuildContext context, String? shopName) async {
    try {
      QuerySnapshot data = await fireStore.collection(shopName ?? "").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
        // Check if incoming data does not exist
        if (!(Provider.of<GeneralProvider>(context, listen: false)
            .inventory
            .any((element) =>
                element.productName == snapshot["product name"]))) {
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

          Provider.of<GeneralProvider>(context, listen: false)
              .addProduct(products);
          await storage.setItem(
              shopName!,
              shopProductsToJson(
                  Provider.of<GeneralProvider>(context, listen: false).shop));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: const Color.fromARGB(255, 255, 17, 1),
                content: Text('Some of the products already exist',
                    textAlign: TextAlign.center, style: bodyText2),
                duration: const Duration(milliseconds: 1500),
                behavior: SnackBarBehavior.floating,
                shape: const StadiumBorder()),
          );
        }
      }
    } on FirebaseException catch (e) {
      firebaseError(context, e);
    }
  }

  Future updateProduct(BuildContext context, Product product,
      String productName, String shopName) async {
    await fireStore.collection(shopName).doc(productName).set(product.toJson());
    // try {
    //   DocumentReference data =
    //       fireStore.collection(shopName ?? "").doc(productName);
    //   data.update({
    //     'product id': product.pid,
    //     'product name': product.productName,
    //     'product description': product.productDescription,
    //     'product image': product.productImage,
    //     'selling price': product.sellingPrice,
    //     'cost price': product.costPrice,
    //     //'product category':product.productCategory,
    //     'product quantity': product.productQuantity,
    //     'low stock quantity': product.lowStockQuantity,
    //     'low stock': product.isLowStock,
    //   });
    // } on FirebaseException catch (e) {
    //   firebaseError(context, e);
    // }
  }

  Future addProducts(BuildContext context, Product product, String productName,
      String? shopName) async {
    String customId = productName;

    try {
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
        } else {
          await fireStore.collection(shopName ?? "").doc(customId).set({
            'product id': product.pid,
            'product name': product.productName,
            'product description': product.productDescription,
            'product image': product.productImage,
            'selling price': product.sellingPrice,
            'cost price': product.costPrice,
            'product quantity': product.productQuantity,
            'low stock quantity': product.lowStockQuantity,
            'low stock': product.isLowStock,
          });
        }
      }
    } on FirebaseException catch (e) {
      firebaseError(context, e);
    }
  }

  Future exportToSuggestions(
      BuildContext context, Product product, String productName) async {
    String customId = productName;
    try {
      QuerySnapshot data = await fireStore.collection("shopNow").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
        if (snapshot.exists) {
          //! Unhandled Exception: Bad state: field does not exist within the DocumentSnapshotPlatform
          if (snapshot["product name"] != productName) {
            await fireStore.collection("shopNow").doc(customId).set({
              'product id': product.pid,
              'product name': product.productName,
              'product description': product.productDescription,
              'product image': product.productImage,
              'selling price': product.sellingPrice,
              'cost price': product.costPrice,
              'product quantity': product.productQuantity,
              'low stock quantity': product.lowStockQuantity,
              'low stock': product.isLowStock,
            });
          } else {
            log("Document already exist.");
          }
        }
      }
    } on FirebaseException catch (e) {
      firebaseError(context, e);
    }
  }

  Stream<QuerySnapshot> getProducts(String shopName) {
    return fireStore.collection(shopName).snapshots();
  }
}
