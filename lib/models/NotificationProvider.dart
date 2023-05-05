import 'package:flutter/material.dart';
import 'package:shop_manager/models/NotificationModel.dart';
import 'package:shop_manager/models/services.dart';

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
    saveNotifications();
  }

  void updateNotification(NotificationModel notificationModel) {
    for (NotificationModel element in _notiList) {
      if (element.title == notificationModel.title) {
        element.isRead = !element.isRead;
      }
    }
    notifyListeners();
    saveNotifications();
  }

  saveNotifications() {
    // notifyListeners();
    storage.storeString("notification", notificationModelToJson(_notiList));
  }

  Future<void> retrieveNotifications() async {
    // notifyListeners();
    notiList = List.from(notificationModelFromJson(
        (await storage.retrieveString("notification") ?? '[]')));
  }
}
