// To parse this JSON data, do
//
//     final shopModel = shopModelFromMap(jsonString);

// ignore_for_file: unnecessary_null_in_if_null_operators, prefer_null_aware_operators

import 'dart:convert';

class ShopModel {
  ShopModel({
    this.shop,
  });

  Shop? shop;

  factory ShopModel.fromJson(String str) => ShopModel.fromMap(json.decode(str));

  factory ShopModel.fromMap(Map<String, dynamic> json) => ShopModel(
        shop: json["Shop"] == null ? null : Shop.fromMap(json["Shop"]),
      );

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

  factory Shop.fromJson(String str) => Shop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Shop.fromMap(Map<String, dynamic> json) => Shop(
        shopName: json["shopName"],
        shopId: json["shopID"],
        productCategory: json["ProductCategory"] == null
            ? null
            : List<ProductCategory>.from(
                json["ProductCategory"].map((x) => ProductCategory.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "shopName": shopName,
        "shopID": shopId,
        "ProductCategory": productCategory == null
            ? null
            : List<dynamic>.from(productCategory!.map((x) => x.toMap())),
      };
}

class ProductCategory {
  ProductCategory({
    this.categoryName = 'Uncategorised',
    this.categorydescription,
    this.categoryId,
    this.products,
  });

  String? categoryName;
  String? categorydescription;
  int? categoryId;
  List<Product>? products;

  factory ProductCategory.fromJson(String str) =>
      ProductCategory.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory ProductCategory.fromMap(Map<String, dynamic> json) => ProductCategory(
        categoryName: json["categoryName"],
        categorydescription: json["categorydescription"],
        categoryId: json["categoryID"],
        products: json["Products"] == null
            ? null
            : List<Product>.from(
                json["Products"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "categoryName": categoryName,
        "categorydescription": categorydescription,
        "categoryID": categoryId,
        "Products": products == null
            ? null
            : List<dynamic>.from(products!.map((x) => x.toMap())),
      };
}

class Product {
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

  String? productName;
  String? itemcategory;
  double? sellingPrice;
  double? costPrice;
  String? imageb64;
  int? quantity;
  int? cartQuantity;
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
