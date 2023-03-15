import 'package:flutter/material.dart';
import 'package:shop_manager/models/NotificationModel.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notiList = [];

  List<NotificationModel> get notiList => _notiList;

  void addNotification(NotificationModel notificationModel) {
    _notiList.add(notificationModel);
  }
}
