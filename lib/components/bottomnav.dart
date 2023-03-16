import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class BottomNav extends StatelessWidget {
  final onChange;
  const BottomNav({Key? key, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return FluidNavBar(
      icons: [
        FluidNavBarIcon(
            icon: Icons.category,
            selectedForegroundColor: actionColor,
            //backgroundColor: theme.primaryColor,
            extras: {"label": "catgories"}),
        FluidNavBarIcon(
            icon: Icons.arrow_circle_down_outlined,
            selectedForegroundColor: actionColor,
            //backgroundColor: theme.primaryColor,
            extras: {"label": "add product"}),
        FluidNavBarIcon(
            icon: Icons.dashboard_customize,
            selectedForegroundColor: actionColor,
           // backgroundColor: theme.primaryColor,
            extras: {"label": "dashboard"}),
        FluidNavBarIcon(
            icon:Icons.receipt_long,
             selectedForegroundColor: actionColor,
            extras: {"label": "accounts"}),
          FluidNavBarIcon(
            icon:Icons.inventory,
             selectedForegroundColor: actionColor,
            extras: {"label": "inventory"}),
      ],
      onChange: onChange,
      style: FluidNavBarStyle(
          iconBackgroundColor: primaryColorLight,
          iconUnselectedForegroundColor: primaryColorDark,
          barBackgroundColor: primaryColorLight),
      scaleFactor: 1.5,
      defaultIndex: 2,
      itemBuilder: (icon, item) => Semantics(
        label: icon.extras!["label"],
        child: item,
      ),
    );
  }
}