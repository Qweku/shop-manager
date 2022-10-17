

import 'package:flutter/material.dart';

final double width = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
final double height = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;


List<Map<String, dynamic>> statusList = [
  {'status':'GHS 3.5K','label':'Total Sales','icon':Icons.monetization_on},
  {'status':'GHS 1.2K','label':'Total Expenses','icon':Icons.auto_graph},
  {'status':'5','label':'Low Stock','icon':Icons.arrow_circle_down},
  {'status':'132','label':'Total Sales','icon':Icons.inventory},
  ];

