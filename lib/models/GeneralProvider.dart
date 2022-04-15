// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:shop_manager/models/LocalStorageAccess.dart';
import 'package:shop_manager/models/ShopModel.dart';

class GeneralProvider extends ChangeNotifier {
  ProductCategory _category = ProductCategory();
  ProductCategory _modelCategory = ProductCategory();
  Product _product = Product();
  Product _modelProduct = Product();

  final List<Product> _inventory = [];
  List<Product> _categoryinventory = [];
  List<Product> _modelInventory = [];
  List<ProductCategory>? _categories = [
    ProductCategory(categoryName: "Milo", products: [])
  ];
  bool _categorised = false;

  Product get product => _product;
  ProductCategory get category => _category;
  List<Product> get inventory {
    _inventory.clear();
    categories!.forEach((element) {
      _inventory.addAll(element.products!);
    });
    return _inventory;
  }

  Product get modelProduct => _modelProduct;
  ProductCategory get modelCategory {
    _modelCategory.products = modelInventory;
    return _modelCategory;
  }

  List<Product> get modelInventory => _modelInventory;
  List<Product> get categoryInventory => _categoryinventory;
  List<ProductCategory>? get categories => _categories;
  bool get categorised => _categorised;

  set categorised(bool isCated) {
    _categorised = isCated;
    notifyListeners();
  }

  set modelCategory(ProductCategory modelCategory) {
    _modelCategory = modelCategory;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set modelInventory(List<Product> modelInventory) {
    _modelInventory = modelInventory;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set category(ProductCategory category) {
    _category = category;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  // set inventory(List<Product> inventory) {
  //   _inventory = inventory;
  //   // Notify listeners, in case the new catalog provides information
  //   // different from the previous one. For example, availability of an item
  //   // might have changed.
  //   notifyListeners();
  // }

  set categoryInventory(List<Product> categoryInventory) {
    _categoryinventory = categoryInventory;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set categories(List<ProductCategory>? categories) {
    _categories = categories;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set product(Product product) {
    _product = product;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set modelProduct(Product modelProduct) {
    _modelProduct = modelProduct;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  void addCategory(String categoryname) {
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
    Stores().updateModel();
  }

  void loadCategory() {}
}
