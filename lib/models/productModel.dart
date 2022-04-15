// To parse this JSON data, do
//
//     final productModel = productModelFromMap(jsonString);

import 'dart:convert';

class ProductModel {
  ProductModel({
    this.productCategory,
  });

  ProductCategory? productCategory;

  factory ProductModel.fromJson(String str) =>
      ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
        productCategory: json["ProductCategory"] == null
            ? null
            : ProductCategory.fromMap(json["ProductCategory"]),
      );

  Map<String, dynamic> toMap() => {
        "ProductCategory":
            productCategory == null ? null : productCategory!.toMap(),
      };
}

class ProductCategory {
  ProductCategory({
    this.categoryName,
    this.categorydescription,
    this.categoryId,
    this.products,
  });

  String? categoryName;
  String? categorydescription;
  int? categoryId;
  List<Product>? products;

  // @override
  // int get hashCode => id;

  factory ProductCategory.fromJson(String str) =>
      ProductCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductCategory.fromMap(Map<String, dynamic> json) => ProductCategory(
        categoryName:
            json["categoryName"] == null ? null : json["categoryName"],
        categorydescription: json["categorydescription"] == null
            ? null
            : json["categorydescription"],
        categoryId: json["categoryID"] == null ? null : json["categoryID"],
        products: json["Products"] == null
            ? null
            : List<Product>.from(
                json["Products"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "categoryName": categoryName == null ? null : categoryName,
        "categorydescription":
            categorydescription == null ? null : categorydescription,
        "categoryID": categoryId == null ? null : categoryId,
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
    this.productId,
  });

  String? productName;
  double? sellingPrice;
  double? costPrice;
  String? imageb64;
  int? quantity;
  int? productId;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        productName: json["productName"] == null ? null : json["productName"],
        sellingPrice: json["sellingPrice"] == null
            ? null
            : json["sellingPrice"].toDouble(),
        costPrice:
            json["costPrice"] == null ? null : json["costPrice"].toDouble(),
        imageb64: json["imageb64"] == null ? null : json["imageb64"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        productId: json["productID"] == null ? null : json["productID"],
      );

  Map<String, dynamic> toMap() => {
        "productName": productName == null ? null : productName,
        "sellingPrice": sellingPrice == null ? null : sellingPrice,
        "costPrice": costPrice == null ? null : costPrice,
        "imageb64": imageb64 == null ? null : imageb64,
        "quantity": quantity == null ? null : quantity,
        "productID": productId == null ? null : productId,
      };
}
