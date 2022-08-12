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
            icon: Icons.dashboard,
            selectedForegroundColor: Colors.white,
            //backgroundColor: theme.primaryColor,
            extras: {"label": "downloads"}),
        FluidNavBarIcon(
            icon: Icons.home,
            selectedForegroundColor: Colors.white,
            //backgroundColor: theme.primaryColor,
            extras: {"label": "home"}),
        FluidNavBarIcon(
            icon: Icons.line_axis,
            selectedForegroundColor: Colors.white,
           // backgroundColor: theme.primaryColor,
            extras: {"label": "shop"}),
        // FluidNavBarIcon(
        //     svgPath: "assets/conference.svg",
        //     backgroundColor: Color(0xFF34A950),
        //     extras: {"label": "conference"}),
      ],
      onChange: onChange,
      style: FluidNavBarStyle(
          iconBackgroundColor: theme.primaryColor,
          iconUnselectedForegroundColor: Colors.white,
          barBackgroundColor: theme.primaryColor),
      scaleFactor: 1.5,
      defaultIndex: 1,
      itemBuilder: (icon, item) => Semantics(
        label: icon.extras!["label"],
        child: item,
      ),
    );
  }
}