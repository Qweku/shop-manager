import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future storeString(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  Future storeStringList(String key, List<String?> value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(key, value as List<String>);
  }

  Future storeInt(String key, int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, value);
  }

  Future storeDouble(String key, double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(key, value);
  }

  Future storeBool(String key, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  Future< String? >retrieveString(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? result = sharedPreferences.getString(key);
    return result;
  }

  Future<List<String?>?> retrieveStringList(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String?>? result = sharedPreferences.getStringList(key);
    return result;
  }

  retrieveInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? result = sharedPreferences.getInt(key);
    return result;
  }

  retrieveDouble(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double? result = sharedPreferences.getDouble(key);
    return result;
  }

  retrieveBool(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? result = sharedPreferences.getBool(key);
    return result;
  }

  Future<bool> isStored(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool result = sharedPreferences.containsKey(key);
    return result;
  }

  removeValues(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }
}
