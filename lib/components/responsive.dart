import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  const Responsive({Key? key, this.mobile, this.tablet, this.desktop})
      : super(key: key);

  static bool isMobile() =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width < 800;
  
  static bool isTablet() =>
     MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width >= 800;

  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
       if (constraints.maxWidth >= 800) {
        return tablet!;
      } else {
        return mobile!;
      }
    });
  }
}
