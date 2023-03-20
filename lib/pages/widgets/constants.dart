import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop_manager/components/responsive.dart';

final double width =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
final double height =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

List<Map<String, dynamic>> statusList = [
  {'status': 'GHS 3.5K', 'label': 'Total Sales', 'icon': Icons.monetization_on},
  {'status': 'GHS 1.2K', 'label': 'Total Expenses', 'icon': Icons.auto_graph},
  {'status': '5', 'label': 'Low Stock', 'icon': Icons.arrow_circle_down},
  {'status': '132', 'label': 'Total Stock', 'icon': Icons.inventory},
];

DateFormat dateformat = DateFormat.yMMMd();
DateFormat salesDateFormat = DateFormat.yMd();
DateFormat timeformat = DateFormat.Hm();

Color primaryColor = const Color(0xFF0D47A1);
Color primaryColorLight = Colors.white;
Color primaryColorDark = const Color.fromARGB(255, 92, 92, 92);
Color actionColor = Color.fromARGB(255, 255, 189, 7);

TextStyle headline1 = TextStyle(
    fontSize: Responsive.isMobile() ? 20 : 25,
    color: const Color.fromARGB(255, 22, 22, 22));

TextStyle headline2 =
    TextStyle(fontSize: Responsive.isMobile() ? 20 : 25, color: Colors.white);
TextStyle bodyText1 = TextStyle(
    fontSize: Responsive.isMobile() ? 12 : 18,
    color: const Color.fromARGB(255, 22, 22, 22));
TextStyle bodyText2 = TextStyle(
    fontSize: Responsive.isMobile() ? 12 : 18,
    color: const Color.fromARGB(255, 255, 255, 255));

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
