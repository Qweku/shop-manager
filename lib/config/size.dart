import 'package:flutter/widgets.dart';

class SizeConfig{
  static height(context) {
    return MediaQuery.of(context).size.height;
  }

  static width(context) {
    return MediaQuery.of(context).size.width;
  }
}

