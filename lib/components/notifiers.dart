import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifier {
  toast(
      {required BuildContext context,
      required String message,
      required Color color,
      int duration: 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: "Louis_George_Cafe",
              )),
          duration: Duration(seconds: duration),
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder()),
    );
    return;
  }
}
