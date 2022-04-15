import 'dart:async';
import 'dart:math';

import 'package:shop_manager/models/GeneralProvider.dart';
import 'package:shop_manager/models/SharedPreferences.dart';
import 'package:shop_manager/models/ShopModel.dart';
import 'package:shop_manager/models/services.dart';

Storage storage = new Storage();

class Fetches {
  fetchLists() async {
    String fullShop = await (storage.retrieveString(Auth().username!) as FutureOr<String>);

    if (fullShop.isEmpty) {
      return Status.empty;
    }

    Shop registered = Shop.fromJson(fullShop);

    //Get stored list of categories
    GeneralProvider().categories = registered.productCategory;

    //Get inventory from category list
    registered.productCategory!.forEach((element) {
      var temp = element.products!;
      temp.addAll(element.products!);
      // GeneralProvider().inventory = temp;

      return;
    });
  }
}

class Stores {
  String? model() {
    String initData = Shop(
            shopName: Auth().username,
            productCategory: GeneralProvider().categories,
            shopId: Random(0).nextInt(5000))
        .toJson();
  }

  void updateModel()  async{
    storage.retrieveString(Auth().username!).then((value) {
      Shop convert = Shop.fromJson(value!);
      convert.productCategory = GeneralProvider().categories;
      String fullShop = convert.toJson();
    });
  }
}
