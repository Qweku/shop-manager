import 'dart:async';

import 'package:shop_manager/models/LocalStorageAccess.dart';
import 'package:shop_manager/models/SharedPreferences.dart';

Storage storage = new Storage();
enum Status { noAccount, invalid, valid, exists, empty, done }

class Auth {
  String? _username;
  String? _password;

  set username(String? username) {
    _username = username; 
  }

  set password(String? password) {
    _password = password;
  }

  String? get username => _username;
  String? get password => _password;

  authenticate() async {
    // await storage.isStored(_username);
    if (await storage.isStored(username!)) {
      if (await storage.retrieveString(username!) == password) {
        return Status.valid;
      } else
        return Status.invalid;
    } else
      return Status.noAccount;
  }

  signup() async {
    await storage.storeString(username!, password!);

    (await storage.isStored("Shops"))
        ? null
        : (await storage.storeStringList("Shops", []));

    List<String?> shopList = await (storage.retrieveStringList("Shops") as FutureOr<List<String?>>);

    if (shopList.contains(username))
      return Status.exists;
    else {
      shopList.add(username);
      await storage.storeStringList("Shops", shopList);
      await storage.storeString(username!, "");
      
      return Status.valid;
    }
  }

  void dummify() {
    username = "Dummy";
    password = "root";
    signup();
    // authenticate();
  }
}
