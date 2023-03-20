import 'package:flutter/material.dart';

import 'package:shop_manager/models/ShopModel.dart';

class SalesProvider extends ChangeNotifier {
  List<SalesModel> _salesList = [];
  List<SalesModel> _expenseList = [];
  List<SalesModel> _creditList = [];

  List<SalesModel> get salesList => _salesList;
  List<SalesModel> get expenseList => _expenseList;
  List<SalesModel> get creditList => _creditList;

  set salesList(List<SalesModel> salesList) {
    _salesList = salesList;
    notifyListeners();
  }

  set expenseList(List<SalesModel> expenseList) {
    _expenseList = expenseList;
    notifyListeners();
  }

  set creditList(List<SalesModel> creditList) {
    _creditList = creditList;
    notifyListeners();
  }

  void addSales(SalesModel salesModel) {
    _salesList.add(salesModel);
    notifyListeners();
  }

  void addExpenses(SalesModel expenseModel) {
    _expenseList.add(expenseModel);
    notifyListeners();
  }

  void addCredit(SalesModel creditModel) {
    _creditList.add(creditModel);
    notifyListeners();
  }
}
