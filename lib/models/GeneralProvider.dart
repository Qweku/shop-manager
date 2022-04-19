// ignore_for_file: file_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shop_manager/models/ShopModel.dart';

class GeneralProvider extends ChangeNotifier {
  ProductCategory _category = ProductCategory();
  ProductCategory _modelCategory = ProductCategory();
  Product _product = Product();
  Product _modelProduct = Product();
  Shop _shop = Shop();

  List<Product> _inventory = [];
  List<Product> _cart = [];
  List<Product> _modelInventory = [];
  List<ProductCategory>? _categories = [];
  bool _categorised = false;

  Shop get shop {
    // debugPrint(categories!.first.categoryName);
    _shop.productCategory = categories;

    return _shop;
  }

  Product get product => _product;
  ProductCategory get category => _category;
  List<Product> get inventory {
    _inventory.clear();
    for (var element in categories!) {
      _inventory.addAll(element.products!);
    }
    return _inventory;
  }

  Product get modelProduct => _modelProduct;
  ProductCategory get modelCategory {
    _modelCategory.products = modelInventory;
    return _modelCategory;
  }

  List<Product> get modelInventory => _modelInventory;
  List<Product> get cart => _cart;
  List<ProductCategory>? get categories => _categories;
  bool get categorised => _categorised;

  set categorised(bool isCated) {
    _categorised = isCated;
    notifyListeners();
  }

  set shop(Shop currentShop) {
    _shop = currentShop;
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

  set cart(List<Product> cart) {
    _cart = cart;
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

  void removeProductFromCategories(int cartegoryIndex,Product product) {
    categories![cartegoryIndex].products!.remove(product);
    notifyListeners();
  }
  
  void addToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    cart.remove(product);
    notifyListeners();
  }

  void loadCategory() {}
}
