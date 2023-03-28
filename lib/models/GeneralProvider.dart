// ignore_for_file: file_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/localStore.dart';

LocalStore storage = LocalStore();

class GeneralProvider extends ChangeNotifier {
  ShopProducts _shop =
      ShopProducts(id: 0, shopname: 'demo', products: [], sales: [], expenses: [], lowStocks: []);
  ProductCategory _category = ProductCategory(cid: -1);
  Product _product = Product(pid: -1);

  List<ProductCategory> _categories = [];
  List<Product> _inventory = [];
  List<Product> _lowStocks = [];
  List<Product> _cart = [];
  double _subTotal = 0;
  double get subTotal => _subTotal;

  ShopProducts get shop => _shop;

  Product get product => _product;
  ProductCategory get category => _category;
  List<Product> get inventory => _inventory;
  List<Product> get lowStocks => _lowStocks;

  List<Product> get cart => _cart;
  List<ProductCategory> get categories => _categories;
  String _query = "";
  String get query => _query;

  set query(String query) {
    _query = query;
    notifyListeners();
  }

  set shop(ShopProducts currentShop) {
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

    // notifyListeners();
  }
set lowStocks(List<Product> lowStocks) {
    _lowStocks = List.from(lowStocks);

    // notifyListeners();
  }

  set categories(List<ProductCategory> categories) {
    _categories = List.from(categories);

    // notifyListeners();
  }

  set product(Product product) {
    _product = product;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  Future<void> saveToShop(List<Product> products) async {
    _shop.products = products;
    // notifyListeners();
    storage.store(_shop.shopname ?? 'demo', shopProductsToJson(_shop));
  }

  void addToCart(Product product) {
    if (product.productQuantity < 1) {
      return;
    }
    if (product.cartQuantity < 1) {
      product.cartQuantity = 1;
    }
    Product cartProduct = product.copyWith();
    cart.add(cartProduct);
    notifyListeners();
  }

  bool addCategory(ProductCategory newCategory) {
    if (_categories.any((element) =>
        element.categoryName!.toLowerCase() ==
        newCategory.categoryName!.toLowerCase())) {
      return false;
    }
    _categories.add(newCategory);
    notifyListeners();
    return true;
  }

  bool editCategory(ProductCategory newCategory) {
    if (!_categories.any((element) => element.cid == newCategory.cid)) {
      return false;
    }
    _categories.any((element) {
      if (element.cid == newCategory.cid) {
        element.categoryName = newCategory.categoryName;
        element.categoryDescription = newCategory.categoryDescription;
        for (var elements in _inventory) {
          if (elements.productCategory!.cid == newCategory.cid) {
            elements.productCategory = newCategory;
          }
        }
      }
      return true;
    });
    notifyListeners();
    //saveToShop(_inventory);
    return true;
  }

  void removeFromCart(int index) {
    cart[index].cartQuantity = 0;
    cart.removeAt(index);
    notifyListeners();
  }

  void processCart() {
    for (var cartItem in cart) {
      _inventory.singleWhere((element) => element.pid == cartItem.pid)
        ..productQuantity -= cartItem.cartQuantity
        ..cartQuantity = 0;
    }
    //saveToShop(_inventory);
    notifyListeners();
  }

  void removeFromCategory(Product product) {
    _inventory.singleWhere((element) => element == product).productCategory =
        ProductCategory(cid: 0);
    //saveToShop(_inventory);
    notifyListeners();
  }

  void updateCart(Product product) {
    for (Product element in _cart) {
      if (element.pid == product.pid) {
        element.cartQuantity = product.cartQuantity;
      }
    }
    notifyListeners();
  }

  void total(Product product) {
    double total = 0;
    for (Product item in _cart) {
      if (item.pid == product.pid) {
        total = total + ((item.sellingPrice) * (item.productQuantity));
        item.cartQuantity = product.cartQuantity;
      }
    }
    _subTotal = total;
    notifyListeners();
  }

  void addLowStock(Product product) {
    _lowStocks.add(product);

    notifyListeners();
  }

  void removeLowStock(Product product) {
    _lowStocks.remove(product);
    notifyListeners();
  }

  void deleteProduct(Product product) {
    _inventory.remove(product);
    notifyListeners();
    //saveToShop(_inventory);
  }

  void addProduct(Product product) {
    _inventory.add(product);
    notifyListeners();
   // saveToShop(_inventory);
  }

  void editProduct(Product product) {
    _inventory.singleWhere((element) => element.pid == product.pid)
      ..productCategory = product.productCategory
      ..productImage = product.productImage
      ..productName = product.productName
      ..productQuantity = product.productQuantity
      ..sellingPrice = product.sellingPrice
      ..costPrice = product.costPrice;
    notifyListeners();
    //saveToShop(_inventory);
  }

//   var productBox = Hive.box<Product>('Product');
//   var categoryBox = Hive.box<ProductCategory>('Category');

//   void saveToCategory(ProductCategory selectedCategory) {
//     categories.singleWhere(
//         (element) => element.categoryName == selectedCategory.categoryName)
//       ..products = HiveList(productBox)
//       //     ;
//       // categories
//       //     .singleWhere((element) => element == selectedCategory)
//       ..products!.addAll(productBox.values.where((value) =>
//           value.itemcategory!.toLowerCase() ==
//           selectedCategory.categoryName.toLowerCase()));
//   }

//   void reArrangeCategory() {
//     for (var category in categories) {
//       saveToCategory(category);
//     }
//     return;
//   }
// }

// class HiveFunctions {
//   var productBox = Hive.box<Product>('Product');
//   var categoryBox = Hive.box<ProductCategory>('Category');

//   void saveToCategory(ProductCategory _selectedCategory) {
//     categoryBox.values.firstWhere(
//         (element) => element.categoryName == _selectedCategory.categoryName)
//       ..products = HiveList(productBox)
//       //     ;
//       // categoryBox.values
//       //     .firstWhere((element) => element.categoryName == _selectedCategory.categoryName)
//       ..products!.addAll(productBox.values.where((value) =>
//           value.itemcategory!.toLowerCase() ==
//           _selectedCategory.categoryName.toLowerCase()))
//       // ;
//       // categoryBox.values
//       //     .firstWhere((element) => element == _selectedCategory)
//       ..save();
//     return;
//   }

//   void reArrangeCategory() {
//     for (var category in categoryBox.values) {
//       saveToCategory(category);
//     }
//     return;
//   }
// }
}
