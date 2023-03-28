import 'package:flutter/material.dart';

import 'package:shop_manager/models/ShopModel.dart';

class SalesProvider extends ChangeNotifier {
  List<SalesModel> _salesList = [];
  List<ExpenseModel> _expenseList = [];

  List<SalesModel> get salesList => _salesList;
  List<ExpenseModel> get expenseList => _expenseList;

  set salesList(List<SalesModel> salesList) {
    _salesList = salesList;
    // notifyListeners();
  }

  set expenseList(List<ExpenseModel> expenseList) {
    _expenseList = expenseList;
    // notifyListeners();
  }

  void addSales(SalesModel salesModel) {
    _salesList.add(salesModel);
    notifyListeners();
  }

  void addExpenses(ExpenseModel expenseModel) {
    _expenseList.add(expenseModel);
    notifyListeners();
  }
}
