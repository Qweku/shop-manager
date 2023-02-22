import 'package:flutter/material.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/Auth/authentication.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Responsive.isMobile()
                ? const Authentication()
                : const TabletAuth()
    );
  }
}
