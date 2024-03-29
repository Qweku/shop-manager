

import 'package:flutter/material.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class NotificationIconButton extends StatelessWidget {
  final int quantity;
  final Function()? onTap;
  const NotificationIconButton({Key? key, required this.quantity, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
            onPressed: onTap,
            icon:
                 Icon(Icons.notifications_outlined, color: Responsive.isMobile()?Colors.white:primaryColor, size: Responsive.isMobile()?30:35)),
        Positioned(
            top: height * 0.005,
            left:Responsive.isMobile()? width * 0.03:width*0.01,
            child: quantity == 0
                ? Container()
                : Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 17, 0),
                        shape: BoxShape.circle),
                    child: Text(
                      '${quantity < 10 ? quantity : '9+'}',
                      style: theme.textTheme.bodyText2!.copyWith(fontSize: 9),
                    ),
                  ))
      ],
    );
  }
}