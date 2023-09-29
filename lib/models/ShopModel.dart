// To parse this JSON data, do
//
//     final shopModel = shopModelFromMap(jsonString);

// ignore_for_file: unnecessary_null_in_if_null_operators, prefer_null_aware_operators

import 'dart:convert';
// import 'package:hive/hive.dart';

// // part 'ShopModel.g.dart';

// class ShopModel {
//   ShopModel({
//     this.shop,
//   });

//   Shop? shop;

//   // factory ShopModel.fromJson(String str) => ShopModel.fromMap(json.decode(str));

//   // factory ShopModel.fromMap(Map<String, dynamic> json) => ShopModel(
//   //       shop: json["Shop"] == null ? null : Shop.fromMap(json["Shop"]),
//   //     );

//   Map<String, dynamic> toMap() => {
//         "Shop": shop == null ? null : shop!.toMap(),
//       };
// }

// class Shop {
//   Shop({
//     this.shopName,
//     this.shopId,
//     this.productCategory,
//   });

//   String? shopName;
//   int? shopId;
//   List<ProductCategory>? productCategory;

//   // factory Shop.fromJson(String str) => Shop.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   // factory Shop.fromMap(Map<String, dynamic> json) => Shop(
//   //       shopName: json["shopName"],
//   //       shopId: json["shopID"],
//   //       productCategory: json["ProductCategory"] == null
//   //           ? null
//   //           : List<ProductCategory>.from(
//   //               json["ProductCategory"].map((x) => ProductCategory.fromMap(x))),
//   //     );

//   Map<String, dynamic> toMap() => {
//         "shopName": shopName,
//         "shopID": shopId,
//         "ProductCategory": productCategory == null
//             ? null
//             : List<dynamic>.from(productCategory!.map((x) => x.toMap())),
//       };
// }

// // @HiveType(typeId: 1)
// class ProductCategory /* extends HiveObject */ {
//   ProductCategory(
//     this.categoryName, {
//     this.categorydescription,
//     this.categoryId,

//   });
//   // @HiveField(0)
//   String categoryName;
//   // @HiveField(1)
//   String? categorydescription;
//   // @HiveField(2)
//   int? categoryId;
//   // @HiveField(3)
//  /*  Hive */List<Product>? products  ;

//   Map<String, dynamic> toMap() => {
//         "categoryName": categoryName,
//         "categorydescription": categorydescription,
//         "categoryID": categoryId,
//         "Products": products == null
//             ? null
//             : List<dynamic>.from(products!.map((x) => x.toMap())),
//       };
// }

// // @HiveType(typeId: 0)
// class Product /* extends HiveObject  */{
//   Product({
//     this.productName,
//     this.sellingPrice,
//     this.costPrice,
//     this.imageb64,
//     this.quantity,
//     this.itemcategory = 'Uncategorised',
//     this.cartQuantity = 1,
//     this.productId,
//   });

//   // @HiveField(0)
//   String? productName;

//   // @HiveField(1)
//   String? itemcategory;

//   // @HiveField(2)
//   double? sellingPrice;

//   // @HiveField(3)
//   double? costPrice;

//   // @HiveField(4)
//   String? imageb64;

//   // @HiveField(5)
//   int? quantity;

//   // @HiveField(6)
//   int? cartQuantity;

//   // @HiveField(7)
//   int? productId;

//   factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory Product.fromMap(Map<String, dynamic> json) => Product(
//         productName: json["productName"],
//         sellingPrice: json["sellingPrice"] == null
//             ? null
//             : json["sellingPrice"].toDouble(),
//         costPrice:
//             json["costPrice"] == null ? null : json["costPrice"].toDouble(),
//         imageb64: json["imageb64"],
//         quantity: json["quantity"],
//         itemcategory: json['itemcategory'],
//         cartQuantity: json["cartQuantity"],
//         productId: json["productID"],
//       );

//   Map<String, dynamic> toMap() => {
//         "productName": productName,
//         "sellingPrice": sellingPrice,
//         "costPrice": costPrice,
//         "imageb64": imageb64,
//         "itemcategory": itemcategory,
//         "cartQuantity": cartQuantity,
//         "quantity": quantity,
//         "productID": productId,
//       };
// }

ShopProducts shopProductsFromJson(String str) {
   final jsonData = json.decode(str);
  return ShopProducts.fromJson(jsonData);
}

String shopProductsToJson(ShopProducts data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ShopProducts {
  int id;
  String? shopname;
  List<Product> products;
  List<SalesModel> sales;
  List<ExpenseModel> expenses;
  List<Product> lowStocks;

  ShopProducts({
    required this.id,
    this.shopname = 'demo',
    required this.products,
    required this.sales,
    required this.expenses,
    required this.lowStocks,
  });

  factory ShopProducts.fromJson(Map<String, dynamic> json) => ShopProducts(
        id: json["id"],
        shopname: json["shopname"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        sales: List<SalesModel>.from(
            (json["sales"] ?? []).map((x) => SalesModel.fromJson(x))),
        expenses: List<ExpenseModel>.from(
            (json["expenses"] ?? []).map((x) => ExpenseModel.fromJson(x))),
        lowStocks: List<Product>.from(
            (json["lowStocks"] ?? []).map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shopname": shopname,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
        "expenses": List<dynamic>.from(expenses.map((x) => x.toJson())),
        "lowStocks": List<dynamic>.from(lowStocks.map((x) => x.toJson())),
      };
}

class Product {
  String pid;
  String? productName;
  double sellingPrice;
  double costPrice;
  String? productImage;
  int productQuantity;
  int lowStockQuantity;
  String? productDescription;
  int cartQuantity;
  bool isLowStock;
  // ProductCategory? productCategory = ProductCategory(
  //     cid: 0,
  //     categoryName: 'Uncategorised',
  //     categoryDescription: 'No Description');

  Product({
    required this.pid,
    this.productName,
    this.sellingPrice = 0.0,
    this.costPrice = 0.0,
    this.productImage,
    this.productDescription,
    this.productQuantity = 0,
    this.lowStockQuantity = 0,
    this.cartQuantity = 0,
    //this.productCategory,
    this.isLowStock = false,
  });

  Product copyWith(
          {String? pid,
          String? productName,
          double? sellingPrice,
          double? costPrice,
          String? productImage,
          int? productQuantity,
          int? lowStockQuantity,
          String? productDescription,
          int? cartQuantity,
          bool? isLowStock}) =>
      Product(
          pid: pid ?? this.pid,
          productName: productName ?? this.productName,
          sellingPrice: sellingPrice ?? this.sellingPrice,
          costPrice: costPrice ?? this.costPrice,
          productImage: productImage ?? this.productImage,
          productDescription: productDescription ?? this.productDescription,
          productQuantity: productQuantity ?? this.productQuantity,
          lowStockQuantity: lowStockQuantity ?? this.lowStockQuantity,
          cartQuantity: cartQuantity ?? this.cartQuantity,
         // productCategory: productCategory ?? this.productCategory,
          isLowStock: isLowStock ?? this.isLowStock);

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        pid: json["pid"],
        productName: json["productName"],
        sellingPrice: json["sellingPrice"].toDouble(),
        costPrice: json["costPrice"].toDouble(),
        productImage: json["productImage"],
        productDescription: json["productDescription"],
        productQuantity: json["productQuantity"],
        lowStockQuantity: json["lowStockQuantity"] ?? 0,
        cartQuantity: json["cartQuantity"] ?? 0,
        isLowStock: json["isLowStock"] ?? false,
        // productCategory: json["productCategory"] == null
        //     ? ProductCategory()
        //     : ProductCategory.fromJson(json["productCategory"]),
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "productName": productName,
        "sellingPrice": sellingPrice,
        "costPrice": costPrice,
        "productImage": productImage,
        "productDescription": productDescription,
        "productQuantity": productQuantity,
        "lowStockQuantity": lowStockQuantity,
        "cartQuantity": cartQuantity,
        "isLowStock": isLowStock,
       // "productCategory": productCategory?.toJson() ?? ProductCategory().toJson(),
      };
}

// class ProductCategory {
//   int? cid;
//   String? categoryName;
//   String? categoryDescription;

//   ProductCategory({
//     this.cid = 0,
//     /* required */ this.categoryName = 'Uncategorised',
//     this.categoryDescription = 'No Description',
//   });

//   factory ProductCategory.fromJson(Map<String, dynamic> json) =>
//       ProductCategory(
//         cid: json["cid"],
//         categoryName: json["category_name"],
//         categoryDescription: json["category_description"],
//       );

//   Map<String, dynamic> toJson() => {
//         "cid": cid,
//         "category_name": categoryName,
//         "category_description": categoryDescription,
//       };
// }

class SalesModel {
  SalesModel({
    this.accId,
    this.date,
    this.isOnCredit = false,
    required this.products,
  });
  int? accId;
  String? date;
  bool isOnCredit;

  List<Product> products;

  SalesModel copyWith({
    int? accId,
    String? date,
    List<Product>? products,
  }) =>
      SalesModel(
        accId: accId ?? this.accId,
        date: date ?? this.date,
        products: products ?? this.products,
      );

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        accId: json["accId"],
        date: json["date"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "accId": accId,
        "date": date,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ExpenseModel {
  int? id;
  String itemName;
  String? date;
  double price;

  ExpenseModel({
    this.id = 0,
    required this.itemName,
    this.date,
    this.price = 0.0,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        itemName: json["item_name"],
        date: json["date"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "date": date,
        "price": price,
      };
}
