// To parse this JSON data, do
//
//     final shopModel = shopModelFromMap(jsonString);

// ignore_for_file: unnecessary_null_in_if_null_operators, prefer_null_aware_operators

import 'dart:convert';
import 'package:hive/hive.dart';

part 'ShopModel.g.dart';

class ShopModel {
  ShopModel({
    this.shop,
  });

  Shop? shop;

  // factory ShopModel.fromJson(String str) => ShopModel.fromMap(json.decode(str));

  // factory ShopModel.fromMap(Map<String, dynamic> json) => ShopModel(
  //       shop: json["Shop"] == null ? null : Shop.fromMap(json["Shop"]),
  //     );

  Map<String, dynamic> toMap() => {
        "Shop": shop == null ? null : shop!.toMap(),
      };
}

class Shop {
  Shop({
    this.shopName,
    this.shopId,
    this.productCategory,
  });

  String? shopName;
  int? shopId;
  List<ProductCategory>? productCategory;

  // factory Shop.fromJson(String str) => Shop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  // factory Shop.fromMap(Map<String, dynamic> json) => Shop(
  //       shopName: json["shopName"],
  //       shopId: json["shopID"],
  //       productCategory: json["ProductCategory"] == null
  //           ? null
  //           : List<ProductCategory>.from(
  //               json["ProductCategory"].map((x) => ProductCategory.fromMap(x))),
  //     );

  Map<String, dynamic> toMap() => {
        "shopName": shopName,
        "shopID": shopId,
        "ProductCategory": productCategory == null
            ? null
            : List<dynamic>.from(productCategory!.map((x) => x.toMap())),
      };
}

@HiveType(typeId: 1)
class ProductCategory extends HiveObject {
  ProductCategory(
    this.categoryName, {
    this.categorydescription,
    this.categoryId,
    
  });
  @HiveField(0)
  String categoryName;
  @HiveField(1)
  String? categorydescription;
  @HiveField(2)
  int? categoryId;
  @HiveField(3)
  HiveList<Product>? products  ;

  Map<String, dynamic> toMap() => {
        "categoryName": categoryName,
        "categorydescription": categorydescription,
        "categoryID": categoryId,
        "Products": products == null
            ? null
            : List<dynamic>.from(products!.map((x) => x.toMap())),
      };
}

@HiveType(typeId: 0)
class Product extends HiveObject {
  Product({
    this.productName,
    this.sellingPrice,
    this.costPrice,
    this.imageb64,
    this.quantity,
    this.itemcategory = 'Uncategorised',
    this.cartQuantity = 1,
    this.productId,
  });

  @HiveField(0)
  String? productName;

  @HiveField(1)
  String? itemcategory;

  @HiveField(2)
  double? sellingPrice;

  @HiveField(3)
  double? costPrice;

  @HiveField(4)
  String? imageb64;

  @HiveField(5)
  int? quantity;

  @HiveField(6)
  int? cartQuantity;

  @HiveField(7)
  int? productId;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        productName: json["productName"],
        sellingPrice: json["sellingPrice"] == null
            ? null
            : json["sellingPrice"].toDouble(),
        costPrice:
            json["costPrice"] == null ? null : json["costPrice"].toDouble(),
        imageb64: json["imageb64"],
        quantity: json["quantity"],
        itemcategory: json['itemcategory'],
        cartQuantity: json["cartQuantity"],
        productId: json["productID"],
      );

  Map<String, dynamic> toMap() => {
        "productName": productName,
        "sellingPrice": sellingPrice,
        "costPrice": costPrice,
        "imageb64": imageb64,
        "itemcategory": itemcategory,
        "cartQuantity": cartQuantity,
        "quantity": quantity,
        "productID": productId,
      };
}
