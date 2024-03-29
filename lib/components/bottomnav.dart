import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final onChange;
  const BottomNav({Key? key, this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FluidNavBar(
      icons: [
        FluidNavBarIcon(
            icon: Icons.category,
            selectedForegroundColor: Colors.white,
            //backgroundColor: theme.primaryColor,
            extras: {"label": "catgories"}),
        FluidNavBarIcon(
            icon: Icons.shopping_bag,
            selectedForegroundColor: Colors.white,
            //backgroundColor: theme.primaryColor,
            extras: {"label": "add product"}),
        FluidNavBarIcon(
            icon: Icons.dashboard_customize,
            selectedForegroundColor: Colors.white,
           // backgroundColor: theme.primaryColor,
            extras: {"label": "dashboard"}),
        FluidNavBarIcon(
            icon:Icons.receipt_long,
             selectedForegroundColor: Colors.white,
            extras: {"label": "accounts"}),
          FluidNavBarIcon(
            icon:Icons.inventory,
             selectedForegroundColor: Colors.white,
            extras: {"label": "inventory"}),
      ],
      onChange: onChange,
      style: FluidNavBarStyle(
          iconBackgroundColor: theme.primaryColor,
          iconUnselectedForegroundColor: Colors.white,
          barBackgroundColor: theme.primaryColor),
      scaleFactor: 1.5,
      defaultIndex: 2,
      itemBuilder: (icon, item) => Semantics(
        label: icon.extras!["label"],
        child: item,
      ),
    );
  }
}