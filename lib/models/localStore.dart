import 'dart:async';
import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:localstorage/localstorage.dart';

class LocalStore {
  final LocalStorage keep = LocalStorage('shop_mate');

  void store(String key, String value) {
    // log(value);
    // log(key);
    // keep.ready.then((v) => keep.setItem(key, value));
    keep.setItem(
      key,
      value, /* ((nonEncodable) {
      // log(nonEncodable.toString());
      return value;
    }) */
    );
    var x = keep.getItem(key);
    log("Value: " + x + '\n Key: ' + key);
  }

  Future<String?> retrieve(String key) async {
    String item = '';
    log('Key: ' + key);
    log(keep.getItem(key));
    item = await keep.getItem(key) ?? '';

    return item;

    // return item;
  }

  void delete(String key) {
    keep.ready.then((value) => keep.deleteItem(key));
  }

  void clearall() {
    keep.ready.then((value) => keep.clear());
  }
}
