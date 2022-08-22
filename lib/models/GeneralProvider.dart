// ignore_for_file: file_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shop_manager/models/ShopModel.dart';

class GeneralProvider extends ChangeNotifier {
  Shop _shop = Shop();
  ProductCategory _category = ProductCategory('Uncategorised');
  Product _product = Product();
  List<ProductCategory> _categories = [];
  List<Product> _inventory = [];
  List<Product> _cart = [];

  Shop get shop {
    _shop.productCategory = categories;
    return _shop;
  }

  Product get product => _product;
  ProductCategory get category => _category;
  List<Product> get inventory => _inventory;

  List<Product> get cart => _cart;
  List<ProductCategory> get categories => _categories;
  String _query = "";
  String get query => _query;

  set query(String query) {
    _query = query;
    notifyListeners();
  }

  set shop(Shop currentShop) {
    _shop = currentShop;
    notifyListeners();
  }

  set category(ProductCategory category) {
    _category = category;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set cart(List<Product> cart) {
    _cart = cart;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set inventory(List<Product> inventory) {
    _inventory = List.from(inventory);
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  set categories(List<ProductCategory> categories) {
    _categories = List.from(categories);
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

  void removeProductFromCategories(int cartegoryIndex, Product product) {
    categories[cartegoryIndex].products!.remove(product);
    notifyListeners();
  }

  void addToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void removeFromCategory(Product product) {
    category.products!.remove(product);
    notifyListeners();
  }

  void addToCategory(Product product) {
    category.products!.add(product);
    notifyListeners();
  }
}

class HiveFunctions {
  var productBox = Hive.box<Product>('Product');
  var categoryBox = Hive.box<ProductCategory>('Category');

  void saveToCategory(ProductCategory _selectedCategory) {
    categoryBox.values
        .firstWhere((element) => element == _selectedCategory)
        .products = HiveList(productBox);
    categoryBox.values
        .firstWhere((element) => element == _selectedCategory)
        .products!
        .addAll(productBox.values.where((value) =>
            value.itemcategory!.toLowerCase() ==
            _selectedCategory.categoryName.toLowerCase()));
    categoryBox.values
        .firstWhere((element) => element == _selectedCategory)
        .save();
    return;
  }
}
