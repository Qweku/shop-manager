import 'package:flutter/material.dart';
import 'package:shop_manager/models/NotificationModel.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notiList = [];
   int _notiCount = 0;

   int get notiCount => _notiCount;
  List<NotificationModel> get notiList => _notiList;

  set notiList(List<NotificationModel> notiList) {
    _notiList = notiList;
    notifyListeners();
  }

   set notiCount(int notiCount) {
    _notiCount = notiCount;
    notifyListeners();
  }


  void addNotification(NotificationModel notificationModel) {
    _notiList.add(notificationModel);
     notifyListeners();
  }
}
